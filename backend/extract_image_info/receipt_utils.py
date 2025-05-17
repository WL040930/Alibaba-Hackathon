import os
import json
import base64
import datetime
import uuid
import re
from openai import OpenAI
from flask import Blueprint, request
import random
import string

def generate_random_id(length=20):
    return ''.join(random.choices(string.ascii_lowercase + string.digits, k=length))


receipt_utils = Blueprint('processReceipt', __name__)

@receipt_utils.route('/process_receipt', methods=['POST'])
def process_receipt_image_base64():
    image_base64 = request.json.get('image_base64')
    """
    Process the receipt image from a base64 string and extract information using the OpenAI API.
    
    Args:
        image_base64 (str): The base64 encoded string of the receipt image.
    
    Returns:
        list: A list of dicts containing the extracted information.
    """
    # Initialize the OpenAI client with your API key and base URL
    client = OpenAI(
        api_key="sk-ac94ccedee394b3ab33d0b9fa637ed83", 
        base_url="https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
    )
    
    # Decode the base64 image data (if needed, here only for local use)
    image_data = base64.b64decode(image_base64)

    # Dynamically fetch categories from Dart enum file or fallback defaults
    categories = []
    try:
        enum_file_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'database', 'food_category_enum.dart') 
        with open(enum_file_path, 'r') as file:
            enum_content = file.read()
        category_matches = re.findall(r'(\w+)\("([^"]+)"', enum_content)
        categories = [cat[1] for cat in category_matches]
        if not categories:
            categories = ["Food", "Beverage", "Transport", "Groceries", "Entertainment", 
                          "Shopping", "Health", "Bills", "Education", "Travel", 
                          "Subscriptions", "Others"]
    except Exception as e:
        print(f"Error reading categories from enum file: {e}")
        categories = ["Food", "Beverage", "Transport", "Groceries", "Entertainment", 
                      "Shopping", "Health", "Bills", "Education", "Travel", 
                      "Subscriptions", "Others"]
    
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")
    
    prompt = f"""Please extract the information from the receipt image. 
Information extracted should include:
1. The item name
2. The price of each item
3. Assign each item to one of the following categories: {', '.join(categories)}

Do not extract the total amount.
Use the current date ({current_date}) for all items.

Format the response as a JSON array with objects containing 'id', 'transactionName', 'category', 'amount', and 'date' fields.
Example:
[
    {{
        "transactionName": "Coffee",
        "category": "Beverage",
        "amount": 5.99,
        "date": "{current_date}"
    }},
    ...
]
"""

    # Call the OpenAI model with the image and prompt
    completion = client.chat.completions.create(
        model="qwen-vl-max",
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": prompt
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{image_base64}"
                        }
                    }
                ]
            }
        ],
    )
    
    if completion and completion.choices:
        response_text = completion.choices[0].message.content.strip()
        print("Raw API Response:", response_text)
        
        try:
            # Try to extract JSON array from response
            json_match = re.search(r'\[\s*\{.*\}\s*\]', response_text, re.DOTALL)
            if json_match:
                json_str = json_match.group(0)
                extracted_info = json.loads(json_str)
            else:
                extracted_info = json.loads(response_text)
            
            # Normalize keys and add missing fields
            for item in extracted_info:
                # Normalize keys
                item['transactionName'] = item.get('transactionName') or item.pop('item', 'Unknown Item')
                item['amount'] = item.get('amount') or item.pop('price', 0.0)
                item['category'] = item.get('category', 'Others')
                item['date'] = item.get('date', current_date)
                item['id'] = item.get('id', generate_random_id())
            
            # Save to local JSON file for debug
            output_file_path = os.path.join(os.path.dirname(__file__), 'extracted_info.json')
            with open(output_file_path, 'w') as output_file:
                json.dump(extracted_info, output_file, indent=4)
                print(f"Extracted information saved to {output_file_path}")
            
            return extracted_info
        
        except json.JSONDecodeError:
            print("Failed to parse response as JSON, attempting fallback extraction.")
            try:
                # Fallback: parse text lines
                lines = response_text.split('\n')
                items = []
                current_item = {}
                for line in lines:
                    if ':' in line:
                        key, value = line.split(':', 1)
                        key = key.strip().lower()
                        value = value.strip()
                        if key in ['item', 'name']:
                            if current_item and 'transactionName' in current_item:
                                items.append(current_item)
                                current_item = {}
                            current_item['transactionName'] = value
                        elif key == 'category':
                            current_item['category'] = value
                        elif key == 'price':
                            price_match = re.search(r'\d+(\.\d+)?', value)
                            if price_match:
                                current_item['amount'] = float(price_match.group(0))
                            else:
                                current_item['amount'] = value
                if current_item and 'transactionName' in current_item:
                    items.append(current_item)
                for item in items:
                    if 'id' not in item:
                        item['id'] = str(uuid.uuid4())
                    if 'date' not in item:
                        item['date'] = current_date
                if items:
                    return items
            except Exception as e:
                print(f"Fallback extraction failed: {e}")
            return None
    else:
        print("No valid response received from the API.")
        return None

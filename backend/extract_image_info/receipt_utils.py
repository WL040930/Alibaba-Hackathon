import os
import json
import base64
import datetime
from openai import OpenAI

def process_receipt_image_base64(image_base64):
    """
    Process the receipt image from a base64 string and extract information using the OpenAI API.
    
    Args:
        image_base64 (str): The base64 encoded string of the receipt image.
    
    Returns:
        dict: A dictionary containing the extracted information.
    """
    # Initialize the OpenAI client with the API key from the environment variable
    client = OpenAI(
        api_key="sk-ac94ccedee394b3ab33d0b9fa637ed83", 
        base_url="https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
    )
    
    # Decode the base64 image data
    image_data = base64.b64decode(image_base64)

    # Dynamically fetch categories 
    categories = []
    try:
        # Read the food_category_enum.dart file
        enum_file_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'database', 'food_category_enum.dart') # Adjust the filepath 
        with open(enum_file_path, 'r') as file:
            enum_content = file.read()
            
        # Extract category names using regex
        import re
        category_matches = re.findall(r'(\w+)\("([^"]+)"', enum_content)
        categories = [category[1] for category in category_matches]
        
        if not categories:
            # Fallback if regex doesn't match
            categories = ["Food", "Beverage", "Transport", "Groceries", "Entertainment", 
                         "Shopping", "Health", "Bills", "Education", "Travel", 
                         "Subscriptions", "Others"]
    except Exception as e:
        print(f"Error reading categories from enum file: {e}")
        # Fallback to default categories
        categories = ["Food", "Beverage", "Transport", "Groceries", "Entertainment", 
                     "Shopping", "Health", "Bills", "Education", "Travel", 
                     "Subscriptions", "Others"]
    
    # Get current date in YYYY-MM-DD format
    current_date = datetime.datetime.now().strftime("%Y-%m-%d")
    
    prompt = f"""Please extract the information from the receipt image. 
    Information extracted should include:
    1. The item name
    2. The price of each item
    3. Assign each item to one of the following categories: {', '.join(categories)}
    
    Do not extract the total amount.
    Use the current date ({current_date}) for all items.
    
    Format the response as a JSON array with objects containing 'item', 'category', 'price', and 'date' fields and 
    give a unique ID. Save the result in a json array format.
    Example: 
    [
        {{
            "ID": 1,
            "item": "Coffee",
            "category": "Beverage",
            "price": 5.99,
            "date": "{current_date}"
        }},
        {{
            "ID": 2,
            "item": "Sandwich",
            "category": "Food",
            "price": 8.50,
            "date": "{current_date}"
        }}
    ]
    """

    # Call the Qwen-VL-Max model with image data
    # Note: This is a hypothetical example. Replace with the actual method if supported.
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
                        # Include the data URI scheme header
                        "url": f"data:image/jpeg;base64,{image_base64}"
                        # Change image/jpeg if your image is a different format (e.g., image/png)
                    }
                }
            ]
            }
        ],
        
    )
    
    # Extract and return the information from the completion
    if completion and completion.choices:
        response_text = completion.choices[0].message.content.strip()
        print("Raw API Response:", response_text)
        
        try:
            # Try to extract JSON from the response text
            # First, look for JSON array pattern
            import re
            json_match = re.search(r'\[\s*\{.*\}\s*\]', response_text, re.DOTALL)
            
            if json_match:
                json_str = json_match.group(0)
                extracted_info = json.loads(json_str)
            else:
                # If no JSON array pattern found, try parsing the whole response
                extracted_info = json.loads(response_text)
            
            # Ensure all items have the current date
            current_date = datetime.datetime.now().strftime("%Y-%m-%d")
            if isinstance(extracted_info, list):
                for item in extracted_info:
                    if 'date' not in item:
                        item['date'] = current_date
            
            # Save the extracted information to a JSON file
            output_file_path = os.path.join(os.path.dirname(__file__), 'extracted_info.json')
            with open(output_file_path, 'w') as output_file:
                json.dump(extracted_info, output_file, indent=4)
                print(f"Extracted information saved to {output_file_path}")
            return extracted_info
        
        except json.JSONDecodeError:
            print("Failed to parse the response as JSON.")
            # Try to extract structured data even if JSON parsing fails
            try:
                # Create a simple structure based on text analysis
                lines = response_text.split('\n')
                items = []
                current_item = {}
                
                for line in lines:
                    if ':' in line:
                        key, value = line.split(':', 1)
                        key = key.strip().lower()
                        value = value.strip()
                        
                        if key == 'item' or key == 'name':
                            if current_item and 'item' in current_item:
                                items.append(current_item)
                                current_item = {}
                            current_item['item'] = value
                        elif key == 'category':
                            current_item['category'] = value
                        elif key == 'price':
                            # Try to extract numeric price
                            price_match = re.search(r'\d+(\.\d+)?', value)
                            if price_match:
                                current_item['price'] = float(price_match.group(0))
                            else:
                                current_item['price'] = value
                
                if current_item and 'item' in current_item:
                    items.append(current_item)
                
                # Add current date to all items
                for item in items:
                    item['date'] = current_date
                
                if items:
                    return items
            except Exception as e:
                print(f"Failed to extract structured data: {e}")
            
            return None
    else:
        print("No valid response received from the API.")
        return None


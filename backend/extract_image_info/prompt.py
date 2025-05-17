import sys
import os
import base64

# Import the function from extract_image_info.py
# Add the current directory to the Python path
sys.path.append(os.path.dirname(__file__))
from receipt_utils import process_receipt_image_base64

#Not needed when combined with other parts
def image_to_base64(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

def main():
    image_path = '.\\backend\\receipt\\Receipt.jpg' # May remove when combined because image is already saved in base 64
    
    # Convert image to base64
    image_base64 = image_to_base64(image_path) #remove when combine
    
    # Use the function that accepts base64 image
    extracted_info = process_receipt_image_base64(image_base64)
    
    if extracted_info:
        print("Extracted Information:")
        print(extracted_info)

if __name__ == "__main__":
    main()

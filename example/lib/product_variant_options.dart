const productVariantOptions = {
  "name": "Product Variant API",
  "description": "API for creating and managing product variants",
  "renders": ["application/json", "text/html"],
  "parses": [
    "application/json",
    "application/x-www-form-urlencoded",
    "multipart/form-data"
  ],
  "actions": {
    "POST": {
      "attributes": {
        "type": "multifield",
        "required": true,
        "read_only": false,
        "label": "Attributes",
        "multiple": true,
        "choices": [
          {"display_name": "Size - Large", "value": 2},
          {"display_name": "Color - Green", "value": 1},
          {"display_name": "Size - Medium", "value": 3},
          {"display_name": "Size - Small", "value": 4},
          {"display_name": "Color - Blue", "value": 5},
          {"display_name": "Color - Red", "value": 6},
        ],
        "placeholder": "Select product attributes"
      },
      "name": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Product Name",
        "max_length": 255,
        "placeholder": "Enter product name"
      },
      "nickname": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Nickname",
        "max_length": 255,
        "placeholder": "Enter product nickname"
      },
      "price": {
        "type": "float",
        "required": true,
        "read_only": false,
        "label": "Price",
        "placeholder": "Enter price (e.g., 2500.00)"
      },
      "sku": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "SKU",
        "max_length": 50,
        "placeholder": "Enter SKU code"
      },
      "original_file": {
        "type": "file",
        "required": false,
        "read_only": false,
        "label": "Original File",
        "placeholder": "Upload original file"
      }
    }
  }
};
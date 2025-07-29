const shopOptions = {
  "name": "Shop Create API",
  "description": "API for creating and managing shops",
  "renders": ["application/json", "text/html"],
  "parses": [
    "application/json",
    "application/x-www-form-urlencoded",
    "multipart/form-data"
  ],
  "actions": {
    "POST": {
      "name": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Shop Name",
        "max_length": 255,
        "placeholder": "Enter shop name"
      },
      "description": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Description",
        "max_length": 1000,
        "placeholder": "Describe your shop"
      },
      "location": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Location",
        "max_length": 255,
        "placeholder": "Enter shop location"
      },
      "support_email": {
        "type": "email",
        "required": false,
        "read_only": false,
        "label": "Support Email",
        "max_length": 255,
        "placeholder": "support@example.com"
      },
      "support_phone": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Support Phone",
        "max_length": 20,
        "placeholder": "+1234567890"
      },
      "image": {
        "type": "image",
        "required": false,
        "read_only": false,
        "label": "Shop Image",
        "placeholder": "Upload shop image"
      },
      "banner_image": {
        "type": "image",
        "required": false,
        "read_only": false,
        "label": "Banner Image",
        "placeholder": "Upload banner image"
      },
      "user": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "Assign User",
        "url": "api/v1/users",
        "instance_url": "api/v1/users/",
        "display_name": "username",
        "search_field": "username",
        "value_field": "id",
        "placeholder": "Search for user..."
      }
    }
  }
};
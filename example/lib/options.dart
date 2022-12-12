const options = {
  "name": "List Create Shops Api",
  "description": "",
  "renders": ["application/json", "text/html"],
  "parses": [
    "application/json",
    "application/x-www-form-urlencoded",
    "multipart/form-data"
  ],
  "actions": {
    "POST": {
      "id": {
        "type": "integer",
        "required": false,
        "read_only": true,
        "label": "ID"
      },
      "created": {
        "type": "datetime",
        "required": false,
        "read_only": true,
        "label": "Created"
      },
      "modified": {
        "type": "datetime",
        "required": false,
        "read_only": true,
        "label": "Modified"
      },
      "active": {
        "type": "boolean",
        "required": false,
        "read_only": false,
        "label": "Active"
      },
      "contact_name": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Contact name",
        "max_length": 45,
        "placeholder": "The name of the customer to deliver to"
      },
      "contact_phone": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Contact phone",
        "max_length": 25
      },
      "contact_email": {
        "type": "email",
        "required": false,
        "read_only": false,
        "label": "Contact email",
        "max_length": 100
      },
      "name": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Name",
        "max_length": 45
      },
      "image": {
        "type": "file",
        "required": false,
        "read_only": false,
        "label": "Shop Logo",
        "max_length": 100
      },
      "role": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "Role",
        "max_length": 4,
        "choices": [
          {"value": "TSC", "display_name": "TSC"},
          {"value": "BRD", "display_name": "BOM"}
        ]
      },
      "location": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Location",
        "max_length": 400
      },
      "created_by": {
        "type": "field",
        "required": false,
        "read_only": true,
        "label": "Created by"
      }
    }
  }
};

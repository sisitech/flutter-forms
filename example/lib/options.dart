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
        "type": "date",
        "required": false,
        "read_only": false,
        "label": "Modified"
      },
      "active": {
        "type": "boolean",
        "required": true,
        "read_only": false,
        "label": "Active"
      },
      "contact_name": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "Contact name",
        "url": "api/v1/users",
        "display_name": "username",
        "search_field": "username",
        "max_length": 45,
        "select_first": true,
        "placeholder": "The name of the customer to deliver to"
      },
      "contact_email": {
        "type": "multifield",
        "required": false,
        "read_only": false,
        "label": "Contact Email",
        "url": "api/v1/users",
        "display_name": "username",
        "search_field": "username",
        "max_length": 45,
        "value_field": "email",
        "placeholder": "Search by username ...",
        "show_only": true,
        "show_only_field": "require_serial_number",
        "show_reset_value": false
      },
      "contact_phone": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Contact phone",
        "obscure": true,
        "max_length": 25
      },
      "name": {
        "type": "string",
        "required": false,
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
        "type": "multifield",
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

# MyCustomForm Setup Guide

## Quick Start

### 1. Basic Setup

```dart
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';

MyCustomForm(
  name: "TeacherForm",
  formItems: teacherOptions,
  formGroupOrder: const [
    ['first_name', 'last_name'],
    ['email'],
  ],
  url: "api/v1/teachers",
  onSuccess: (res) => print("Success: $res"),
)
```

### 2. Form Options Structure

Forms use Django REST Framework OPTIONS response format:

```dart
const teacherOptions = {
  "name": "Teacher Form",
  "actions": {
    "POST": {
      "first_name": {
        "type": "string",
        "required": true,
        "label": "First Name",
        "max_length": 45
      },
      "email": {
        "type": "email",
        "required": true,
        "label": "Email Address"
      },
      // ... more fields
    }
  }
};
```

## Field Types

### Basic Types

```dart
// String input
"first_name": {
  "type": "string",
  "required": true,
  "label": "First Name",
  "max_length": 45
}

// Integer input
"age": {
  "type": "integer",
  "required": true,
  "label": "Age"
}

// Email input
"email": {
  "type": "email",
  "required": true,
  "label": "Email"
}

// Alphabets only
"name": {
  "type": "alphabets",
  "required": true,
  "label": "Name"
}
```

### Date/Time Fields

```dart
// Date picker
"created": {
  "type": "date",
  "required": false,
  "label": "Created Date",
  "start_value": "1985-08-14",  // Min date
  "end_value": "today"           // Max date (or specific date)
}

// DateTime picker
"appointment": {
  "type": "datetime",
  "required": true,
  "label": "Appointment Time"
}
```

### Choice Fields

```dart
// Single select dropdown
"role": {
  "type": "choice",
  "required": true,
  "label": "Role",
  "choices": [
    {"value": "TSC", "display_name": "TSC Teacher"},
    {"value": "BOM", "display_name": "BOM Teacher"}
  ]
}

// From storage container
"category": {
  "type": "choice",
  "required": false,
  "label": "Category",
  "storage": "categorys",  // GetStorage container
  "display_name": "name"
}

// From API
"department": {
  "type": "choice",
  "required": false,
  "label": "Department",
  "url": "api/v1/departments",
  "display_name": "name"
}
```

### Boolean Fields

```dart
"is_active": {
  "type": "boolean",
  "required": false,
  "label": "Active Status"
}
```

### File/Image Fields

```dart
// Image picker
"receipt": {
  "type": "image",
  "required": false,
  "label": "Receipt Image",
  "placeholder": "Upload receipt photo"
}

// File picker
"attachment": {
  "type": "file",
  "required": false,
  "label": "Supporting Document",
  "placeholder": "Upload file"
}
```

### Field - Autocomplete Single Select

```dart
"contact_name": {
  "type": "field",
  "required": false,
  "label": "Contact Name",
  "url": "api/v1/contacts",
  "display_name": "name",
  "search_field": "name",
  "placeholder": "Search contact...",
  "select_first": false  // Auto-select first option
}

// Field with static choices
"tag_rule_type": {
  "type": "field",
  "required": false,
  "label": "Rule Type",
  "display_name": "name",
  "choices": [
    {"value": "AMNT", "display_name": "Name Only"},
    {"value": "BRD", "display_name": "Name and Account"}
  ]
}
```

### Multifield - Multi-select with Search

```dart
// Basic multifield
"contact_email": {
  "type": "multifield",
  "required": false,
  "label": "Contact Email",
  "url": "api/v1/users",
  "display_name": "username",
  "search_field": "username",
  "value_field": "email",
  "placeholder": "Search by username...",
  "show_reset_value": false,
  "multiple": true  // Allow multiple selections
}

// Multifield from storage
"category": {
  "type": "multifield",
  "multiple": false,
  "required": false,
  "fetch_first": true,  // Load data immediately
  "label": "Select Category",
  "storage": "categorys",  // GetStorage container
  "display_name": "name",
  "search_field": "name",
  "value_field": "id",
  "placeholder": "Search by name...",
  "show_reset_value": true
}

// Dependent multifield (filtered by another field)
"subcategory": {
  "type": "multifield",
  "multiple": false,
  "required": false,
  "label": "Select Subcategory",
  "storage": "subCategorys",
  "from_field": "category",  // Parent field
  "from_field_value_field": "category",  // Filter key
  "display_name": "name",
  "value_field": "id",
  "placeholder": "Select category first..."
}
```

### Conditional Fields

```dart
// Show field only when another field has specific value
"tsc_no": {
  "type": "integer",
  "required": true,
  "label": "TSC Number",
  "show_only": "TSC",  // Value of the from_field
  "from_field": "role"  // Parent field to watch
}
```

## Form Configuration

### Basic Form

```dart
MyCustomForm(
  name: "TeacherForm",  // Unique form identifier
  formItems: teacherOptions,  // Field definitions
  formGroupOrder: const [  // Layout structure
    ['first_name', 'last_name'],  // 2 fields in one row
    ['email'],  // 1 field in one row
  ],
  url: "api/v1/teachers",
  onSuccess: (res) {
    print("Saved: $res");
    Get.back();
  },
)
```

### Form with Instance (Update Mode)

```dart
MyCustomForm(
  name: "UpdateTeacher",
  formItems: teacherOptions,
  status: FormStatus.Update,  // or Add, Delete, Replace
  instance: {
    "id": 34,
    "first_name": "John",
    "last_name": "Doe",
    "email": "john@example.com"
  },
  url: "api/v1/teachers",
  instanceUrl: "api/v1/teachers",  // Optional custom update URL
  formGroupOrder: const [
    ['first_name', 'last_name'],
    ['email'],
  ],
  onSuccess: (res) => print("Updated"),
)
```

### Content Types

```dart
// JSON (default)
MyCustomForm(
  contentType: ContentType.json,  // Sends as application/json
  // ...
)

// Form URL Encoded
MyCustomForm(
  contentType: ContentType.form_url_encoded,
  // ...
)

// Multipart (auto-detected for file/image uploads)
// No need to specify, automatically uses multipart when files present
```

### Extra Fields

```dart
MyCustomForm(
  url: "o/token/",
  extraFields: {
    "client_id": config.clientId,
    "grant_type": "password",
  },
  // These fields are added to submission but not shown in form
)
```

### Pre-Save Transformation

```dart
MyCustomForm(
  PreSaveData: (formData) {
    // Transform data before submission
    formData['created_at'] = DateTime.now().toIso8601String();
    formData['phone'] = formData['phone']?.replaceAll('-', '');
    return formData;
  },
)
```

### Custom Validation

```dart
MyCustomForm(
  customDataValidation: (formData) {
    // Custom validation logic
    if (formData['age'] < 18) {
      return {"age": "Must be 18 or older"};
    }
    if (formData['email']?.contains('@') == false) {
      return {"email": "Invalid email format"};
    }
    return null;  // Valid
  },
)
```

### Error Handling

```dart
MyCustomForm(
  handleErrors: (errors) {
    // Custom error message
    return "Something went wrong. Please try again.";
  },
)
```

### Dynamic URLs

```dart
MyCustomForm(
  getDynamicUrl: (formData) {
    // Generate URL based on form data
    if (formData['type'] == 'teacher') {
      return "api/v1/teachers";
    }
    return "api/v1/students";
  },
)
```

### Validate Only Mode

```dart
MyCustomForm(
  isValidateOnly: true,  // Don't submit, just validate
  onSuccess: (formData) {
    // Use validated data
    print("Valid data: $formData");
  },
)
```

### Form Controller Access

```dart
FormController? controller;

MyCustomForm(
  onControllerSetup: (contr) {
    controller = contr;
    // Access controller methods
  },
  onSuccess: (res) {
    // Manually set field errors
    controller?.form.control('email').setErrors({"custom": "Email taken"});
    controller?.form.control('email').markAsTouched();
  },
)
```

### UI Customization

```dart
MyCustomForm(
  formTitle: "Add Teacher",
  formTitleStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),

  formHeader: Column(
    children: [
      Icon(Icons.person_add, size: 48),
      Text("Create New Teacher Account"),
    ],
  ),

  formFooter: Padding(
    padding: EdgeInsets.all(20),
    child: Text("* Required fields"),
  ),

  formPreFooter: Divider(),

  submitButtonText: "Save Teacher",
  submitButtonPreText: "Submit",
  loadingMessage: "Saving teacher...",

  displayRequiredFieldsOnValidate: true,  // Show required fields message
)
```

## Complete Examples

### Simple Form

```dart
MyCustomForm(
  name: "ContactForm",
  formItems: {
    "actions": {
      "POST": {
        "name": {
          "type": "string",
          "required": true,
          "label": "Name"
        },
        "email": {
          "type": "email",
          "required": true,
          "label": "Email"
        },
        "message": {
          "type": "string",
          "required": true,
          "label": "Message"
        }
      }
    }
  },
  formGroupOrder: const [
    ['name'],
    ['email'],
    ['message']
  ],
  url: "api/v1/contacts",
  onSuccess: (res) {
    Get.snackbar("Success", "Message sent!");
    Get.back();
  },
)
```

### Form with Dependent Fields

```dart
MyCustomForm(
  name: "LocationForm",
  formItems: locationOptions,
  formGroupOrder: const [
    ['county'],
    ['district'],  // Filtered by county
    ['ward'],      // Filtered by district
  ],
  url: "api/v1/locations",
  onSuccess: (res) => Get.back(),
)

// Options structure:
const locationOptions = {
  "actions": {
    "POST": {
      "county": {
        "type": "choice",
        "required": true,
        "label": "County",
        "storage": "counties",
        "display_name": "name"
      },
      "district": {
        "type": "multifield",
        "required": true,
        "label": "District",
        "storage": "districts",
        "from_field": "county",
        "from_field_value_field": "county",
        "display_name": "name"
      },
      "ward": {
        "type": "multifield",
        "required": true,
        "label": "Ward",
        "storage": "wards",
        "from_field": "district",
        "from_field_value_field": "district",
        "display_name": "name"
      }
    }
  }
};
```

### Form with File Upload

```dart
MyCustomForm(
  name: "DocumentForm",
  formItems: {
    "actions": {
      "POST": {
        "title": {
          "type": "string",
          "required": true,
          "label": "Document Title"
        },
        "category": {
          "type": "choice",
          "required": true,
          "label": "Category",
          "choices": [
            {"value": "invoice", "display_name": "Invoice"},
            {"value": "receipt", "display_name": "Receipt"}
          ]
        },
        "file": {
          "type": "file",
          "required": true,
          "label": "Upload Document"
        }
      }
    }
  },
  formGroupOrder: const [
    ['title'],
    ['category'],
    ['file']
  ],
  url: "api/v1/documents",
  contentType: ContentType.json,  // Auto-switches to multipart with files
  onSuccess: (res) => print("Uploaded: ${res}"),
)
```

### Update Form with Multifield Instance

```dart
MyCustomForm(
  name: "UpdateTeacher",
  formItems: teacherOptions,
  status: FormStatus.Update,
  instance: {
    "id": 34,
    "first_name": "John",
    "role": 1,
    "phone": ["121", "12", "13"],
    "multifield": {
      "phone": [
        FormChoice(display_name: "Phone 1", value: "121"),
        FormChoice(display_name: "Phone 2", value: "12"),
        FormChoice(display_name: "Phone 3", value: "13"),
      ]
    }
  },
  formGroupOrder: const [
    ['first_name'],
    ['role'],
    ['phone'],  // Multifield will be pre-populated
  ],
  url: "api/v1/teachers",
)
```

### Form with Conditional Fields

```dart
MyCustomForm(
  name: "TeacherForm",
  formItems: {
    "actions": {
      "POST": {
        "role": {
          "type": "choice",
          "required": true,
          "label": "Teacher Type",
          "choices": [
            {"value": "TSC", "display_name": "TSC Teacher"},
            {"value": "BOM", "display_name": "BOM Teacher"}
          ]
        },
        "tsc_no": {
          "type": "string",
          "required": true,
          "label": "TSC Number",
          "show_only": "TSC",  // Only shows when role == "TSC"
          "from_field": "role"
        },
        "contract_end": {
          "type": "date",
          "required": true,
          "label": "Contract End Date",
          "show_only": "BOM",  // Only shows when role == "BOM"
          "from_field": "role"
        }
      }
    }
  },
  formGroupOrder: const [
    ['role'],
    ['tsc_no'],
    ['contract_end'],
  ],
  url: "api/v1/teachers",
)
```

## Storage Setup for Offline Data

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage containers
  await GetStorage.init();
  await GetStorage.init('school');

  // Populate storage with data
  final box = GetStorage('school');
  await box.write('categorys', [
    {"id": 1, "name": "Category 1"},
    {"id": 2, "name": "Category 2"},
  ]);

  runApp(MyApp());
}
```

## Form Status Types

```dart
FormStatus.Add      // POST request (default)
FormStatus.Update   // PATCH request
FormStatus.Replace  // PUT request
FormStatus.Delete   // DELETE request
```

## Common Patterns

### Login Form

```dart
MyCustomForm(
  name: "LoginForm",
  formItems: loginOptions,
  url: "o/token/",
  contentType: ContentType.form_url_encoded,
  extraFields: {
    "client_id": config.clientId,
    "grant_type": "password",
  },
  formGroupOrder: const [
    ["username"],
    ["password"]
  ],
  onSuccess: (res) async {
    await authCont.saveToken(res);
    Get.offAllNamed('/home');
  },
)
```

### Search Form

```dart
MyCustomForm(
  name: "SearchForm",
  formItems: searchOptions,
  isValidateOnly: true,
  formGroupOrder: const [
    ['query'],
    ['category'],
    ['date_from', 'date_to'],
  ],
  onSuccess: (formData) {
    // Use search parameters
    controller.search(formData);
  },
)
```

### Multi-Step Form (Using Form Controller)

```dart
FormController? controller;

MyCustomForm(
  name: "Step1",
  onControllerSetup: (contr) => controller = contr,
  isValidateOnly: true,
  onSuccess: (data) {
    // Save to state and move to next step
    Get.to(Step2Form(initialData: data));
  },
)
```

## Field Properties Reference

| Property | Type | Description |
|----------|------|-------------|
| `type` | String | Field type (string, integer, choice, etc.) |
| `required` | bool | Field is required |
| `read_only` | bool | Field is read-only |
| `label` | String | Display label |
| `max_length` | int | Max character length |
| `placeholder` | String | Placeholder text |
| `default` | dynamic | Default value |
| `choices` | List | Static choices for choice/field types |
| `url` | String | API endpoint for dynamic data |
| `storage` | String | GetStorage container for offline data |
| `display_name` | String | Field to display from choice data |
| `value_field` | String | Field to use as value |
| `search_field` | String | Field to search in multifield |
| `from_field` | String | Parent field for dependent fields |
| `from_field_value_field` | String | Field to filter by |
| `show_only` | String | Show field only when parent has this value |
| `fetch_first` | bool | Load data immediately for multifield |
| `select_first` | bool | Auto-select first option |
| `multiple` | bool | Allow multiple selections |
| `show_reset_value` | bool | Show reset/clear button |
| `start_value` | String | Min date for date fields |
| `end_value` | String | Max date for date fields |

# Flutter Form Documentation

A comprehensive Flutter package for dynamic form generation with offline support, using GetX for state management and reactive_forms for form handling.

## Table of Contents

1. [Package Overview](#package-overview)
2. [Field Types](#field-types)
3. [FormItemField Properties](#formitemfield-properties)
4. [MyCustomForm Widget](#mycustomform-widget)
5. [Controllers](#controllers)
6. [Callbacks](#callbacks)
7. [Offline Support](#offline-support)
8. [Theming](#theming)

---

## Package Overview

### Dependencies

- `get: ^4.6.5` - State management (GetX)
- `reactive_forms: ^17.0.1` - Form handling and validation
- `flutter_utils` - Sisitech utility package
- `flutter_auth` - Sisitech authentication package
- `flex_color_scheme: ^7.3.1` - Theming support

### Architecture

```
MyCustomForm (Widget)
    └── FormController (GetxController)
            ├── FormGroup (reactive_forms)
            ├── List<FormItemField> (field definitions)
            └── InputController[] (per-field controllers)
```

### HTTP Method Mapping

| FormStatus | HTTP Method |
|------------|-------------|
| `Add` | POST |
| `Update` | PATCH |
| `Replace` | PUT |
| `Delete` | DELETE |

---

## Field Types

### FieldType Enum

| Type | Description | FormControl Type | Keyboard/Widget |
|------|-------------|------------------|-----------------|
| `string` | Text input | `FormControl<String>` | Text |
| `text` | Multi-line text (max_length > 300) | `FormControl<String>` | Multiline |
| `alphabets` | Letters and spaces only | `FormControl<String>` | Text + filter |
| `integer` | Whole numbers | `FormControl<String>` | Number |
| `float` | Decimal numbers | `FormControl<String>` | Decimal |
| `email` | Email address | `FormControl<String>` | Email |
| `date` | Date picker | `FormControl<DateTime>` | ReactiveDatePicker |
| `datetime` | Date and time picker | `FormControl<DateTime>` | ReactiveDateTimePicker |
| `time` | Time picker | `FormControl<TimeOfDay>` | ReactiveTimePicker |
| `choice` | Static dropdown | `FormControl<Object>` | Dropdown |
| `field` | API-loaded dropdown | `FormControl<Object>` | Dropdown |
| `multifield` | Multi-select | `FormControl<List<String>?>` | MultiSelect |
| `boolean` | Checkbox | `FormControl<bool>` | Checkbox |
| `file` | File picker | `FormControl<String>` | FilePicker |
| `image` | Image picker | `FormControl<String>` | ImagePicker |

### Field Type Examples

```dart
// String field
"name": {
  "type": "string",
  "label": "Full Name",
  "required": true,
  "max_length": 100
}

// Date with range
"birth_date": {
  "type": "date",
  "label": "Birth Date",
  "start_value": "1950-01-01",
  "end_value": "today"
}

// Time picker (serializes to "HH:mm")
"start_time": {
  "type": "time",
  "label": "Start Time",
  "required": true
}

// DateTime picker
"appointment": {
  "type": "datetime",
  "label": "Appointment",
  "start_value": "2020-01-01",
  "end_value": "today"
}

// API dropdown
"department": {
  "type": "field",
  "label": "Department",
  "url": "/api/departments/",
  "display_name": "name",
  "value_field": "id",
  "select_first": true
}

// Multi-select with static choices
"roles": {
  "type": "multifield",
  "label": "Roles",
  "multiple": true,
  "choices": [
    {"display_name": "Admin", "value": "admin"},
    {"display_name": "User", "value": "user"}
  ]
}

// Dependent field (cascading)
"subcategory": {
  "type": "field",
  "label": "Subcategory",
  "url": "/api/subcategories/",
  "from_field": "category",
  "from_field_value_field": "category_id"
}

// Conditional visibility
"tsc_number": {
  "type": "string",
  "label": "TSC Number",
  "from_field": "role",
  "show_only": "teacher"
}
```

---

## FormItemField Properties

### Core Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | `String` | required | Field identifier in form data |
| `label` | `String` | required | Display label |
| `type` | `FieldType` | required | Field type enum |
| `required` | `bool` | `false` | Adds required validator |
| `read_only` | `bool` | `false` | Prevents editing |
| `placeholder` | `String?` | `null` | Hint text |

### Text Field Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `max_length` | `int?` | `null` | Character limit (>300 = multiline) |
| `obscure` | `bool?` | `null` | Hide input (passwords) |

### Date Field Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `start_value` | `String?` | `null` | Min date ("YYYY-MM-DD" or "today") |
| `end_value` | `String?` | `null` | Max date ("YYYY-MM-DD" or "today") |

### Selection Field Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `choices` | `List<FormChoice>?` | `null` | Static options |
| `url` | `String?` | `null` | API endpoint for options |
| `storage` | `String?` | `null` | GetStorage key for cached options |
| `display_name` | `String` | `"name"` | Field in response for display text |
| `value_field` | `String` | `"id"` | Field in response for value |
| `search_field` | `String` | `"name"` | Field to search on |
| `select_first` | `bool` | `false` | Auto-select first option |
| `fetch_first` | `bool` | `false` | Load options on init |
| `multiple` | `bool` | `false` | Allow multiple selections |
| `instance_url` | `String?` | `null` | Override URL for updates |

### Dependency Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `from_field` | `String?` | `null` | Parent field name |
| `from_field_value_field` | `String?` | `null` | Filter parameter key |
| `from_field_source` | `String?` | `null` | Nested array path in parent data |
| `show_only` | `dynamic?` | `null` | Show when parent equals this value |
| `show_only_field` | `String?` | `null` | Remote field to check for visibility |

### Other Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `show_reset_value` | `bool?` | `null` | Show reset/clear button |
| `hasController` | `bool` | `false` | Internal: InputController exists |

---

## MyCustomForm Widget

### Basic Usage

```dart
MyCustomForm(
  name: "user_form",
  formItems: formConfig,
  formGroupOrder: [
    ["first_name", "last_name"],
    ["email"],
  ],
  url: "/api/users/",
  onSuccess: (data) => Get.back(),
)
```

### All Parameters

#### Form Structure

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | `String` | Yes | Unique form identifier (GetX tag) |
| `formItems` | `Map<String, dynamic>` | Yes | Form configuration with field definitions |
| `formGroupOrder` | `List<List<String>>` | Yes | Layout grid (rows of field names) |
| `url` | `String?` | No | API endpoint for submission |
| `instanceUrl` | `String?` | No | Override URL for update/delete |
| `instance` | `Map<String, dynamic>?` | No | Pre-fill data for editing |
| `extraFields` | `Map<String, dynamic>?` | No | Additional data to include in submission |
| `status` | `FormStatus` | No | Add/Update/Replace/Delete (default: Add) |
| `contentType` | `ContentType` | No | json or form_url_encoded (default: json) |
| `isValidateOnly` | `bool` | No | Validate without submitting |

#### UI Customization

| Parameter | Type | Description |
|-----------|------|-------------|
| `formTitle` | `String?` | Title text at top of form |
| `formTitleStyle` | `TextStyle?` | Style for title |
| `formHeader` | `Widget?` | Custom header widget |
| `formFooter` | `Widget?` | Widget below submit button |
| `formPreFooter` | `Widget?` | Widget above submit button |
| `submitButtonText` | `String?` | Custom button text |
| `submitButtonPreText` | `String?` | Text prefix (default: status name) |
| `loadingMessage` | `String` | Loading text (default: "Loading ...") |
| `displayRequiredFieldsOnValidate` | `bool` | Show required fields on validation error |

#### Offline Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enableOfflineMode` | `bool` | `false` | Enable offline functionality |
| `enableOfflineSave` | `bool` | `false` | Save forms when offline |
| `showOfflineMessage` | `bool` | `false` | Display network status |
| `offlineMessage` | `String?` | `null` | Custom offline text |
| `offlineMessageColor` | `Color?` | `null` | Offline message color |
| `storageContainer` | `String` | `"GetStorage"` | Storage container name |
| `offlineStorageContainer` | `String` | `"GetStorage"` | Offline data container |

---

## Controllers

### FormController

Main form state management controller.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `form` | `FormGroup` | Reactive form group |
| `fields` | `List<FormItemField>` | Parsed field definitions |
| `formGroupOrder` | `List<List<String>>` | Layout configuration |
| `status` | `FormStatus` | Current form status |
| `isLoading` | `RxBool` | Submission in progress |
| `errors` | `RxList<String>` | Form-level errors |
| `requiredFieldNames` | `RxList<String>` | Fields with validation errors |
| `isInternetConnected` | `RxBool` | Network status |

#### Methods

| Method | Return | Description |
|--------|--------|-------------|
| `submit()` | `Future<void>` | Validate and submit form |
| `getCurrentFormFields()` | `Map<String, dynamic>` | Get all form data + extraFields |
| `preparePostData()` | `Future<Map>` | Process data with PreSaveData |
| `updateFormErrors(Map)` | `void` | Set errors from API response |
| `updateStatus(FormStatus)` | `void` | Change form status |
| `hasFileFields()` | `bool` | Check for file/image fields |
| `hasFileData(Map)` | `bool` | Check for local file paths |
| `getInstanceUrl()` | `String?` | Get URL for current operation |

#### Accessing Controller

```dart
// In callback
onControllerSetup: (FormController controller) {
  controller.form.control('email').value = 'test@example.com';
}

// Via GetX
final controller = Get.find<FormController>(tag: 'user_form');
```

### InputController

Per-field controller for complex fields (choice, field, multifield, file, image).

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `field` | `FormItemField` | Field definition |
| `choices` | `RxList<DropdownMenuItem>` | Rendered dropdown items |
| `formChoices` | `RxList<FormChoice>` | Raw choice objects |
| `selectedItems` | `RxList<FormChoice>` | Selected values (multifield) |
| `visible` | `RxBool` | Field visibility |
| `isLoading` | `RxBool` | Loading options |
| `noResults` | `RxString` | "No results" message |

#### Methods

| Method | Description |
|--------|-------------|
| `getOptions({search})` | Load choices from API/storage/static |
| `selectValue(List<FormChoice>)` | Update selected items |
| `getChoice(dynamic id)` | Get FormChoice by value |
| `resetOptions()` | Clear options list |
| `getAllPosibleOptions()` | Get all available choices |

---

## Callbacks

### onSuccess

Called after successful form submission.

```dart
onSuccess: (dynamic data) async {
  // data = API response body
  Get.snackbar('Success', 'Form submitted');
  Get.back();
}
```

### onOfflineSuccess

Called when form is saved offline.

```dart
onOfflineSuccess: (dynamic data) {
  // data = form data that was saved
  Get.snackbar('Saved', 'Form saved for sync');
}
```

### PreSaveData

Transform data before submission.

```dart
PreSaveData: (Map<String, dynamic> data) async {
  data['timestamp'] = DateTime.now().toIso8601String();
  return data;
}
```

### customDataValidation

Custom form-wide validation.

```dart
customDataValidation: (Map<String, dynamic> data) {
  if (data['password'] != data['confirm_password']) {
    return {'confirm_password': ['Passwords do not match']};
  }
  return null; // No errors
}
```

### validateOfflineData

Validation for offline submissions.

```dart
validateOfflineData: (Map<String, dynamic> data) {
  if (data['name'] == null) {
    return {'name': ['Name required for offline save']};
  }
  return null;
}
```

### handleErrors

Custom error handling from API response.

```dart
handleErrors: (dynamic errors) {
  // Process errors, return display string
  return 'Custom error message';
}
```

### onFormItemTranform

Transform field definitions before rendering.

```dart
onFormItemTranform: (FormItemField field) {
  if (field.name == 'role') {
    field.label = 'Staff Role';
    field.required = true;
  }
  return field;
}
```

### onControllerSetup

Called after FormController initialization.

```dart
onControllerSetup: (FormController controller) {
  // Set default values, access form state
  controller.form.control('status').value = 'active';
}
```

### getDynamicUrl

Determine submission URL at runtime.

```dart
getDynamicUrl: (Map<String, dynamic> data) {
  if (data['type'] == 'admin') {
    return '/api/admin/users/';
  }
  return '/api/users/';
}
```

### getOfflineName

Name offline records for identification.

```dart
getOfflineName: (dynamic data) {
  return '${data['first_name']} ${data['last_name']}';
}
```

### onStatus

Called when form status changes.

```dart
onStatus: (FormStatus status) {
  print('Form status: ${status.statusDisplay()}');
}
```

---

## Offline Support

### Configuration

```dart
MyCustomForm(
  enableOfflineMode: true,      // Enable offline functionality
  enableOfflineSave: true,      // Allow saving when offline
  showOfflineMessage: true,     // Display status indicator
  offlineMessage: "No internet",
  storageContainer: "MyApp",
  offlineStorageContainer: "MyAppOffline",
  getOfflineName: (data) => data['name'],
  onOfflineSuccess: (data) => print('Saved offline'),
  validateOfflineData: (data) => null,
)
```

### OfflineHttpCall Model

```dart
class OfflineHttpCall {
  String id;              // Unique identifier
  String name;            // Record name (from getOfflineName)
  String httpMethod;      // POST/PATCH/PUT/DELETE
  String urlPath;         // Full API URL
  Map<String, dynamic> formData;
  String? instanceId;     // For update/delete
  int tries;              // Sync attempt count
  String storageContainer;
}
```

### Background Sync

Offline records are synced using `handleOfflineRecords()`:

1. Fetch all offline records from storage
2. For each record, attempt HTTP call
3. On success: remove from storage
4. On failure: increment tries, save back
5. Stop after 3 consecutive failures

---

## Theming

### SisitechMultiSelectTheme

Custom theme extension for multiselect fields.

```dart
MaterialApp(
  theme: ThemeData.light().copyWith(
    extensions: [
      SisitechMultiSelectTheme(
        backgroundColor: Colors.white,
        labelColor: Colors.black,
        choiceWidgetTextColor: Colors.black,
        choiceWidgetBackgroundColor: Colors.grey[100],
        selectedChoiceWidgetTextColor: Colors.white,
        selectedChoiceWidgetBackgroundColor: Colors.blue,
      ),
    ],
  ),
)
```

### Theme Integration Points

The package uses these theme properties:

- `Get.theme.primaryColor` - Border colors, icons
- `Get.theme.colorScheme.error` - Error text
- `Get.theme.inputDecorationTheme.labelStyle` - Labels
- `Get.theme.textTheme` - Various text styles
- `Get.theme.hintColor` - Placeholder text

---

## Form Configuration Structure

### Complete Example

```dart
const formItems = {
  "name": "User Registration",
  "description": "Create a new user account",
  "actions": {
    "POST": {
      "first_name": {
        "type": "string",
        "label": "First Name",
        "required": true,
        "max_length": 50,
        "placeholder": "Enter first name"
      },
      "last_name": {
        "type": "string",
        "label": "Last Name",
        "required": true,
        "max_length": 50
      },
      "email": {
        "type": "email",
        "label": "Email",
        "required": true
      },
      "birth_date": {
        "type": "date",
        "label": "Date of Birth",
        "start_value": "1950-01-01",
        "end_value": "today"
      },
      "department": {
        "type": "field",
        "label": "Department",
        "url": "/api/departments/",
        "display_name": "name",
        "value_field": "id",
        "required": true
      },
      "roles": {
        "type": "multifield",
        "label": "Roles",
        "multiple": true,
        "choices": [
          {"display_name": "Admin", "value": "admin"},
          {"display_name": "Editor", "value": "editor"},
          {"display_name": "Viewer", "value": "viewer"}
        ]
      },
      "avatar": {
        "type": "image",
        "label": "Profile Picture"
      },
      "is_active": {
        "type": "boolean",
        "label": "Active Account"
      }
    }
  }
};

// Widget usage
MyCustomForm(
  name: "user_registration",
  formItems: formItems,
  formGroupOrder: [
    ["first_name", "last_name"],
    ["email", "birth_date"],
    ["department", "roles"],
    ["avatar"],
    ["is_active"],
  ],
  url: "/api/users/",
  status: FormStatus.Add,
  enableOfflineMode: true,
  onSuccess: (data) {
    Get.snackbar('Success', 'User created');
    Get.offAllNamed('/users');
  },
  PreSaveData: (data) async {
    data['created_at'] = DateTime.now().toIso8601String();
    return data;
  },
)
```

---

## Key Files

| File | Purpose |
|------|---------|
| `lib/flutter_form.dart` | MyCustomForm widget, field rendering |
| `lib/form_controller.dart` | FormController, submission logic |
| `lib/input_controller.dart` | InputController, options loading |
| `lib/models.dart` | FormItemField, FormChoice, enums |
| `lib/multiselect/` | MultiSelect widget implementation |
| `lib/handle_offline_records.dart` | Offline sync functionality |
| `lib/utils.dart` | Validators, form control creation |

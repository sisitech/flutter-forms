# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter package called `flutter_form` (version 0.0.2) that provides form generation and management capabilities with offline support. The package uses GetX for state management and reactive forms for form handling.

## Architecture

### Core Components

- **MyCustomForm**: Main form widget that renders dynamic forms based on configuration
- **FormController**: GetX controller managing form state, validation, and submission
- **InputController**: Manages individual form field states and choices
- **FormItemField**: Model representing individual form fields with various types
- **MultiSelect**: Custom multiselect field implementation

### Key Dependencies

- `get: ^4.6.5` - State management (GetX pattern)
- `reactive_forms: ^17.0.1` - Form handling and validation
- `flutter_utils` - Custom utility package from Sisitech
- `flutter_auth` - Authentication package from Sisitech
- `flex_color_scheme: ^7.3.1` - Theming support

### Form Field Types

The package supports multiple field types defined in `FieldType` enum:
- `string`, `integer`, `float`, `alphabets`
- `date`, `datetime`, `time`
- `boolean`, `choice`, `field`, `multifield`
- `email`, `file`

### State Management Pattern

- Uses GetX controllers with reactive forms
- Form state is managed in `FormController` with `form` as FormGroup
- Individual field controllers (`InputController`) handle field-specific logic
- Offline support through `OfflineHttpCacheController`

## Development Commands

### Package Development
```bash
# Get dependencies
flutter pub get

# Run code generation for models
flutter pub get && flutter pub run build_runner build

# Run tests
flutter test

# Analyze code
flutter analyze

# Clean build artifacts
flutter clean
```

### Example App Development
```bash
# Navigate to example directory
cd example/

# Get dependencies
flutter pub get

# Run the example app
flutter run

# Build for different platforms
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
flutter build macos        # macOS
```

## Code Generation

The package uses `json_serializable` for model serialization. When modifying models in `lib/models.dart`, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Testing Strategy

- Unit tests are located in `test/` directory
- Example app serves as integration testing
- Form validation and offline functionality should be thoroughly tested

## Key Files Structure

```
lib/
├── flutter_form.dart          # Main form widget and UI components
├── form_controller.dart       # Core form state management
├── input_controller.dart      # Individual field controllers
├── models.dart               # Data models and enums
├── models.g.dart            # Generated serialization code
├── form_connect.dart        # API connectivity
├── utils.dart               # Utility functions
├── multiselect/             # Multi-select field implementation
└── handle_offline_records.dart # Offline data handling

example/
├── lib/main.dart            # Example app entry point
├── lib/teacher_options.dart # Form configuration examples
└── lib/widgets/            # Example widgets
```

## Form Configuration Pattern

Forms are configured using JSON-like structures with:
- `formItems`: Field definitions and actions
- `formGroupOrder`: Layout arrangement as List<List<String>>
- `extraFields`: Additional data to include in submissions
- Status-based HTTP methods (Add=POST, Update=PATCH, Replace=PUT, Delete=DELETE)

## Custom Form Layouts

The package supports custom form layouts via `customChild` and `customFields` parameters:

### Parameters

- **customChild** (`Widget?`): Custom widget to render instead of auto-generated layout. Must use ReactiveForm widgets (e.g., `ReactiveTextField`) with `formControlName` parameter.
- **customFields** (`List<String>?`): Required when using `customChild`. Specifies which fields from `formItems` to initialize.

### Rules

- `customFields` and `formGroupOrder` cannot both be provided
- `customFields` is required when using `customChild`

### Example Usage

```dart
MyCustomForm(
  name: 'customChildForm',
  formItems: teacherOptions,
  customFields: ['first_name', 'email'],
  customChild: Column(
    children: [
      ReactiveTextField<String>(
        formControlName: 'first_name',
        decoration: InputDecoration(labelText: 'First Name'),
      ),
      ReactiveTextField<String>(
        formControlName: 'email',
        decoration: InputDecoration(labelText: 'Email'),
      ),
      ElevatedButton(
        onPressed: () {
          Get.find<FormController>(tag: 'customChildForm').submit();
        },
        child: Text('Submit'),
      ),
    ],
  ),
  onSuccess: (res) => print("Success: $res"),
)
```

### When to Use

- Custom UI layouts not supported by `formGroupOrder`
- Multi-step forms with custom navigation
- Dynamic field visibility based on custom logic

### Important: Numeric Fields

When using `customChild` with numeric field types, you must add a `valueAccessor` to convert between String and the numeric type:

**For integer fields:**
```dart
ReactiveTextField<int>(
  formControlName: 'age',
  valueAccessor: IntValueAccessor(),
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: 'Age'),
)
```

**For float/double fields:**
```dart
ReactiveTextField<double>(
  formControlName: 'price',
  valueAccessor: DoubleValueAccessor(),
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  decoration: InputDecoration(labelText: 'Price'),
)
```

## Offline Support

The package includes comprehensive offline functionality:
- Forms can be saved offline when no internet connection
- Offline data validation through `validateOfflineData` callback
- Background sync via WorkManager integration
- Storage through GetStorage containers

## Development Best Practices

- **State Management**: 
  - Never use stateful widgets in flutter use getx for state management
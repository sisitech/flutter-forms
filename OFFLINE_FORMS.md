# Offline Forms Setup

## Quick Setup

### 1. main.dart Setup

```dart
import 'package:flutter_form/handle_offline_records.dart';
import 'package:flutter_form/models.dart'; // For myform_work_manager_tasks_prefix
import 'package:workmanager/workmanager.dart';
import 'package:get_storage/get_storage.dart';

// Top-level function for background sync
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Get.put<APIConfig>(authConfig);

    if (task.startsWith(myform_work_manager_tasks_prefix)) {
      return await handleOfflineRecords(task);
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await GetStorage.init();
  await GetStorage.init('school'); // Named containers

  // Register controllers
  Get.put<APIConfig>(authConfig);
  Get.put(NetworkStatusController());
  Get.put(AuthController());
  Get.put(OfflineHttpCacheController());

  // Initialize WorkManager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}
```

### 2. Form Configuration

```dart
MyCustomForm(
  name: "TeacherForm",
  formItems: teacherOptions,
  formGroupOrder: const [['first_name'], ['email']],

  // Offline settings
  enableOfflineMode: true,
  enableOfflineSave: true,
  storageContainer: "school",
  offlineStorageContainer: "school",

  url: "api/v1/teachers",

  onSuccess: (res) => print("Saved to server"),
  onOfflineSuccess: (data) => print("Saved offline, will sync"),
)
```

## Key Parameters

- `enableOfflineMode: true` - Form works offline
- `enableOfflineSave: true` - Saves data locally, syncs via WorkManager
- `storageContainer` - GetStorage container name
- `validateOfflineData` - Offline validation function, return `{"field": "error"}` or `null`
- `onOfflineSuccess` - Callback when saved offline
- `getOfflineName` - Custom name for offline records

## Examples

### Login with Offline Validation

```dart
MyCustomForm(
  name: "LoginForm",
  formItems: loginOptions,
  enableOfflineMode: true,
  storageContainer: "school",
  url: "o/token/",

  validateOfflineData: (formData) {
    final box = GetStorage("school");
    final user = box.read("cached_user");
    if (user?['username'] == formData['username']) return null;
    return {"username": "Invalid offline credentials"};
  },

  onSuccess: (res) async => await authCont.saveToken(res),
  onOfflineSuccess: (res) async => Get.offAllNamed('/home'),

  formGroupOrder: const [["username"], ["password"]],
)
```

### Data Entry with Sync

```dart
MyCustomForm(
  name: "TeacherForm",
  formItems: teacherOptions,
  enableOfflineMode: true,
  enableOfflineSave: true,
  storageContainer: "school",
  url: "api/v1/teachers",

  getOfflineName: (data) => "Teacher: ${data['first_name']}",

  onSuccess: (res) => Get.back(),
  onOfflineSuccess: (data) async {
    Get.snackbar("Offline", "Will sync when online");
    Get.back();
  },

  formGroupOrder: const [['first_name'], ['email']],
)
```

### Update Form

```dart
MyCustomForm(
  name: "UpdateTeacher",
  formItems: teacherOptions,
  enableOfflineMode: true,
  enableOfflineSave: true,
  status: FormStatus.Update,
  url: "api/v1/teachers",

  instance: {"id": 34, "first_name": "John", "email": "john@example.com"},

  storageContainer: "school",
  onSuccess: (res) => print("Updated"),
  onOfflineSuccess: (data) => print("Update saved offline"),

  formGroupOrder: const [['first_name'], ['email']],
)
```

## Monitoring Offline Data

```dart
// Display offline records
final offlineCont = Get.find<OfflineHttpCacheController>();
final keys = offlineCont.getOfflineKeys("school");
final box = GetStorage("school");

for (var key in keys) {
  var data = box.read<Map<String, dynamic>>(key);
  if (data != null) {
    var record = OfflineHttpCall.fromJson(data);
    print("${record.name} - ${record.tries} tries");
  }
}

// Manual sync
await handleOfflineRecords("MYFORM.school");

// Clear storage
await GetStorage("school").erase();
await Workmanager().cancelAll();
```

## How It Works

1. **Offline submission**: Form validates → saves to GetStorage → registers WorkManager task → calls `onOfflineSuccess`
2. **Background sync**: WorkManager calls `callbackDispatcher` → `handleOfflineRecords` → HTTP request → removes on success
3. **Error handling**: Increments retry count, stops after 3 consecutive errors

## Offline Data Structure

```dart
{
  "id": "unique_id",
  "name": "Display name",
  "urlPath": "api/v1/teachers",
  "httpMethod": "POST",  // POST, PATCH, PUT, DELETE
  "formData": {...},
  "storageContainer": "school",
  "tries": 0,
  "instanceId": "34"  // For updates
}
```

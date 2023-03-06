import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/handle_offline_records.dart';
import 'package:flutter_form/models.dart';

import 'package:flutter_utils/flutter_utils.dart';

import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/network_status/network_status.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:flutter_utils/offline_http_cache/offline_http_cache.dart';
import 'package:flutter_utils/text_view/text_view.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:form_example/options_login.dart';
import 'package:form_example/teacher_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workmanager/workmanager.dart';

import 'custom_field.dart';
import 'internalization/translate.dart';
import 'main_controller.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  dprint("Dispatcher called ");
  Workmanager().executeTask((task, inputData) async {
    dprint("Starting work for $task");
    Get.put<APIConfig>(
      APIConfig(
          apiEndpoint: "https://dukapi.roometo.com",
          version: "api/v1",
          clientId: "NUiCuG59zwZJR14tIdWD7iQ5ILFnpxbdrO2epHIG",
          tokenUrl: 'o/token/',
          grantType: "password",
          revokeTokenUrl: 'o/revoke_token/'),
    );
    if (task.startsWith(myform_work_manager_tasks_prefix)) {
      dprint("Handing over work to myform handler $task");
      var res = await handleOfflineRecords(task);
      return Future.value(res);
    } else {
      return Future.value(true);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('school');
  await GetStorage.init();
  Get.put<APIConfig>(
    APIConfig(
        apiEndpoint: "https://dukapi.roometo.com",
        version: "api/v1",
        clientId: "NUiCuG59zwZJR14tIdWD7iQ5ILFnpxbdrO2epHIG",
        tokenUrl: 'o/token/',
        grantType: "password",
        revokeTokenUrl: 'o/revoke_token/'),
  );
  Get.put(NetworkStatusController());
  Get.put(AuthController());
  Get.put(OfflineHttpCacheController());

  Get.put(MyMainController());

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  // await createSchools();
  runApp(const MyApp());
}

createSchools() async {
  final box = GetStorage("school");
  // await box.erase();
  var classes = await box.read("classes");
  if (classes == null) {
    var classes = [];
    for (int i = 0; i < 8; i++) {
      var students = [i, i + 10, i + 20].map((e) {
        return {
          "name": "Ler $i",
          "stream": i,
        };
      });
      var stream = {
        "class_name": "Class $i",
        "base_class": "$i",
        "id": i,
        // "students": students
      };
      classes.add(stream);
    }

    var counties = classes
        .map((e) => ({
              "name": "County ${e['id']}",
              "id": e["id"],
              "districts_details": []
            }))
        .toList();

    var districts = counties.map((e) {
      var districts = [1, 2 + 10, 3 + 20].map((e) {
        return {
          "id": e,
          "name": "Ler $e",
          "district": "$e",
        };
      });
      return {
        "name": "District ${e['id']}",
        "id": e["id"],
        "county": e["id"],
        "shehiyas_details": districts.toList()
      };
    }).toList();

    await box.write("classes", classes);
    await box.write("regions", counties);
    await box.write("districts", districts);
  }
  // dprint(value)
  dprint(await box.read("districts"));
  // dprint(await box.read("classes"));
}

const Color PRIMARY_COLOR = Color(0xff7240FF);

const Color SECONDARY_COLOR = Color(0xffD4AB13);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? light, ColorScheme? dark) {
      ColorScheme lightScheme;
      ColorScheme darkScheme;
      if (light != null && dark != null) {
        dprint("Received material you you,");
        lightScheme = light.harmonized();
        darkScheme = dark.harmonized();
      } else {
        dprint("Material you not suppoeted.");
        lightScheme = ColorScheme.fromSeed(seedColor: PRIMARY_COLOR);
        darkScheme = ColorScheme.fromSeed(
            seedColor: PRIMARY_COLOR, brightness: Brightness.dark);
      }

      return GetMaterialApp(
        title: 'Flutter Demo',
        translations: AppTranslations(),
        locale: const Locale('swa', 'KE'),
        themeMode: ThemeMode.system,
        theme: FlexThemeData.light(
          colorScheme: lightScheme,
          // colors: const FlexSchemeColor(
          //   primary: Color(0xff7240ff),
          //   primaryContainer: Color(0xffd1c0ff),
          //   secondary: Color(0xffac3306),
          //   secondaryContainer: Color(0xffffdbcf),
          //   tertiary: Color(0xff006875),
          //   tertiaryContainer: Color(0xff95f0ff),
          //   appBarColor: Color(0xffffdbcf),
          //   error: Color(0xffb00020),
          // ),
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 9,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            defaultRadius: 17.0,
            bottomNavigationBarBackgroundSchemeColor: SchemeColor.onPrimary,
            navigationBarSelectedLabelSchemeColor: SchemeColor.secondary,
            navigationBarUnselectedLabelSchemeColor: SchemeColor.tertiary,
            navigationBarSelectedIconSchemeColor: SchemeColor.secondary,
            navigationBarUnselectedIconSchemeColor: SchemeColor.tertiary,
            navigationBarBackgroundSchemeColor: SchemeColor.onPrimary,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          // To use the playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          colorScheme: darkScheme,
          // colors: const FlexSchemeColor(
          //   primary: Color(0xffb499ff),
          //   primaryContainer: Color(0xff7240ff),
          //   secondary: Color(0xffffb59d),
          //   secondaryContainer: Color(0xff872100),
          //   tertiary: Color(0xff86d2e1),
          //   tertiaryContainer: Color(0xff004e59),
          //   appBarColor: Color(0xff872100),
          //   error: Color(0xffcf6679),
          // ),
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 15,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            defaultRadius: 17.0,
            bottomNavigationBarBackgroundSchemeColor: SchemeColor.onPrimary,
            navigationBarSelectedLabelSchemeColor: SchemeColor.secondary,
            navigationBarUnselectedLabelSchemeColor: SchemeColor.tertiary,
            navigationBarSelectedIconSchemeColor: SchemeColor.secondary,
            navigationBarUnselectedIconSchemeColor: SchemeColor.tertiary,
            navigationBarBackgroundSchemeColor: SchemeColor.onPrimary,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        // home:StorageTestForm(), //const MyHomePage(title: 'Flutter Demo Home Page'),
      );
    });
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    APIConfig config = Get.find<APIConfig>();
    OfflineHttpCacheController offlnCont =
        Get.find<OfflineHttpCacheController>();

    AuthController authCont = Get.find<AuthController>();

    MyMainController mainCont = Get.find<MyMainController>();

    dprint(context.width);
    FormController? controller;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Hello Forms"),
            NetworkStatusWidget(),
            MyCustomForm(
              formItems: loginOptions,
              enableOfflineMode: false,
              // isValidateOnly: true,
              storageContainer: "school",
              url: "o/token/",
              submitButtonText: "Login",
              // submitButtonPreText: "",
              loadingMessage: "Signing in...",
              instance: const {
                // "id": 12,
                "username": "myadmin",
                "password": "#myadmin",
                "client_d": "NUiCuG59zwZJR14tIdWD7iQ5ILFnpxbdrO2epHIG",
                "grant_type": "password",
              },
              onSuccess: (res) async {
                dprint("Received");
                dprint(res);
                await authCont.saveToken(res as Map<String, dynamic>);

                var data = {
                  "name": "Get Shops",
                  "urlPath": "api/v1/shops",
                  "storageContainer": "school",
                  "httpMethod": "GET",
                  "status": "",
                  "tries": 0,
                };
                offlnCont.saveOfflineCache(OfflineHttpCall.fromJson(data),
                    taskPrefix: "MYFORM");
              },
              onOfflineSuccess: (res) async {
                dprint("Success login.");
                dprint(res);

                await Future.delayed(const Duration(milliseconds: 1000));
                dprint("Done");
              },
              handleErrors: (value) {
                return "Your password might be wrong";
              },
              contentType: ContentType.form_url_encoded,
              extraFields: {
                "client_id": config.clientId,
                "grant_type": config.grantType,
              },
              formGroupOrder: const [
                ["username"],
                ["password"]
              ],
              formTitle: "Signupdada",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: mainCont.getAllOfflineData,
                  child: Text("Refresh"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var box = GetStorage("school");
                    await box.erase();
                    dprint("Cleared storage");
                  },
                  child: Text("Clear Storage"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Workmanager().cancelAll();
                    dprint("Cleared work manager tasks");
                  },
                  child: Text("Clear Tasks"),
                ),
              ],
            ),
            Obx(() {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  OfflineHttpCall item = mainCont.ofllineData.value[index];
                  // item.name
                  // item.formData
                  // item.tries
                  return ListTile(
                    title: Text(item.name),
                    subtitle: TextView(
                      display_message: "@urlPath#",
                      data: item.toJson(),
                    ),
                    trailing: Text(item.tries.toString()),
                  );
                },
                itemCount: mainCont.ofllineData.value.length,
              );
            }),
            MyCustomForm(
              formItems: teacherOptions,
              // onFormItemTranform: (FormItemField field) {
              //   if (field.name == "contact_name") {
              //     field.label = "${field.label} Transformed";
              //   }
              //   return field;
              // },

              url: "api/v1/teachers",
              onControllerSetup: (contr) => controller = contr,
              instance: const {
                "contact_email": "michameiu@gmail.com",
                "id": 34
                // "multifield": {
                //   // "contact_email": FormChoice(
                //   //   display_name: "myadmin2",
                //   //   value: "michameiu@gmail.com",
                //   // )
                // }
              },
              status: FormStatus.Update,
              contentType: ContentType.json,
              formHeader: const Text("Welcome home"),
              onSuccess: (value) {
                dprint(value);
                dprint(value["modified"].runtimeType);
                if (controller != null) {
                  var controlName = "modified";
                  controller?.form
                      .control(controlName)
                      .setErrors({"Faield..": ""});
                  controller?.form.control(controlName).markAsTouched();
                }
              },
              // handleErrors: (value) {
              //   return "Textsitn new validation";
              // },
              // isValidateOnly: true,
              formGroupOrder: const [
                ["name"],
                ['role'],
                ["active"],
                ["modified"],
                ["contact_name"],
                ["contact_phone"],
                ["tsc_no"],
                [
                  "contact_email"
                  // "image",
                ],
                ["location"]
              ],
              formTitle: "Login",
              formFooter: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("Sign Up"),
              ),
            ),
            CustomFieldForm(),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

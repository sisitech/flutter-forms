import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:form_example/options.dart';
import 'package:form_example/options_login.dart';
import 'package:get/get.dart';

void main() {
  Get.put<APIConfig>(APIConfig(
      apiEndpoint: "https://dukapi.roometo.com",
      version: "api/v1",
      clientId: "NUiCuG59zwZJR14tIdWD7iQ5ILFnpxbdrO2epHIG",
      tokenUrl: 'o/token/',
      grantType: "password",
      revokeTokenUrl: 'o/revoke_token/'));
  runApp(const MyApp());
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

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Hello Forms"),
            const SizedBox(
              height: 20,
            ),
            Text(Calculator().showSomething()),
            MyCustomForm(
              formItems: loginOptions,
              url: "o/token/",
              submitButtonText: "Login",
              // submitButtonPreText: "",
              loadingMessage: "Signing in...",
              instance: {
                // "id": 12,
                "username": "myadm1in",
                "password": "#myadmin",
              },
              onSuccess: (res) async {
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
              formTitle: "Signup",
            ),
            const SizedBox(
              height: 20,
            ),
            MyCustomForm(
              formItems: options,
              contentType: ContentType.json,
              formHeader: Text("Welcome home"),
              onSuccess: (value) {
                dprint(value);
              },
              isValidateOnly: true,
              formGroupOrder: const [
                [
                  "name",
                ],
                [
                  'role',
                ],
                ["active"],
                [
                  "contact_name",
                ],
                [
                  "contact_phone",
                ],
                [
                  "contact_email",
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
          ],
        ),
      ),
    );
  }
}

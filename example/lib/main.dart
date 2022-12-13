import 'package:example/options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
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
              // formItems: options,
              url: "o/token/",
              submitButtonText: "Login",
              submitButtonPreText: "",
              loadingMessage: "Signing in...",
              onSuccess: (res) {
                dprint("Success login.");
                dprint(res);
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
                  // "contact_phone",
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

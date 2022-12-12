import 'package:example/options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
            const SizedBox(
              height: 20,
            ),
            MyCustomForm(
              formItems: options,
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
            // MyCustomForm(
            //   formItems: options,
            //   formGroupOrder: const [
            //     ["name"],
            //     ["contact_name"],
            //     ["contact_email"],
            //     ["location"]
            //   ],
            //   formTitle: "Signup",
            // ),
          ],
        ),
      ),
    );
  }
}

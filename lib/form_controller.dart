import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'models.dart';

class FormController extends GetxController {
  final dynamic formItems;
  final List<List<String>> formGroupOrder;

  List<FormItemField> fields = [];

  FormController({required this.formItems, required this.formGroupOrder}) {
    print("Initialized this controller for me..");
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // print(formItems);
    // print(formGroupOrder);
    setUpForm();
  }

  var form = FormGroup({
    // 'name': FormControl<String>(
    //     validators: [Validators.required], value: "Mwangi Micha"),
    // 'email': FormControl<String>(
    //     validators: [Validators.required], value: "michameiu@gmail.com"),
    // 'password':
    //     FormControl<String>(validators: [Validators.required], value: "#micha"),
  });

  setUpForm() {
    fields = [];
    var jsonForm = formItems["actions"]["POST"] as Map<String, dynamic>;
    jsonForm.forEach((key, value) {
      var field = FormItemField.fromJson({"name": key, ...value});
      if (!field.read_only) {
        fields.add(field);
        form.addAll({key: FormControl<String>()});
      }
    });
    print("Weleocme");
    update();
  }

  submit() {
    if (!form.valid) {
      print("Not valied");
      print(form.errors);
      form.markAllAsTouched();
    }
    print(form.value);
    form.control("name").setErrors({"required": "Already taken."});
    form.control("name").markAsTouched();
    // var nameField = form.control("name");
    // print(nameField.disabled);

    // nameField.markAsDisabled();
    // print();
    // print(nameField.disabled);
    print('Hello Reactive Forms!!!');
    update();
  }
}

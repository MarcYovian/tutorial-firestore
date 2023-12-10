import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tutorial_firestore/models/employee.dart';
import 'package:tutorial_firestore/pages/home_page.dart';
import 'package:tutorial_firestore/services/firebase_crud.dart';

class EditPage extends StatefulWidget {
  final Employee? employee;

  const EditPage({
    super.key,
    this.employee,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final nameController = TextEditingController();
  final positionController = TextEditingController();
  final contactController = TextEditingController();
  final docIdController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    docIdController.value =
        TextEditingValue(text: widget.employee!.uid.toString());
    nameController.value =
        TextEditingValue(text: widget.employee!.employeeName.toString());
    positionController.value =
        TextEditingValue(text: widget.employee!.position.toString());
    contactController.value =
        TextEditingValue(text: widget.employee!.contactNumber.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('FreeCode Spot'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Doc Id Text Field
                  TextField(
                    controller: docIdController,
                    readOnly: true,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),

                  // Name Text Field
                  const SizedBox(height: 25.0),
                  TextFormField(
                    controller: nameController,
                    autofocus: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),

                  // Position Text Field
                  const SizedBox(height: 25.0),
                  TextFormField(
                    controller: positionController,
                    autofocus: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Position",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),

                  // contact Text Field
                  const SizedBox(height: 35.0),
                  TextFormField(
                    controller: contactController,
                    autofocus: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Contact Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),

                  // Home Page Button
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => const HomePage(),
                        ),
                        (route) =>
                            false, //if you want to disable back feature set to false
                      );
                    },
                    child: const Text('View List of Employee'),
                  ),

                  // Save Button
                  const SizedBox(height: 45.0),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Theme.of(context).primaryColor,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var response = await FirebaseCrud.updateEmployee(
                              name: nameController.text,
                              position: positionController.text,
                              contactno: contactController.text,
                              docId: docIdController.text);
                          if (response.code != 200) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(response.message.toString()),
                                  );
                                });
                          } else {
                            // ignore: use_build_context_synchronously
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(response.message.toString()),
                                  );
                                });
                          }
                        }
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

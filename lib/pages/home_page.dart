import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_firestore/models/employee.dart';
import 'package:tutorial_firestore/pages/create_page.dart';
import 'package:tutorial_firestore/pages/edit_page.dart';
import 'package:tutorial_firestore/services/firebase_crud.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readEmployee();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("List of Employee"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const CreatePage(),
                ),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(e["employee_name"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Position: ${e['position']}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Contact Number: ${e['contact_no']}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    const Color.fromARGB(255, 143, 133, 226),
                                padding: const EdgeInsets.all(5.0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Edit'),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => EditPage(
                                      employee: Employee(
                                          uid: e.id,
                                          employeeName: e["employee_name"],
                                          position: e["position"],
                                          contactNumber: e["contact_no"]),
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    const Color.fromARGB(255, 143, 133, 226),
                                padding: const EdgeInsets.all(5.0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Delete'),
                              onPressed: () async {
                                var response =
                                    await FirebaseCrud.deleteEmployee(
                                        docId: e.id);
                                if (response.code != 200) {
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content:
                                            Text(response.message.toString()),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';

import 'employee_model.dart';
import 'restapi.dart';
import 'config.dart';

class EmployeeDetail extends StatefulWidget {
  const EmployeeDetail({Key? key}) : super(key: key);

  @override
  EmployeeDetailState createState() => EmployeeDetailState();
}

class EmployeeDetailState extends State<EmployeeDetail> {
  DataService ds = DataService();

  String profpic = '-';
  late ValueNotifier<int> _notifier;

  //Employee Data
  List<EmployeeModel> employee = [];

  selectIdEmployee(String id) async {
    List data = [];
    data = jsonDecode(await ds.selectId(token, project, 'employee', appid, id));
    employee = data.map((e) => EmployeeModel.fromJson(e)).toList();

    profpic = employee[0].profpic;
  }

  //Info
  Future reloadDataEmployee(dynamic value) async {
    setState(() {
      final args = ModalRoute.of(context)?.settings.arguments as List<String>;

      selectIdEmployee(args[0]);
    });
  }

  //Profpic
  File? image;
  String? imageProfpic;

  Future pickImage(String id) async {
    try {
      var picked = await FilePicker.platform.pickFiles(withData: true);

      if (picked != null) {
        var response = await ds.upload(token, project,
            picked.files.first.bytes!, picked.files.first.extension.toString());

        var file = jsonDecode(response);

        await ds.updateId('profpic', file['file_name'], token, project,
            'employee', appid, id);

        profpic = file['file_name'];

        //Trigger Change ValueNotifier
        _notifier.value++;
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    //Init The Value Notifier
    _notifier = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Data"),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => pickImage(args[0]),
              child: const Icon(
                Icons.camera_alt,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print(employee);
                }

                Navigator.pushNamed(context, 'employee_form_edit',
                    arguments: [args[0]]).then(reloadDataEmployee);
              },
              child: const Icon(
                Icons.edit,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Warning"),
                        content: const Text("Remove this data?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              //Close Dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () async {
                              //Close Dialog
                              Navigator.of(context).pop();
                              bool response = await ds.removeId(
                                  token, project, 'employee', appid, args[0]);

                              if (response) {
                                Navigator.pop(context, true);
                              }
                            },
                            child: const Text("REMOVE"),
                          )
                        ],
                      );
                    });
              },
              child: const Icon(
                Icons.delete_outline,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: selectIdEmployee(args[0]),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                return const Text('None');
              }
            case ConnectionState.waiting:
              {
                return const Center(child: CircularProgressIndicator());
              }
            case ConnectionState.active:
              {
                return const Text('Active');
              }
            case ConnectionState.done:
              {
                if (snapshot.hasError) {
                  return Text(
                    '${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                } else {
                  return ListView(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.purple),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: _notifier,
                                  builder: (context, value, child) =>
                                      profpic == '-'
                                          ? const Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 130,
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.bottomCenter,
                                              child: CircleAvatar(
                                                radius: 80,
                                                backgroundImage: NetworkImage(
                                                  fileUri + profpic,
                                                ),
                                              ),
                                            ),
                                ),
                                InkWell(
                                  onTap: () => pickImage(args[0]),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      margin: const EdgeInsets.only(
                                        left: 183.00,
                                        top: 10.00,
                                        right: 113.00,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius:
                                            BorderRadius.circular(5.00),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    employee[0].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    employee[0].gender,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].name),
                          subtitle: const Text(
                            "Name",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.person,
                              color: Colors.purple,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].email),
                          subtitle: const Text(
                            "Email",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.email,
                              color: Colors.purple,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].phone),
                          subtitle: const Text(
                            "Phone",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.phone,
                              color: Colors.purple,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].birthday),
                          subtitle: const Text(
                            "Birthday",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Colors.purple,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].address),
                          subtitle: const Text(
                            "Address",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.home,
                              color: Colors.purple,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }
}

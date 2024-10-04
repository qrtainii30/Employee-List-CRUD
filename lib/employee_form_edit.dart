import 'dart:convert';

import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'employee_model.dart';
import 'restapi.dart';
import 'config.dart';

class EmployeeFormEdit extends StatefulWidget {
  const EmployeeFormEdit({Key? key}) : super(key: key);

  @override
  EmployeeFormEditState createState() => EmployeeFormEditState();
}

class EmployeeFormEditState extends State<EmployeeFormEdit> {
  DataService ds = DataService();

  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  String gender = 'Male';
  String profpic = '';
  String update_id = '';
  bool loadData = false;

  late Future<DateTime?> selectedDate;
  String date = "-";

  //Employee Data
  List<EmployeeModel> employee = [];

  selectedIdEmployee(String id) async {
    List data = [];
    data = jsonDecode(await ds.selectId(token, project, 'employee', appid, id));
    employee = data.map((e) => EmployeeModel.fromJson(e)).toList();

    setState(() {
      name.text = employee[0].name;
      birthday.text = employee[0].birthday;
      phone.text = employee[0].phone;
      email.text = employee[0].email;
      address.text = employee[0].address;
      gender = employee[0].gender;
      update_id = employee[0].id;
      profpic = employee[0].profpic;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    if (loadData == false) {
      selectedIdEmployee(args[0]);

      loadData = true;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Employee Form Edit"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: name,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Full Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  filled: false,
                  border: InputBorder.none,
                ),
                value: gender,
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
                items: <String>['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: birthday,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Birthday',
                ),
                onTap: () {
                  showDialogPicker(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Phone Number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: email,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email Address',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: address,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Address',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    elevation: 0,
                  ),
                  onPressed: () async {
                    bool updateStatus = await ds.updateId(
                        'name~phone~email~address~gender~birthday~profpic',
                        '${name.text}~${phone.text}~${email.text}~${address.text}~$gender~${birthday.text}~$profpic',
                        token,
                        project,
                        'employee',
                        appid,
                        update_id);
                    if (updateStatus) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text(
                    'UPDATE',
                    style: TextStyle(color: Color.fromARGB(255, 0, 78, 3)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDialogPicker(BuildContext context) {
    var date = DateTime.now();

    selectedDate = showDatePicker(
        context: context,
        initialDate: DateTime(date.year - 20, date.month, date.day),
        firstDate: DateTime(1980),
        lastDate: DateTime(date.year - 20, date.month, date.day),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light(),
            child: child!,
          );
        });

    selectedDate.then((value) {
      setState(() {
        if (value == null) return;

        if (kDebugMode) {
          print('Line 230');
        }

        final DateFormat formatter = DateFormat('dd-MMM-yyyy');
        final String formattedDate = formatter.format(value);

        birthday.text = formattedDate;
      });

      if (kDebugMode) {
        print('Line 240');
      }
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}

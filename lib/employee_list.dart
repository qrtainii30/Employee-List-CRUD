import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'employee_model.dart';
import 'restapi.dart';
import 'config.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  EmployeeListState createState() => EmployeeListState();
}

class EmployeeListState extends State<EmployeeList> {
  final searchKeywaord = TextEditingController();
  bool searchStatus = false;

  DataService ds = DataService();

  List data = [];
  List<EmployeeModel> employee = [];

  List<EmployeeModel> search_data = [];
  List<EmployeeModel> search_data_pre = [];

  selectAllEmployee() async {
    data = jsonDecode(await ds.selectAll(token, project, 'employee', appid));

    if (kDebugMode) {
      print(data);
    }

    employee = data.map((e) => EmployeeModel.fromJson(e)).toList();

    //refresh the UI
    setState(() {
      employee = employee;
    });
  }

  void filterEmployee(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      search_data = data.map((e) => EmployeeModel.fromJson(e)).toList();
    } else {
      search_data_pre = data.map((e) => EmployeeModel.fromJson(e)).toList();
      search_data = search_data_pre
          .where((user) =>
              user.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
  }

  //future reload data employee
  Future reloadDataEmployee(dynamic value) async {
    setState(() {
      selectAllEmployee();
    });
  }

  @override
  void initState() {
    selectAllEmployee();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !searchStatus ? const Text('Employee List') : search_field(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'employee_form_add')
                      .then(reloadDataEmployee);
                },
                child: const Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
          search_icon(),
        ],
      ),
      body: ListView.builder(
          itemCount: employee.length,
          itemBuilder: (context, index) {
            final item = employee[index];

            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.birthday),
              onTap: () {
                Navigator.pushNamed(context, 'employee_detail',
                    arguments: [item.id]).then(reloadDataEmployee);
              },
            );
          }),
    );
  }

  Widget search_icon() {
    return !searchStatus
        ? Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  searchStatus = true;
                });
              },
              child: const Icon(
                Icons.search,
                size: 26.0,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  searchStatus = false;
                });
              },
            ),
          );
  }

  Widget search_field() {
    return TextField(
      controller: searchKeywaord,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      onChanged: (value) => filterEmployee(value),
      decoration: const InputDecoration(
          hintText: 'Enter to Search',
          hintStyle: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 20)),
    );
  }
}

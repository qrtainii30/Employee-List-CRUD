import 'package:flutter/material.dart';

import 'employee_list.dart';
import 'employee_detail.dart';
import 'employee_form_add.dart';
import 'employee_form_edit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ), // ThemeData
        home: const EmployeeList(),
        routes: {
          'employee_list': (context) => const EmployeeList(),
          'employee_form_add': (context) => const EmployeeFormAdd(),
          'employee_form_edit': (context) => const EmployeeFormEdit(),
          'employee_detail': (context) => const EmployeeDetail()
        });
  }
} // MaterialApp
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'api_Service.dart';
import 'main.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final apiService = ApiService();

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateController = TextEditingController();
  List<dynamic> _customers = [];

  @override
  void initState() {
    super.initState();
   // _loadCustomers();

  }

  void _loadCustomers() async {
    try {
      dynamic customers;
      await apiService.getCustomers().then((value){
        setState(() {
          _customers = value;
        });
      });

    } catch (e) {
      print('Failed to load customers: $e');
    }
  }

  void _createCustomer() async {
    if (_formKey.currentState!.validate()) {
      try {
        await apiService.createCustomer({
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'date_of_birth': _dateController.text,
        });
        _firstNameController.clear();
        _lastNameController.clear();
        _dateController.clear();
        _loadCustomers();
      } catch (e) {
        if (kDebugMode) {
          print('Failed to create customer: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                // Expanded(
                //   child: Column(
                //     children: [
                //       TextFormField(
                //         controller: _firstNameController,
                //         decoration: InputDecoration(labelText: 'First Name'),
                //         validator: (value) {
                //           if (value == null || value.isEmpty) {
                //             return 'Please enter a first name';
                //           }
                //           return null;
                //         },
                //       ),
                //       TextFormField(
                //         controller: _lastNameController,
                //         decoration: InputDecoration(labelText: 'Last Name'),
                //         validator: (value) {
                //           if (value == null || value.isEmpty) {
                //             return 'Please enter a last name';
                //           }
                //           return null;
                //         },
                //       ),
                //       InkWell(
                //         onTap: () async {
                //           final date = await showDatePicker(
                //             context: context,
                //             initialDate: DateTime.now(),
                //             firstDate: DateTime(1900),
                //             lastDate: DateTime.now(),
                //           );
                //           if (date != null) {
                //             _dateController.text = date.toIso8601String().substring(0, 10); // Format the date as you need
                //           }
                //         },
                //         child: IgnorePointer(
                //           child: TextFormField(
                //             controller: _dateController,
                //             decoration: InputDecoration(labelText: 'Date of Birth'),
                //             validator: (value) {
                //               if (value == null || value.isEmpty) {
                //                 return 'Please enter a date';
                //               }
                //               return null;
                //             },
                //           ),
                //         ),
                //       ),
                //       ElevatedButton(
                //         onPressed: _createCustomer,
                //         child: const Text('Create Customer'),
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(child: GraphWidget())
              ],
            ),
          ),
        ),
        // Expanded(
        //   child: SingleChildScrollView(
        //     child: DataTable(
        //       columns: const [
        //         DataColumn(label: Text('First Name')),
        //         DataColumn(label: Text('Last Name')),
        //         DataColumn(label: Text('DOB')),
        //         DataColumn(label: Text('Actions')),
        //       ],
        //       rows: _customers.map((customer) {
        //         return DataRow(cells: [
        //           DataCell(Text(customer['first_name'])),
        //           DataCell(Text(customer['last_name'])),
        //           DataCell(Text(customer['date_of_birth'])),
        //           DataCell(Row(
        //             children: [
        //               IconButton(
        //                 icon: const Icon(Icons.edit),
        //                 onPressed: () {
        //                   // TODO: Implement edit functionality
        //                 },
        //               ),
        //               IconButton(
        //                 icon: const Icon(Icons.delete),
        //                 onPressed: () async {
        //                   try {
        //                     await apiService.deleteCustomer(customer['first_name']);
        //                     _loadCustomers();
        //                   } catch (e) {
        //                     print('Failed to delete customer: $e');
        //                   }
        //                 },
        //               ),
        //             ],
        //           )),
        //         ]);
        //       }).toList(),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_state_management_series/5_provider/provider_demo_1/provider_demo_1.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

class AddNewBreadCrumb extends StatefulWidget {
  const AddNewBreadCrumb({super.key});

  @override
  State<AddNewBreadCrumb> createState() => _AddNewBreadCrumbState();
}

class _AddNewBreadCrumbState extends State<AddNewBreadCrumb> {
  late TextEditingController _newController;

  @override
  void initState() {
    super.initState();
    _newController = TextEditingController();
  }

  @override
  void dispose() {
    _newController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: _newController,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: "Enter a new bread crumb in here"),
          ),
          TextButton(
            onPressed: () {
              if (_newController.text.isNotEmpty) {
                final newBreadCrumb =
                    BreadCrumb(name: _newController.text, isActive: false);
                context.read<BreadCrumbProvider>().add(newBreadCrumb);
              } else {
                dev.log('Text editing controller text is empty!');
              }

              Navigator.pop(context);
            },
            child: const Text(
              'Add',
            ),
          ),
        ],
      ),
    );
  }
}

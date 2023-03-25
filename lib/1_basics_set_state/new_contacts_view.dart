import 'package:flutter/material.dart';
import 'package:flutter_state_management_series/1_basics_set_state/start_1.dart';

class NewContactsView extends StatefulWidget {
  const NewContactsView({super.key});

  @override
  State<NewContactsView> createState() => _NewContactsViewState();
}

class _NewContactsViewState extends State<NewContactsView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Contact'),
        centerTitle: true,
      ),
      body: Column(children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Enter a new contact name here',
          ),
        ),
        TextButton(
            onPressed: () {
              final contact = Contact(name: _controller.text);
              ContactBook().add(contact: contact);
              Navigator.of(context).pop();
            },
            child: const Text('Add Contact'))
      ]),
    );
  }
}

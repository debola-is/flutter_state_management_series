import 'package:flutter/material.dart';
import 'package:flutter_state_management_series/1_basics_set_state/home_page.dart';
import 'package:flutter_state_management_series/1_basics_set_state/new_contacts_view.dart';
import 'package:uuid/uuid.dart';

/* State Mangement is the glue that joins the varios layers of your application together.. the business layer, the service layer, the UI layer etc..

ValueNotifier just keeps hold of a value and upon that value changing, it notifies all listeners that that value has changed, this action calls all the callbacks in the listeners.

Note: In the source code for ValueNotifier, the setter code actually checks for equality using the "==" operator. It is important for you to implement equality for your classes in order for you to be able to really tell when the value has changed

Change notifiers are more suited for when the class is intended to monitor a series of changes while value notifiers are more suited for when the class only has one value to listen for
*/

class Demo1 extends StatelessWidget {
  const Demo1({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/new-contact': (context) => const NewContactsView(),
      },
      home: const MyHomePage(),
    );
  }
}

class Contact {
  final String name;
  final String id;

  Contact({
    required this.name,
  }) : id = const Uuid().v4();
}

// convert ContactBook to ValueNotifier

class ContactBook extends ValueNotifier<List<Contact>> {
  // If you intend to read initial values of contacts from a storage location or whatever, it is in this constructor that the logic will be defined. In this case, we are passing an empty list so the contacts list is empty initially.

  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();

  factory ContactBook() => _shared;

  // Because we already supply an empty array to the constructor of the ValueNotifier, we no longer need to create an empty array like so;

  // final List<Contact> _contacts = [];

  // We can access the array of Contacts through a variable the ValueNotifier provides us with called "value"

  // Since we'll be using a listview in our app UI, we need to expose the count of the contact book to our application.
  int get length => value.length;

  // Simple add contacts function

  void add({required Contact contact}) {
    value.add(contact);
    notifyListeners();
  }

  // Remove contact function

  void remove({required Contact contact}) {
    if (value.contains(contact)) {
      value.remove(contact);
      notifyListeners();
    }
  }

  // Function to remove contact at a particular index

  Contact? contact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}

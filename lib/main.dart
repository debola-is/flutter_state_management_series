import 'package:flutter/material.dart';
import 'package:flutter_state_management_series/1_basics_set_state/start_1.dart';
import 'package:flutter_state_management_series/2_inherited_widget/start_2.dart';
import 'package:flutter_state_management_series/3_inherited_model/start_3.dart';
import 'package:flutter_state_management_series/4_inherited_notifier_and_change_notfier/start_4.dart';
import 'package:flutter_state_management_series/5_provider/start_5.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _demos.length,
        itemBuilder: (context, index) {
          final demo = _demos.keys.toList()[index];
          final title = _demos[demo];
          return ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text("Lesson ${index + 1}"),
            subtitle: Text(title!),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return demo;
              },
            )),
          );
        },
      ),
    );
  }
}

Map<Widget, String> _demos = {
  const Demo1():
      "Demo on the basics of state management in flutter using ValueNotifier and ChangeNotifier classes to wrap stateful widgets and a function available to them called setState.",
  const Demo2():
      "Demo on managing the state of widgets and their dependants using inherited widgets.",
  const Demo3():
      "Demo on managing the state of widgets and their dependants using the inherited model.",
  const Demo4():
      "Deep dive into understanding Inherited Notifier and Change Notifier in Flutter.",
  const Demo5():
      "Deep dive into Provider, a 3rd party state management package built on top or as a wrapper on top of Inherited Notifier",
};

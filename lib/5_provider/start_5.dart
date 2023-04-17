import 'package:flutter/material.dart';
import 'package:flutter_state_management_series/5_provider/provider_demo_1/provider_demo_1.dart';
import 'package:flutter_state_management_series/5_provider/provider_demo_2/provider_demo_2.dart';
import 'package:flutter_state_management_series/5_provider/provider_demo_3/provider_demo_3.dart';

/// Provider and many other 3rd party state management tools available to flutter work similarly, they hook themselves to the build context and use Inherited Widget under the hood.

class Demo5 extends StatelessWidget {
  const Demo5({super.key});

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
        title: const Text('Provider Demos'),
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
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return demo;
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

Map<Widget, String> _demos = {
  const ProviderDemo1():
      "Simple Bread Crumb application: Understanding basic concepts in Provider and demnostrating the use of context.read()",
  const ProviderDemo2():
      "Demo on the use of context.watch() and context.select()s",
  const ProviderDemo3():
      "Demo on managing the state of widgets and their dependants using the inherited model.",
};

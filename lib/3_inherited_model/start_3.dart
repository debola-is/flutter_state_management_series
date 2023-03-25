import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:developer' as devtools show log;
/* 
Inherited model and Inherited Widget are not stateful. They contain state but they are constant, they have constant constructors so their fields cannot change. They have to be wrapped inside a stateful widget to change their state.
*/

// Random arrays of colors
final List<MaterialColor> colors = [
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.brown,
  Colors.amber,
  Colors.deepPurple,
];

// Create an extension on iterables that allows to return a random value from the iterable
extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

enum AvailableColors { one, two }

class Demo3 extends StatelessWidget {
  const Demo3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing Inherited Model',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MaterialColor _color1 = Colors.yellow;
  MaterialColor _color2 = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: AvailableColorsModel(
        color1: _color1,
        color2: _color2,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _color1 = colors.getRandomElement();
                    });
                  },
                  child: Text('Change color 1'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _color2 = colors.getRandomElement();
                    });
                  },
                  child: Text('Change color 2'),
                ),
              ],
            ),
            const ColorWidget(color: AvailableColors.one),
            const ColorWidget(color: AvailableColors.two)
          ],
        ),
      ),
    );
  }
}

class AvailableColorsModel extends InheritedModel<AvailableColors> {
  final MaterialColor color2;
  final MaterialColor color1;

  const AvailableColorsModel({
    Key? key,
    required this.color1,
    required this.color2,
    required Widget child,
  }) : super(key: key, child: child);

  // Descendants need a way to grab a copy of this InheritedModel when beind built
  // This function will only be used by the children of this InheritedModel
  static AvailableColorsModel of(BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorsModel>(context,
        aspect: aspect)!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsModel oldWidget) {
    devtools.log('updateShouldNotify has beem invoked');
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }
  // If updateShouldNotify returns true, Flutter calls updatehouldNotifyDependent

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorsModel oldWidget,
      Set<AvailableColors> dependencies) {
    devtools.log('updateShouldNotifyDependent called');

    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }

    return false;
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors color;
  const ColorWidget({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devtools.log('Color1 widget got rebuilt');
        break;
      case AvailableColors.two:
        devtools.log('Color2 widget got rebuilt');
        break;
    }
    final provider = AvailableColorsModel.of(context, color);
    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider.color1 : provider.color2,
    );
  }
}

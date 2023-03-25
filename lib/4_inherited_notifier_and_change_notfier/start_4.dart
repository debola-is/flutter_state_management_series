// ignore_for_file: file_names

import 'package:flutter/material.dart';

/// Value Notifier is a subclass of change notifier
/// It keeps hold of one value and notifiers it's listeners when that value changes.
/// PS: That's the reason why it was kinda a challenge in Lesson 1 where the value notifier was holding on to a list because the changes in the internals of a list do not direcly affect the value that the value notifier is holding on to.
/// A change Notifier is a broader class that takes care of notifiying its listeners when any change happens in the change notifier.
/// Inherited Notifier is a variant of Inherited widget
/// It works with Change or Value Notifier to notify its listeners whenever there is a change in any of the classes.
/// The way an Inherited Notifier works will be demonstrated in out simple app which has a slider and two independent containers with seperate colors. Dragging the slider adjusts the opacity of the containers. The value of the slider is our state (a double) which the notifier will be holding on to, and the Inherited Notifier will trigger a rebuild of these containers whenever the change happens.
/// One major difference between an Inherited Widget (IW for short) and an InheritedNotifier (IN for short) is that the IW holds on to its own values while an IN doesn't, it depends on a notifier which is a listenable which holds the value.

class Demo4 extends StatelessWidget {
  const Demo4({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing Inherited Notifier',
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
      body: SliderInheritedNotifier(
        sliderData: sliderData,
        child: Builder(
          builder: (BuildContext context) {
            return Column(
              children: [
                Slider(
                  value: SliderInheritedNotifier.of(context),
                  onChanged: (value) {
                    sliderData.value = value;
                  },
                ),
                Row(
                  children: [
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: 200,
                        color: Colors.blue,
                      ),
                    ),
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: 200,
                        color: Colors.green,
                      ),
                    )
                  ].expandEqually().toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

extension ExpandEquallyon on Iterable<Widget> {
  Iterable<Widget> expandEqually() => map(
        (e) => Expanded(child: e),
      );
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;

  double get value => _value;

  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

// Defining our slider data globally
final sliderData = SliderData();

// The inherited notifier holds on to the slider data
class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifier({
    Key? key,
    required SliderData sliderData,
    required Widget child,
  }) : super(
          key: key,
          notifier: sliderData,
          child: child,
        );

  // To allow descendants of the InheritedNotifier to have access to the double value of the sliderData, we need a static of method

  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
          ?.notifier
          ?.value ??
      0.0;
}

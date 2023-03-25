import 'package:flutter/material.dart';
import 'package:flutter_state_management_series/5_provider/provider_demo_2/consumer_widgets.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// This application will demonstrate the use of Provider's context.select()
/// The application is hooked to one provider
/// The provider exposes two seperate properties which change over time. (Cheap and Expensive)
/// There are three widgets consuming the provider's value
/// Cheap widget get rebuilt everytime the cheap property changes (every second)
/// Expensive widget doesn't get rebuilt every time it's corresponding property gets changed (every ten seconds)
/// The third widget gets rebuilt any time either of the properties gets changed. [context.watch()]
/// There are also two buttons at the button "start" and "stop" buttons to start and stop the functionality respectively
///
/// A major take away from this lesson is that
/// to use context.select()  you have to specify both the type of the provider and the aspect of the provider you're interested in
/// also, it is very important that equality is implemented correctly
/// A failsafe way of ensuring this is using the uuid package
/// and overriding the operator method.

class ProviderDemo2 extends StatelessWidget {
  const ProviderDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ObjectProvider(),
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
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
      body: Column(
        children: [
          Row(
            children: const [
              CheapWidget(),
              ExpensiveWidget(),
            ].expandEvenly(),
          ),
          Row(
            children: const [
              Expanded(child: ObjectProviderWidget()),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<ObjectProvider>().stop();
                },
                child: const Text('Stop'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ObjectProvider>().start();
                },
                child: const Text('Start'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

extension ExpandEvenly on Iterable<Widget> {
  List<Widget> expandEvenly() => map((e) => Expanded(child: e)).toList();
}

/// Immutable super class for all objects
/// Both expensive and cheap objects are going to extend this class

@immutable
class BaseObject {
  final String uuid;
  final String lastUpdated;

  BaseObject()
      : uuid = const Uuid().v4(),
        lastUpdated = DateTime.now().toIso8601String();

  @override
  bool operator ==(covariant BaseObject other) => other.uuid == uuid;

  @override
  int get hashCode => uuid.hashCode;
}

@immutable
class CheapObject extends BaseObject {}

@immutable
class ExpensiveObject extends BaseObject {}

class ObjectProvider extends ChangeNotifier {
  late String id;
  late CheapObject _cheapObject;
  late ExpensiveObject _expensiveObject;
  late StreamSubscription _cheapObjectStreamSubs;
  late StreamSubscription _expensiveObjectStreamSubs;

  // The constructor is empty with initial values for id and cheap and expensive objects being initialised at the constructor
  // at the instance of creating the constructor, we also need to start the entire mechanism
  ObjectProvider()
      : id = const Uuid().v4(),
        _cheapObject = CheapObject(),
        _expensiveObject = ExpensiveObject() {
    start();
  }

  CheapObject get cheapObject => _cheapObject;
  ExpensiveObject get expensiveObject => _expensiveObject;

  void start() {
    _cheapObjectStreamSubs =
        Stream.periodic(const Duration(seconds: 1)).listen((_) {
      _cheapObject = CheapObject();
      notifyListeners();
    });

    _expensiveObjectStreamSubs =
        Stream.periodic(const Duration(seconds: 5)).listen((_) {
      _expensiveObject = ExpensiveObject();
      notifyListeners();
    });
  }

  void stop() {
    // Stop method to cancel all our stream subscriptions and prevent further rebuilds
    _cheapObjectStreamSubs.cancel();
    _expensiveObjectStreamSubs.cancel();
  }

  /// Every time we call notifyListeners, we want to reset the id of our provider
  /// as a neat little trick, we can override the default notifyListeners implementation.
  @override
  void notifyListeners() {
    id = const Uuid().v4();
    super.notifyListeners();
  }
}

import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_management_series/5_provider/provider_demo_1/new_bread_crumb.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// This is a simple breadCrumb application that features two screens
/// The first screen, displays all the bread crumbs and the active breadcrumb in a different format with two buttons, the first to add a new bread crumb and the second to reset all the bread crumbs.
/// The second is just a screen to add a new bread crumb.
/// context.read() is a function provided by Provider used to communicate with our provider.
/// It is typically used in call back functions when we need to communicate data back to the provider.
/// The major difference between context.watch() and context.read() is that the latter returns Provider.of<T>(this, listen: false) whereas the former returns Provider.of<T>(this).
/// So, context.watch() is used when the model should be rebuilt on Provider value change.
/// Refer to official doc/sc.
/// context.read() doesn't listen to changes in your provider,
/// it kinda givess a snapshot of the state of your provider at the instant it is called.
/// context.watch() is used to watch any changes to your provider.
/// It also allows you to depend on optional providers i.e if that particular provider exists up the tree, we are interested in its changes so it's not going to cause an error is such provider doesn't exist.
/// final provider3 = context.watch();
/// context.select() allows you to watch changes to specific aspect in your provider in cases where your Provider is holding several states and there is much going on internally in your provider.
/// It works very similarly to Inherited Model.
/// Note that context.select() and watch() are only used inside your build() function of your widget.
/// It marks the widget as needing to be rebuilt if a particular change occurs whereas context.watch() will mark your widget as needing to be rebuilt if there are any changes.
/// final provider2 = context.select((value) => null);

class ProviderDemo1 extends StatelessWidget {
  const ProviderDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    // We wrap our material app with a changeNotifierProvider and pass the 'create' property. So, the child of our changeNotifierProvider's build context will have access to our BreadCrumbProvider
    return ChangeNotifierProvider(
      create: (_) => BreadCrumbProvider(),
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/new': (context) => const Material(),
        },
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
      body: Column(children: [
        Consumer<BreadCrumbProvider>(
          builder: (context, value, child) {
            // The value is in fact the provider
            return BreadCrumbsWidget(breadCrumbs: value.items);
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const AddNewBreadCrumb(),
              ),
            );
          },
          child: const Text(
            'Add new Bread Crumb',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextButton(
          onPressed: () {
            final provider = context.read<BreadCrumbProvider>();
            provider.reset();
            provider.reset();
          },
          child: const Text(
            'Reset',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ]),
    );
  }
}

//----------------------------------------------------
// A widget to render all our bread crumbs in the home page
class BreadCrumbsWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;
  const BreadCrumbsWidget({
    super.key,
    required this.breadCrumbs,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map((breadCrumb) {
        return Text(
          breadCrumb.title,
          style: TextStyle(
            color: breadCrumb.isActive ? Colors.blue : Colors.black,
          ),
        );
      }).toList(),
    );
  }
}

class BreadCrumb {
  final String name;
  final String uuid;
  bool isActive;

  BreadCrumb({
    required this.name,
    required this.isActive,
  }) : uuid = const Uuid().v4();

  void activate() {
    isActive = true;
  }

  // Since we are adding these bread crumbd to a list, we need to implement equality
  @override
  bool operator ==(covariant BreadCrumb other) => other.uuid == uuid;

  // since we are overriding operator, we also need to override hashcode
  @override
  int get hashCode => uuid.hashCode;

  // calculate title based on isActive

  String get title => name + (isActive ? ' > ' : '');
}

/// Providers are usually ChangeNotifier instances in the Provider package
/// So we need to create our own Change Notifier to hold our Bread Crumbs

class BreadCrumbProvider extends ChangeNotifier {
  // The list of BreadCrumbs is made private to the class for good reason. (To prevent it from being manipulated from outside the class).
  // However we still need access to the contents of the list from outside of the class and for this we create an immutabe version of the list using the UnmodifiableListView.
  final List<BreadCrumb> _items = [];

  // Lists in Dart are classes and so they are mutable and hence  can change internally unless you have a constant instance of the class (const List)
  UnmodifiableListView<BreadCrumb> get items => UnmodifiableListView(_items);

  // We need a function to add a new Bread crumb
  void add(BreadCrumb breadCrumb) {
    // when we add a new breadcrumb we need to activate all the other existing breadCrumbs in the list
    for (final item in _items) {
      item.activate();
    }

    _items.add(breadCrumb);
    notifyListeners();
  }

  // We need a function to remove all the bread crumbs in the list
  void reset() {
    _items.clear();
    notifyListeners();
  }
}

/// ----------------------------------------------------

/// Consumer
/// 
/// It is a class that allows obtaining a value from a provider when we don't have a BuildContext that is a descendant of said provider, and therefore cannot use Provider.of.
/// 
/// This scenario typically happens when the widget that creates the provider is also one of its consumers
/// Consumer widget has both a builder and a child. The child doesn't get rebuilt when the provider changes while the builder function is triggered when the provider changes. This functionality is very important.
///

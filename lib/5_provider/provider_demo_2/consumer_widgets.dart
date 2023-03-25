import 'package:flutter/material.dart';
import 'package:flutter_state_management_series/5_provider/provider_demo_2/provider_demo_2.dart';
import 'package:provider/provider.dart';

/// It's important to note that in the constructors of these widgets,
/// We do not neccessarily have to have a provider
/// This is because these widgets are going to be inserted in a
/// widget hierarchy whose build context already
/// has access to the provider.

class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // We need to get a reference to Expensive Object
    // in addition to specifying the provider type, we also need
    // to specify the type of the aspect of the provider we are interested in like so,
    final expensiveObject = context.select<ObjectProvider, ExpensiveObject>(
      (value) => value.expensiveObject,
    );
    return Container(
      height: 100,
      color: Colors.blueAccent,
      child: Column(
        children: [
          const Text('Expensive Widget'),
          const Text('Last Updated'),
          Text(expensiveObject.lastUpdated),
        ],
      ),
    );
  }
}

class CheapWidget extends StatelessWidget {
  const CheapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cheapObject = context
        .select<ObjectProvider, CheapObject>((value) => value.cheapObject);
    return Container(
      height: 100,
      color: Colors.yellow,
      child: Column(
        children: [
          const Text('Cheap Widget'),
          const Text('Last Updated'),
          Text(cheapObject.lastUpdated),
        ],
      ),
    );
  }
}

class ObjectProviderWidget extends StatelessWidget {
  const ObjectProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ObjectProvider>();
    return Container(
      height: 100.0,
      color: Colors.purple,
      child: Column(
        children: [
          const Text('Object Provider Widget'),
          const Text('ID'),
          Text(provider.id),
        ],
      ),
    );
  }
}

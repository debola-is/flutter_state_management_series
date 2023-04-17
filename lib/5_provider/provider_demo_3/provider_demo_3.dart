import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// There is another type of provider known as the multi-provider
/// In real world projects, more often than not,
/// there is a lot happening, hence, several states to be managed
/// It doesn't make sense to put all of those states in one provider
/// It would be better to split the states into different providers
/// This demo demonstates how this would be achieved.
/// Multiprovider will be used to achieve this.

class ProviderDemo3 extends StatelessWidget {
  const ProviderDemo3({super.key});

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

// String function to get current time
String now() => DateTime.now().toIso8601String();

@immutable
class Seconds {
  final String value;
  Seconds() : value = now();
}

// Widgets to render our Seconds
class SecondsWidget extends StatelessWidget {
  const SecondsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final seconds = context.watch<Seconds>();
    return Expanded(
      child: Container(
        color: Colors.yellow,
        height: 100,
        child: Text(seconds.value),
      ),
    );
  }
}

@immutable
class Minutes {
  final String value;
  Minutes() : value = now();
}

// Widget to render our Minutes
class MinutesWidget extends StatelessWidget {
  const MinutesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final minutes = context.watch<Minutes>();
    return Expanded(
      child: Container(
        color: Colors.blue,
        height: 100,
        child: Text(minutes.value),
      ),
    );
  }
}

// // A function to create a new stream that returns the output of now() ar the specified duration.
// Stream<String> newStream(Duration duration) =>
//     Stream.periodic(duration, ((computationCount) => now()));

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: MultiProvider(
        providers: [
          StreamProvider.value(
            value: Stream<Seconds>.periodic(
                const Duration(seconds: 1), (_) => Seconds()),
            initialData: Seconds(),
          ),
          StreamProvider.value(
            value: Stream<Minutes>.periodic(
                const Duration(seconds: 5), (_) => Minutes()),
            initialData: Minutes(),
          ),
        ],
        child: Column(
          children: [
            Row(
              children: const [
                SecondsWidget(),
                MinutesWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

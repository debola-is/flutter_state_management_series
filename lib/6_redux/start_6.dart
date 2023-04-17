import 'package:flutter/material.dart';

/// What is redux and why do we use it?
///
/// https://github.com/fluttercommunity/redux.dart/blob/master/doc/why.md
///
/// Typically, states in applications regardless of framework,
/// can get quite messy and spaghetti-like
/// We often have different parts of our app playing with the state - the views, user interactions for instance.
///
/// Redux trys to clean that up by saying
/// There should be only one state in our app, which is global and is called a STORE.
/// Then we would have FUNCTIONS which modify that state based on different ACTIONS
///
/// Redux is basically divided into three main components:-
/// State
/// Actions
/// Reducers
///
/// State is an immutable class which contains the state of your application
/// Immutable such that no methods within or outside it alters the value of its fields

class Demo6 extends StatelessWidget {
  const Demo6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
    );
  }
}

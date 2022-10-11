import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:your_todo/shared/components/blocobserver.dart';
import 'layout/homelayout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}


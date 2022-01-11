import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungtu_flutter_case31_kozyrev/counter_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(storage: CounterStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter_sp = 0;
  int _counter_file = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter_file = value;
        _loadSPCounter();
      });
    });
  }

  void _loadSPCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter_sp = (prefs.getInt('counter') ?? 0);
    });
  }

  void _incrementSPCounter() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter_sp=(prefs.getInt('counter')??0)+1;
      prefs.setInt('counter', _counter_sp);
    });
  }

  Future<File> _incrementFileCounter(){
    setState(() {
      _counter_file++;
    });
    return widget.storage.writeCounter(_counter_file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кейс-задние 3.1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Счетчик Shared Preferences - $_counter_sp'),
            ElevatedButton(
                onPressed: _incrementSPCounter,
                child: Text('Push')
            ),
            Text('Счетчик File - $_counter_file'),
            ElevatedButton(
                onPressed: _incrementFileCounter,
                child: Text('Push')
            ),
          ],
        ),
      ),
    );
  }
}

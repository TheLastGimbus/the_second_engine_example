import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:jni/jni.dart';
import 'package:the_second_engine_example/toast.g.dart' as jni;
import 'package:workmanager/workmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  runApp(const MyApp());
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print(
        'BGN: waiting 15 seconds (open app now!) (Isolate ${Isolate.current.hashCode}');
    final ctx = jni.Context.fromReference(Jni.getCachedApplicationContext());
    final manager = ctx
        .getSystemService(jni.Context.BLUETOOTH_SERVICE)!
        .as(jni.BluetoothManager.type, releaseOriginal: true);
    final adapter = manager.getAdapter()!;
    await Stream.periodic(Duration(seconds: 1), (count) {
      print(
          'BGN🥸: bluetooth enabled: ${adapter.isEnabled()} (Isolate ${Isolate.current.hashCode})');
    })
        .listen((i) {})
        .asFuture()
        .timeout(Duration(seconds: 15), onTimeout: () {});
    print('BGN: bye bye');
    return true;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'the second2️⃣ engine'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late final jni.Context ctx;
  late final jni.BluetoothManager manager;
  late final jni.BluetoothAdapter adapter;

  @override
  void initState() {
    final ctx = jni.Context.fromReference(Jni.getCachedApplicationContext());
    manager = ctx
        .getSystemService(jni.Context.BLUETOOTH_SERVICE)!
        .as(jni.BluetoothManager.type, releaseOriginal: true);
    adapter = manager.getAdapter()!;
    super.initState();
  }

  void _incrementCounter() {
    print(
        'APP📱: bluetooth enabled: ${adapter.isEnabled()} (Isolate ${Isolate.current.hashCode})');
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FilledButton(
              onPressed: () {
                Workmanager().registerOneOffTask(
                  'uniqueName',
                  'taskName',
                  initialDelay: Duration(seconds: 5),
                );
                print('will run in 5 seconds...');
              },
              child: Text("one off"),
            ),
            const Text('You crashed flutter this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

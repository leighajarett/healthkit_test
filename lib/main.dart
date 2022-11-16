import 'dart:ffi';

import 'package:flutter/material.dart';
import 'healthkit_bindings.dart' as hk;

const _dylibPath =
    '/System/Library/Frameworks/HealthKit.framework/Versions/Current/HealthKit';
// Check with iOS team to see if these are usually static or dynamic, right now we just look to see if they have a dylib

void main() {
  // Initialize dynamic library
  final lib = hk.HealthKit(DynamicLibrary.open(_dylibPath));

  // // create a CMotionManager object
  // final healthStore = hk.HKHealthStore.alloc(lib).init();
  // var now = DateTime.now();
  // var today = NSDate.alloc(lib).init();
  // var yesterday = today.subtract(const Duration(days: 7));
  // var predicate = HKQuery.predicateForSamplesWithStartDate_endDate_options_(lib, today, yesterday)

  // var predicate = HKQuery.(
  //     lib, startOfDay, now, HKQueryOptions.strictStartDate);
  //  var predicate = HKQuery.predicateForSamples(
  //     withStart: startOfDay,
  //     end: now,
  //     options: .strictStartDate
  // )

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lib = hk.HealthKit(DynamicLibrary.process());
    // Is there a good way to convert between dart datetime and nsdate?
    var now = DateTime.now().toString();
    // var date = hk.NSDate(lib, now);
    var today = hk.NSDate.alloc(lib).init();

    // create formatter to convert to string
    // var formatter = hk.NSDateFormatter.alloc(lib).init();

    // Why can't you easily convert between the strings?
    // var localeString = hk.NSString(lib, 'en_US') --> bug
    // var locale = hk.NSLocale.alloc(lib).initWithLocaleIdentifier_(localeString);

    var yesterday = today.dateByAddingTimeInterval_(-86400);
    var predicate = hk.HKQuery.predicateForSamplesWithStartDate_endDate_options_(lib, today, yesterday, hk.HKQueryOptions.HKQueryOptionStrictStartDate);
    var type = hk.HKObjectType.quantityTypeForIdentifier_(lib, identifier)
    
    // Why is this not healthstore object --> also bug but you can tell the binding that it's a healthkit object
    // var healthStore = hk.HKHealthStore.alloc(lib).init();
    var healthStore = hk.HKHealthStore.castFrom(hk.HKHealthStore.alloc(lib).init());
    // healthStore.executeQuery_(query)

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: now),
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
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

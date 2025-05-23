import 'package:flutter/material.dart';
import 'package:stream_zidane/stream.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Zidane',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StreamHomePage(),
    );
  }
}

class StreamHomePage extends StatefulWidget {
  const StreamHomePage({super.key});

  @override
  State<StreamHomePage> createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {
  late StreamTransformer transformer;
  int lastNumber = 0;
  late StreamController numberStreamController;
  late NumberStream numberStream;
  Color bgColor = Colors.blue;
  late ColorStream colorStream;

void addRandomNumber() {
    Random random = Random();
    int myNum = random.nextInt(10);
    numberStream.addNumberToSink(myNum);
    // numberStream.addError();
  }
  
  @override
  void dispose() {
    numberStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    transformer = StreamTransformer<int, int>.fromHandlers(
      handleData: (value, sink) {
        sink.add(value * 10);
      },
      handleError: (error, trace, sink) {
        sink.add(-1);
      },
      handleDone: (sink) => sink.close(),
    );
    numberStream = NumberStream();
    numberStreamController = numberStream.controller;
    Stream stream = numberStreamController.stream;
    stream
        .transform(transformer)
        .listen((event) {
          setState(() {
            lastNumber = event;
          });
        })
        .onError((error) {
          setState(() {
            lastNumber = -1;
          });
        });
    // stream.listen((event) {
    //       setState(() {
    //         lastNumber = event;
    //       });
    //     }).onError((error) {
    //       setState(() {
    //         lastNumber = -1;
    //       });
    //     });
    super.initState();
    // colorStream = ColorStream();
    // changeColor();
  }

  void changeColor() async {
    colorStream.getColors.listen((eventColor) {
      setState(() {
        bgColor = eventColor;
      });
    });
    // await for (var eventColor in colorStream.getColors) {
    //   setState(() {
    //     bgColor = eventColor;
    //   });
    // }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stream Zidane")),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(lastNumber.toString()),
            ElevatedButton(
              onPressed: () => addRandomNumber(),
              child: Text("New Random Number"),
            ),
          ],
        ),
      ),
      // body: Container(decoration: BoxDecoration(color: bgColor)),
    );
    // return Container();
  }
}
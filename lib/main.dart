import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(seconds: 3),
    )
      ..forward()
      ..addStatusListener((status) {
        if (_controller.isCompleted) {
          counter++;
          if (counter > 7) counter = 0;
          _controller.forward(from: 0);
        }
      });

    super.initState();
  }

  final colors = const <Color>[Colors.red, Colors.green, Colors.black, Colors.grey, Colors.amber, Colors.blue, Colors.cyan, Colors.indigoAccent, Colors.purple, Colors.purpleAccent];
  int counter = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
          body: AspectRatio(
        aspectRatio: 1,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => CustomPaint(
            painter: ProgressPainter(
              counter: counter,
              progress: _controller.value,
              backgroundColor: Colors.white,
              progresColor: colors[counter],
            ),
          ),
        ),
      ));
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final Color progresColor;
  final Color backgroundColor;
  final int counter;
  ProgressPainter({required this.progress, this.counter = 0, this.progresColor = Colors.red, this.backgroundColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width / 15;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final background = Paint()
      ..strokeWidth = strokeWidth - 1
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = backgroundColor;
    canvas.drawCircle(center, radius, background);
    final progressBar = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = progresColor;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      (pi * progress / 4) + (pi / 4) * counter,
      2 * pi * progress,
      false,
      progressBar,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressPainter oldDelegate) => oldDelegate.progress != progress;
}

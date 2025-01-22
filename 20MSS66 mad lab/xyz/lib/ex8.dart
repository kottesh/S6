import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PaintApp extends StatelessWidget {
  const PaintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PaintScreen(),
    );
  }
}

enum DrawingTool { pencil, line, rectangle, circle, eraser }

class DrawingPoint {
  final Offset point;
  final Paint paint;
  DrawingPoint({required this.point, required this.paint});
}

class PaintScreen extends StatefulWidget {
  const PaintScreen({super.key});

  @override
  PaintScreenState createState() => PaintScreenState();
}

class PaintScreenState extends State<PaintScreen> {
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoint?> points = [];
  DrawingTool selectedTool = DrawingTool.pencil;
  Offset? startPoint;
  Offset? endPoint;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                points.clear();
                startPoint = null;
                endPoint = null;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                startPoint = details.localPosition;
                if (selectedTool == DrawingTool.pencil || 
                    selectedTool == DrawingTool.eraser) {
                  points.add(
                    DrawingPoint(
                      point: details.localPosition,
                      paint: Paint()
                        ..strokeCap = StrokeCap.round
                        ..isAntiAlias = true
                        ..color = selectedTool == DrawingTool.eraser 
                            ? Colors.white 
                            : selectedColor
                        ..strokeWidth = strokeWidth
                        ..style = PaintingStyle.stroke,
                    ),
                  );
                }
              });
            },
            onPanUpdate: (details) {
              setState(() {
                endPoint = details.localPosition;
                if (selectedTool == DrawingTool.pencil || 
                    selectedTool == DrawingTool.eraser) {
                  points.add(
                    DrawingPoint(
                      point: details.localPosition,
                      paint: Paint()
                        ..strokeCap = StrokeCap.round
                        ..isAntiAlias = true
                        ..color = selectedTool == DrawingTool.eraser 
                            ? Colors.white 
                            : selectedColor
                        ..strokeWidth = strokeWidth
                        ..style = PaintingStyle.stroke,
                    ),
                  );
                }
              });
            },
            onPanEnd: (details) {
              setState(() {
                if (selectedTool != DrawingTool.pencil && 
                    selectedTool != DrawingTool.eraser) {
                  points.add(null);
                }
              });
            },
            child: CustomPaint(
              painter: DrawingPainter(
                points: points,
                selectedTool: selectedTool,
                startPoint: startPoint,
                endPoint: endPoint,
                selectedColor: selectedColor,
                strokeWidth: strokeWidth,
              ),
              size: Size.infinite,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildToolButton(DrawingTool.pencil, Icons.edit),
                      _buildToolButton(DrawingTool.line, Icons.show_chart),
                      _buildToolButton(
                          DrawingTool.rectangle, Icons.crop_square),
                      _buildToolButton(
                          DrawingTool.circle, Icons.radio_button_unchecked),
                      _buildToolButton(DrawingTool.eraser, Icons.auto_fix_normal),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildColorButton(Colors.black),
                      _buildColorButton(Colors.red),
                      _buildColorButton(Colors.blue),
                      _buildColorButton(Colors.green),
                      _buildColorButton(Colors.yellow),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: strokeWidth,
                    min: 1,
                    max: 20,
                    onChanged: (value) {
                      setState(() {
                        strokeWidth = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(DrawingTool tool, IconData icon) {
    return IconButton(
      icon: Icon(icon),
      color: selectedTool == tool ? Colors.blue : Colors.black,
      onPressed: () {
        setState(() {
          selectedTool = tool;
        });
      },
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: selectedColor == color ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;
  final DrawingTool selectedTool;
  final Offset? startPoint;
  final Offset? endPoint;
  final Color selectedColor;
  final double strokeWidth;

  DrawingPainter({
    required this.points,
    required this.selectedTool,
    required this.startPoint,
    required this.endPoint,
    required this.selectedColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all existing points
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.point,
          points[i + 1]!.point,
          points[i]!.paint,
        );
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [points[i]!.point],
          points[i]!.paint,
        );
      }
    }

    // Draw current shape if start and end points exist
    if (startPoint != null && endPoint != null) {
      final paint = Paint()
        ..color = selectedColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      switch (selectedTool) {
        case DrawingTool.line:
          canvas.drawLine(startPoint!, endPoint!, paint);
          break;
        case DrawingTool.rectangle:
          final rect = Rect.fromPoints(startPoint!, endPoint!);
          canvas.drawRect(rect, paint);
          break;
        case DrawingTool.circle:
          final rect = Rect.fromPoints(startPoint!, endPoint!);
          canvas.drawOval(rect, paint);
          break;
        default:
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
import 'package:flutter/material.dart';

void main() {
  runApp(const NeonPaintApp());
}

class NeonPaintApp extends StatelessWidget {
  const NeonPaintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نقاشی نئونی',
      theme: ThemeData.dark(),
      home: const PaintHomePage(),
    );
  }
}

class PaintHomePage extends StatefulWidget {
  const PaintHomePage({super.key});

  @override
  State<PaintHomePage> createState() => _PaintHomePageState();
}

class _PaintHomePageState extends State<PaintHomePage> {
  List<DrawingPoint?> points = [];
  Color selectedColor = Colors.cyan;
  double strokeWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('نقاشی جادویی بچه‌ها'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.redAccent),
            onPressed: () => setState(() => points.clear()),
            tooltip: 'پاک کردن صفحه',
          ),
        ],
      ),
      body: Stack(
        children: [
          // بوم نقاشی
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                points.add(DrawingPoint(
                  point: localPosition,
                  paint: Paint()
                    ..color = selectedColor
                    ..isAntiAlias = true
                    ..strokeWidth = strokeWidth
                    ..strokeCap = StrokeCap.round,
                ));
              });
            },
            onPanEnd: (details) => setState(() => points.add(null)),
            child: CustomPaint(
              painter: SketchPainter(points: points),
              size: Size.infinite,
            ),
          ),
          // پالت رنگ‌ها در پایین صفحه
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[900]?.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  colorButton(Colors.cyan),
                  colorButton(Colors.pinkAccent),
                  colorButton(Colors.amber),
                  colorButton(Colors.greenAccent),
                  colorButton(Colors.purpleAccent),
                  colorButton(Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget colorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}

class DrawingPoint {
  Offset point;
  Paint paint;
  DrawingPoint({required this.point, required this.paint});
}

class SketchPainter extends CustomPainter {
  final List<DrawingPoint?> points;
  SketchPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.len - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!.point, points[i + 1]!.point, points[i]!.paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!.point], points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

class DrawingCanvasScreen extends StatefulWidget {
  const DrawingCanvasScreen({super.key});

  @override
  State<DrawingCanvasScreen> createState() => _DrawingCanvasScreenState();
}

class _DrawingCanvasScreenState extends State<DrawingCanvasScreen> {
  final List<DrawingPoint?> points = [];
  final List<DrawingPoint?> redoPoints = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  bool isEraser = false;
  Timer? _timer;
  int _remainingSeconds = 300; // 5 minutes
  bool _isTimerRunning = false;
  final TextEditingController _journalController = TextEditingController();
  DrawingTool currentTool = DrawingTool.pen;

  @override
  void dispose() {
    _timer?.cancel();
    _journalController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isTimerRunning = false;
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 300;
      _isTimerRunning = false;
    });
  }

  void _showTimerSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Timer Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: _remainingSeconds.toDouble(),
              min: 60,
              max: 1800,
              divisions: 29,
              label: '${(_remainingSeconds / 60).round()} minutes',
              onChanged: (value) {
                setState(() {
                  _remainingSeconds = value.round();
                });
              },
            ),
            Text('${(_remainingSeconds / 60).round()} minutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _undo() {
    if (points.isNotEmpty) {
      setState(() {
        redoPoints.add(points.removeLast());
      });
    }
  }

  void _redo() {
    if (redoPoints.isNotEmpty) {
      setState(() {
        points.add(redoPoints.removeLast());
      });
    }
  }

  void _clearCanvas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Canvas'),
        content: const Text('Are you sure you want to clear the canvas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                points.clear();
                redoPoints.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showJournalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Journal'),
        content: TextField(
          controller: _journalController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Describe your artwork...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Save journal entry
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSaveDialog() {
    final TextEditingController titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Artwork'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'Enter artwork name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                // TODO: Save artwork with title
                Navigator.pop(context);
                Navigator.pop(context); // Return to previous screen
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Header with blue background
                Container(
                  color: const Color(0xFFE0F4FF),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.black87),
                      ),
                      const Spacer(),
                      // Timer Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: _isTimerRunning ? _stopTimer : _startTimer,
                        icon: Icon(
                          _isTimerRunning ? Icons.pause : Icons.play_arrow,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: _showTimerSettings,
                        icon: const Icon(Icons.timer, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                // Drawing Canvas
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ClipRect(
                      child: GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            points.add(
                              DrawingPoint(
                                offset: details.localPosition,
                                paint: _getPaintForTool(),
                              ),
                            );
                            redoPoints.clear();
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            points.add(
                              DrawingPoint(
                                offset: details.localPosition,
                                paint: _getPaintForTool(),
                              ),
                            );
                          });
                        },
                        onPanEnd: (details) {
                          setState(() {
                            points.add(null);
                          });
                        },
                        child: CustomPaint(
                          painter: DrawingPainter(points: points),
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Bottom Toolbar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drawing Tools
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildToolButton(DrawingTool.pen, Icons.edit),
                        _buildToolButton(DrawingTool.pencil, Icons.create),
                        _buildToolButton(DrawingTool.brush, Icons.brush),
                        _buildToolButton(
                            DrawingTool.eraser, Icons.auto_fix_high),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Color Picker and Brush Size
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Color Picker
                        GestureDetector(
                          onTap: _showColorPicker,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: selectedColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black12,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        // Brush Size Slider
                        Expanded(
                          child: Slider(
                            value: strokeWidth,
                            min: 1,
                            max: 20,
                            divisions: 19,
                            label: strokeWidth.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                strokeWidth = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: _undo,
                          icon: const Icon(Icons.undo),
                        ),
                        IconButton(
                          onPressed: _redo,
                          icon: const Icon(Icons.redo),
                        ),
                        IconButton(
                          onPressed: _clearCanvas,
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: _showJournalDialog,
                          icon: const Icon(Icons.book),
                        ),
                        ElevatedButton(
                          onPressed: _showSaveDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE0F4FF),
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton(DrawingTool tool, IconData icon) {
    final isSelected = currentTool == tool;
    return IconButton(
      onPressed: () {
        setState(() {
          currentTool = tool;
          if (tool == DrawingTool.eraser) {
            isEraser = true;
          } else {
            isEraser = false;
          }
        });
      },
      icon: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black54,
      ),
    );
  }

  Paint _getPaintForTool() {
    final paint = Paint()
      ..color = isEraser ? Colors.white : selectedColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (currentTool) {
      case DrawingTool.pen:
        paint
          ..strokeWidth = isEraser ? strokeWidth * 2 : strokeWidth
          ..style = PaintingStyle.stroke;
        break;
      case DrawingTool.pencil:
        paint
          ..strokeWidth = isEraser ? strokeWidth * 2 : strokeWidth * 0.5
          ..style = PaintingStyle.stroke;
        break;
      case DrawingTool.brush:
        paint
          ..strokeWidth = isEraser ? strokeWidth * 2 : strokeWidth * 2
          ..style = PaintingStyle.stroke;
        break;
      case DrawingTool.eraser:
        paint
          ..strokeWidth = strokeWidth * 2
          ..style = PaintingStyle.stroke;
        break;
    }
    return paint;
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Color'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
                isEraser = false;
                currentTool = DrawingTool.pen;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}

enum DrawingTool {
  pen,
  pencil,
  brush,
  eraser,
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({
    required this.offset,
    required this.paint,
  });
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
            points[i]!.offset, points[i + 1]!.offset, points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ColorPicker extends StatelessWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _colors.length,
      itemBuilder: (context, index) {
        final color = _colors[index];
        final isSelected = color == pickerColor;
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.black12,
                width: isSelected ? 3 : 2,
              ),
            ),
          ),
        );
      },
    );
  }

  static const List<Color> _colors = [
    Colors.black,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];
}

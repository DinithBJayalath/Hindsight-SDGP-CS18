import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math';

class DrawingCanvasScreen extends StatefulWidget {
  const DrawingCanvasScreen({super.key});

  @override
  State<DrawingCanvasScreen> createState() => _DrawingCanvasScreenState();
}

class _DrawingCanvasScreenState extends State<DrawingCanvasScreen> {
  final List<DrawingPoint?> points = [];
  final List<DrawingPoint?> redoPoints = [];
  final List<List<List<Color>>> undoCanvasPixels = [];
  final List<List<List<Color>>> redoCanvasPixels = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  bool isEraser = false;
  Timer? _timer;
  int _remainingSeconds = 300; // 5 minutes
  bool _isTimerRunning = false;
  final TextEditingController _journalController = TextEditingController();
  DrawingTool currentTool = DrawingTool.pen;
  List<List<Color>> canvasPixels = [];
  double canvasWidth = 0;
  double canvasHeight = 0;
  double scaleFactor = 2.0; // Added scale factor

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final availableHeight =
          size.height - 300; // Account for header and toolbar

      // Set a maximum size for better performance
      canvasWidth = size.width;
      canvasHeight = availableHeight;

      if (canvasWidth > 800) canvasWidth = 800;
      if (canvasHeight > 1000) canvasHeight = 1000;

      _initializeCanvas();
    });
  }

  void _initializeCanvas() {
    final width = (canvasWidth / scaleFactor).ceil();
    final height = (canvasHeight / scaleFactor).ceil();
    canvasPixels = List.generate(
      height,
      (y) => List.generate(width, (x) => Colors.white),
    );
    // Save initial state for undo
    undoCanvasPixels.add(_copyCanvasPixels());
  }

  List<List<Color>> _copyCanvasPixels() {
    return List.generate(
      canvasPixels.length,
      (y) => List.from(canvasPixels[y]),
    );
  }

  void _floodFill(Offset startPoint) {
    if (canvasPixels.isEmpty) return;

    // Save state before fill for undo
    undoCanvasPixels.add(_copyCanvasPixels());
    redoCanvasPixels.clear();

    final targetColor = Colors.white;
    final replacementColor = selectedColor;

    final scaledX =
        ((startPoint.dx / canvasWidth) * canvasPixels[0].length).floor();
    final scaledY =
        ((startPoint.dy / canvasHeight) * canvasPixels.length).floor();

    if (scaledX < 0 ||
        scaledX >= canvasPixels[0].length ||
        scaledY < 0 ||
        scaledY >= canvasPixels.length) {
      return;
    }

    if (canvasPixels[scaledY][scaledX] == replacementColor) return;

    final queue = <Point<int>>[];
    queue.add(Point(scaledX, scaledY));

    while (queue.isNotEmpty) {
      final point = queue.removeAt(0);
      final x = point.x;
      final y = point.y;

      if (x < 0 ||
          x >= canvasPixels[0].length ||
          y < 0 ||
          y >= canvasPixels.length) continue;
      if (canvasPixels[y][x] != targetColor) continue;

      canvasPixels[y][x] = replacementColor;

      if (x + 1 < canvasPixels[0].length) queue.add(Point(x + 1, y));
      if (x - 1 >= 0) queue.add(Point(x - 1, y));
      if (y + 1 < canvasPixels.length) queue.add(Point(x, y + 1));
      if (y - 1 >= 0) queue.add(Point(x, y - 1));
    }

    setState(() {
      points.add(DrawingPoint(
        offset: startPoint,
        paint: _getPaintForTool(),
        type: DrawingPointType.fill,
      ));
    });
  }

  void _handleCanvasTap(TapDownDetails details) {
    if (currentTool == DrawingTool.fill) {
      _floodFill(details.localPosition);
    }
  }

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
    if (points.isNotEmpty || undoCanvasPixels.length > 1) {
      setState(() {
        if (points.isNotEmpty) {
          redoPoints.add(points.removeLast());
        }
        if (undoCanvasPixels.length > 1) {
          redoCanvasPixels.add(_copyCanvasPixels());
          canvasPixels = undoCanvasPixels.removeLast();
        }
      });
    }
  }

  void _redo() {
    if (redoPoints.isNotEmpty || redoCanvasPixels.isNotEmpty) {
      setState(() {
        if (redoPoints.isNotEmpty) {
          points.add(redoPoints.removeLast());
        }
        if (redoCanvasPixels.isNotEmpty) {
          undoCanvasPixels.add(_copyCanvasPixels());
          canvasPixels = redoCanvasPixels.removeLast();
        }
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
                // Save current state for undo
                undoCanvasPixels.add(_copyCanvasPixels());
                redoCanvasPixels.clear();

                // Clear everything
                points.clear();
                redoPoints.clear();
                _initializeCanvas();
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
                  child: Center(
                    child: Container(
                      width: canvasWidth,
                      height: canvasHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                          onTapDown: currentTool == DrawingTool.fill
                              ? _handleCanvasTap
                              : null,
                          onPanStart: (details) {
                            if (currentTool != DrawingTool.fill) {
                              // Save state before new stroke
                              undoCanvasPixels.add(_copyCanvasPixels());
                              redoCanvasPixels.clear();

                              setState(() {
                                points.add(DrawingPoint(
                                  offset: details.localPosition,
                                  paint: _getPaintForTool(),
                                  type: DrawingPointType.start,
                                ));
                              });
                            }
                          },
                          onPanUpdate: (details) {
                            if (currentTool != DrawingTool.fill) {
                              setState(() {
                                points.add(DrawingPoint(
                                  offset: details.localPosition,
                                  paint: _getPaintForTool(),
                                  type: DrawingPointType.update,
                                ));
                              });
                            }
                          },
                          onPanEnd: (_) {
                            if (currentTool != DrawingTool.fill) {
                              setState(() {
                                points.add(null);
                              });
                            }
                          },
                          child: CustomPaint(
                            painter: DrawingPainter(
                              points: points,
                              canvasPixels: canvasPixels,
                              scaleFactor: scaleFactor,
                            ),
                            size: Size(canvasWidth, canvasHeight),
                          ),
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
                            DrawingTool.fill, Icons.format_color_fill),
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
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    switch (currentTool) {
      case DrawingTool.pen:
        paint.strokeWidth = 2.0;
        break;
      case DrawingTool.pencil:
        paint.strokeWidth = 1.0;
        break;
      case DrawingTool.brush:
        paint.strokeWidth = 5.0;
        break;
      case DrawingTool.eraser:
        paint.color = Colors.white;
        paint.strokeWidth = 20.0;
        break;
      case DrawingTool.fill:
        paint.style = PaintingStyle.fill;
        break;
    }
    return paint;
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Color',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ColorPicker(
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
          ],
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
  fill,
}

enum DrawingPointType {
  start,
  update,
  end,
  fill,
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;
  final DrawingPointType type;

  DrawingPoint({
    required this.offset,
    required this.paint,
    required this.type,
  });
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;
  final List<List<Color>> canvasPixels;
  final double scaleFactor;

  DrawingPainter({
    required this.points,
    required this.canvasPixels,
    required this.scaleFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the filled pixels
    if (canvasPixels.isNotEmpty) {
      final pixelWidth = size.width / canvasPixels[0].length;
      final pixelHeight = size.height / canvasPixels.length;

      for (int y = 0; y < canvasPixels.length; y++) {
        for (int x = 0; x < canvasPixels[y].length; x++) {
          if (canvasPixels[y][x] != Colors.white) {
            canvas.drawRect(
              Rect.fromLTWH(
                x * pixelWidth,
                y * pixelHeight,
                pixelWidth,
                pixelHeight,
              ),
              Paint()..color = canvasPixels[y][x],
            );
          }
        }
      }
    }

    // Draw the strokes
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        if (points[i]!.type == DrawingPointType.fill) {
          continue;
        }
        canvas.drawLine(
          points[i]!.offset,
          points[i + 1]!.offset,
          points[i]!.paint,
        );
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(
          PointMode.points,
          [points[i]!.offset],
          points[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return true;
  }
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

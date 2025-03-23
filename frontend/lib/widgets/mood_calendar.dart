import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class MoodCalendar extends StatefulWidget {
  final List<MoodEntry> entries;
  final Function(DateTime)? onMonthChanged;

  const MoodCalendar({
    super.key,
    required this.entries,
    this.onMonthChanged,
  });

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;

    // Defer calling parent's onMonthChanged to avoid setState in build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMonthChanged?.call(_focusedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendarHeader(),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
            });
            widget.onMonthChanged?.call(_focusedDay);
          },
        ),
        Text(
          '${_getMonthName(_focusedDay.month)}, ${_focusedDay.year}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
            });
            widget.onMonthChanged?.call(_focusedDay);
          },
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    const daysOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
    final daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final numRows = ((firstWeekdayOfMonth + daysInMonth) / 7).ceil();
    final numCells = numRows * 7;

    return Column(
      children: [
        // Days-of-week row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysOfWeek.map((d) => Expanded(
            child: Text(
              d,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )).toList(),
        ),
        // Day cells
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: numCells,
          itemBuilder: (context, index) {
            final dayOffset = index - firstWeekdayOfMonth;
            final dayNum = dayOffset + 1;

            if (dayOffset < 0 || dayNum > daysInMonth) {
              return const SizedBox.shrink();
            }

            final date = DateTime(_focusedDay.year, _focusedDay.month, dayNum);

            // Gather all moods for this date
            final dailyEntries = widget.entries
                .where((entry) => _isSameDay(entry.date, date))
                .toList();

            final isSelected = _isSameDay(date, _selectedDay);
            final isToday = _isSameDay(date, DateTime.now());

            // Build the row of emojis or bin icon
            Widget moodRow = _buildMoodRow(dailyEntries);

            return GestureDetector(
              onTap: () {
                setState(() => _selectedDay = date);
                _showMoodsPopup(context, date, dailyEntries);
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green.shade100 : null,
                  border: isToday ? Border.all(color: Colors.blue, width: 1) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$dayNum',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    moodRow,
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Build a row of emojis if multiple moods exist; 
  /// or bin icon if no moods.
  Widget _buildMoodRow(List<MoodEntry> dailyEntries) {
    if (dailyEntries.isEmpty) {
      // Show a bin icon for empty days
      return const Icon(
        Icons.delete_outline,
        size: 20,
        color: Colors.redAccent,
      );
    }

    // Convert each mood to an emoji
    final emojis = dailyEntries.map((e) => _moodToEmoji(e.mood)).toList();

    // If 3 or fewer moods => show them all
    // If more than 3 => show first 3 plus "+(count - 3)"
    if (emojis.length <= 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: emojis.map((em) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Text(em, style: const TextStyle(fontSize: 14)),
        )).toList(),
      );
    } else {
      final firstThree = emojis.take(3).toList();
      final plusCount = emojis.length - 3;

      // Build a row with the first 3 + "+N"
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var em in firstThree)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text(em, style: const TextStyle(fontSize: 14)),
            ),
          Text("+$plusCount", style: const TextStyle(fontSize: 12)),
        ],
      );
    }
  }

  // Show an AlertDialog listing all moods in that day
  void _showMoodsPopup(BuildContext context, DateTime date, List<MoodEntry> dailyEntries) {
    final dateLabel = "${date.day}/${date.month}/${date.year}";

    if (dailyEntries.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Moods for $dateLabel"),
            content: const Text("No moods for this date."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } else {
      // Show a bullet list of all moods
      final moodList = dailyEntries.map((m) => "• ${m.mood}").join("\n");

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Moods for $dateLabel"),
            content: Text(moodList),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    }
  }

  String _moodToEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'very happy': return '🤩';
      case 'happy':      return '😊';
      case 'sad':        return '😢';
      case 'excited':    return '🤩';
      case 'angry':      return '😡';
      case 'neutral':    return '😐';
      default:           return '';
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month-1];
}
}
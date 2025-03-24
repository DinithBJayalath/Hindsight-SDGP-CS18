import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mood_viewmodel.dart';
import '../widgets/mood_calendar.dart';
import '../widgets/montly_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedMonth = DateTime.now();  // Store selected month

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MoodViewModel>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Dashboard"),
      ),
      body: SafeArea(
        child: Consumer<MoodViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final moods = viewModel.entries;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Pass the onMonthChanged callback to get the selected month
                    MoodCalendar(
                      entries: moods,
                      onMonthChanged: (newMonth) {
                        setState(() {
                          _selectedMonth = newMonth;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: MonthlyChart(
                        entries: moods,
                        selectedMonth: _selectedMonth, // Pass the selected month
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     final now = DateTime.now();
      //     final formattedDate =
      //         "${now.day}/${now.month}/${now.year} - ${now.hour}:${now.minute.toString().padLeft(2, '0')}";
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext ctx) {
      //         return AlertDialog(
      //           title: const Text("Information"),
      //           content: Text("Current date & time: $formattedDate\n\n"
      //               "Selected Month: ${_selectedMonth.month}/${_selectedMonth.year}\n"
      //               "This is a static pop-up. No mood is being added."),
      //           actions: [
      //             TextButton(
      //               onPressed: () => Navigator.pop(ctx),
      //               child: const Text("Close"),
      //             ),
      //           ],
      //         );
      //       },
      //     );
      //   },
      //   child: const Icon(Icons.info),
      // ),
    );
  }
}

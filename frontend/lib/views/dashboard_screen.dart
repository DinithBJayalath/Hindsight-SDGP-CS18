// lib/views/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/mood_entry.dart';  // Add this import
import '../viewmodels/mood_viewmodel.dart';
import 'widgets/mood_calendar.dart';
import 'widgets/mood_chart.dart';
import 'widgets/stats_card.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      body: SafeArea(
        child: Consumer<MoodViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mood Dashboard',
                    style: TextStyle(
                     fontSize: 24,
                     fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StatsCard(stats: viewModel.stats),
                  const SizedBox(height: 16),
                  Expanded(
                    child: MoodCalendar(entries: viewModel.entries),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 250, // Increased height for better visibility
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: MoodChart(entries: testData), // Use test data here
                  ),
                ],
              ),
            );
          },
        ),
      );
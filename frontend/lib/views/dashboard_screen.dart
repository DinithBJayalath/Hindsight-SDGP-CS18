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
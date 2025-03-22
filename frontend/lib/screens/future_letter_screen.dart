import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/letter.dart';
import '../services/letter_service.dart';

class FutureLetterScreen extends StatefulWidget {
  const FutureLetterScreen({super.key});

  @override
  State<FutureLetterScreen> createState() => _FutureLetterScreenState();
}

class _FutureLetterScreenState extends State<FutureLetterScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _letterController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  bool _isCustomDate = false;
  String _selectedPeriod = '1 month';
  final LetterService _letterService = LetterService();
  bool _isSaving = false;

  final List<String> _predefinedPeriods = [
    '1 month',
    '3 months',
    '6 months',
    '1 year'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _letterController.dispose();
    super.dispose();
  }

  void _handleDateSelection(String period) {
    setState(() {
      _selectedPeriod = period;
      _isCustomDate = false;
      switch (period) {
        case '1 month':
          _selectedDate = DateTime.now().add(const Duration(days: 30));
          break;
        case '3 months':
          _selectedDate = DateTime.now().add(const Duration(days: 90));
          break;
        case '6 months':
          _selectedDate = DateTime.now().add(const Duration(days: 180));
          break;
        case '1 year':
          _selectedDate = DateTime.now().add(const Duration(days: 365));
          break;
      }
    });
  }

  Future<void> _selectCustomDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE0F4FF),
              onPrimary: Colors.black87,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _isCustomDate = true;
        _selectedPeriod = '';
      });
    }
  }

  Future<void> _saveLetter() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title for your letter'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_letterController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your letter'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Create letter object
      final letter = Letter(
        title: _titleController.text,
        content: _letterController.text,
        userId: 'user123', // Replace with actual user ID from auth
        deliveryDate: _selectedDate,
      );

      // Save to database
      await _letterService.saveLetter(letter);

      if (mounted) {
        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Letter saved successfully! You\'ll receive it on the selected date.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return success to previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save letter: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Blue Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE0F4FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.arrow_back_ios, color: Colors.black87),
                  ),
                  const Expanded(
                    child: Text(
                      'Letter to Future Self',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: _saveLetter,
                    icon: const Icon(Icons.check, color: Colors.black87),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Input
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Give your letter a meaningful title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Delivery Date Selection
                    const Text(
                      'When would you like to receive this letter?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Predefined Periods
                    Wrap(
                      spacing: 8,
                      children: _predefinedPeriods.map((period) {
                        final isSelected = period == _selectedPeriod;
                        return ChoiceChip(
                          label: Text(period),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              _handleDateSelection(period);
                            }
                          },
                          backgroundColor: Colors.grey[100],
                          selectedColor: const Color(0xFFE0F4FF),
                          labelStyle: TextStyle(
                            color:
                                isSelected ? Colors.black87 : Colors.grey[600],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    // Custom Date Selection
                    ListTile(
                      title: const Text('Custom Date'),
                      subtitle: Text(
                        DateFormat('MMMM d, y').format(_selectedDate),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      tileColor: _isCustomDate
                          ? const Color(0xFFE0F4FF)
                          : Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: _selectCustomDate,
                    ),
                    const SizedBox(height: 24),
                    // Letter Content
                    TextField(
                      controller: _letterController,
                      maxLines: null,
                      minLines: 10,
                      decoration: InputDecoration(
                        labelText: 'Your Letter',
                        hintText: 'Dear future me...',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
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
}

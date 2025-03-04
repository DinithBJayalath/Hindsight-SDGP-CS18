import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'future_letter_screen.dart';

class FutureLettersListScreen extends StatefulWidget {
  const FutureLettersListScreen({super.key});

  @override
  State<FutureLettersListScreen> createState() =>
      _FutureLettersListScreenState();
}

class _FutureLettersListScreenState extends State<FutureLettersListScreen> {
  // TODO: Replace with actual data storage
  final List<FutureLetter> _letters = [
    FutureLetter(
      id: '1',
      title: 'My Goals for Next Year',
      createdAt: DateTime.now(),
      openDate: DateTime.now().add(const Duration(days: 365)),
    ),
    FutureLetter(
      id: '2',
      title: 'Dear Future Me in 3 Months',
      createdAt: DateTime.now(),
      openDate: DateTime.now().add(const Duration(days: 90)),
    ),
  ];

  void _handleLetterTap(FutureLetter letter) {
    if (letter.openDate.isAfter(DateTime.now())) {
      // Show message if letter can't be opened yet
      final remainingDays = letter.openDate.difference(DateTime.now()).inDays;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Letter Not Ready'),
          content: Text(
            'This letter will be available to read in $remainingDays days, on ${DateFormat('MMMM d, y').format(letter.openDate)}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // TODO: Implement letter viewing functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening letter...'),
        ),
      );
    }
  }

  void _createNewLetter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FutureLetterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE0F4FF),
              const Color(0xFFCCE9FF),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: false,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Letters to Future Self',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Write letters to your future self and unlock them when the time comes.',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 200,
                  ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // New Letter Button
                        Center(
                          child: ElevatedButton(
                            onPressed: _createNewLetter,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE0F4FF),
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'Write New Letter',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Your Letters',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Letters List
                        _letters.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.mail_outline,
                                      size: 64,
                                      color: Colors.black26,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No Letters Yet',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Write your first letter to your future self',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _letters.length,
                                itemBuilder: (context, index) {
                                  final letter = _letters[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: LetterCard(
                                      letter: letter,
                                      onTap: () => _handleLetterTap(letter),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LetterCard extends StatelessWidget {
  final FutureLetter letter;
  final VoidCallback onTap;

  const LetterCard({
    super.key,
    required this.letter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = letter.openDate.isAfter(DateTime.now());

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFE0F4FF),
                const Color(0xFFCCE9FF),
              ],
            ),
            border: Border.all(
              color: Colors.black12,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black12,
                          width: 0.5,
                        ),
                      ),
                      child: Icon(
                        isLocked ? Icons.lock : Icons.mail,
                        size: 32,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            letter.title,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Opens on ${DateFormat('MMMM d, y').format(letter.openDate)}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: isLocked ? Colors.black45 : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FutureLetter {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime openDate;

  const FutureLetter({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.openDate,
  });
}

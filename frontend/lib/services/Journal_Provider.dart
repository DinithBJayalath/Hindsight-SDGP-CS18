import 'package:flutter/foundation.dart';

class JournalProvider extends ChangeNotifier {
  List<Map<String, String>> _journalEntries = [];

  List<Map<String, String>> get journalEntries => _journalEntries;

}
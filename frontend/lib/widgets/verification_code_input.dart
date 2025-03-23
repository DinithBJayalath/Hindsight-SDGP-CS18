import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationCodeInput extends StatefulWidget {
  final Function(String) onCompleted;
  final int length;
  final bool autofocus;

  const VerificationCodeInput({
    super.key,
    required this.onCompleted,
    this.length = 6,
    this.autofocus = true,
  });

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _verificationCode = '';

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length > 1) {
      // If pasting a longer string
      if (value.length == widget.length) {
        // If user pastes exactly the right number of digits
        for (int i = 0; i < widget.length; i++) {
          _controllers[i].text = value[i];
        }
        widget.onCompleted(value);
      } else {
        _controllers[index].text = value[0];
      }
    }

    // Move to next field
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Update the verification code
    _updateVerificationCode();
  }

  void _updateVerificationCode() {
    _verificationCode =
        _controllers.map((controller) => controller.text).join();
    if (_verificationCode.length == widget.length) {
      widget.onCompleted(_verificationCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get the exact available width
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate field size based on available width
        final availableWidth = constraints.maxWidth;

        // Space between fields (use smaller spacing in tight constraints)
        final spacing = 4.0;

        // Total space used by spacing
        final totalSpacing = spacing * (widget.length - 1);

        // Calculate width for each field
        final fieldWidth =
            ((availableWidth - totalSpacing) / widget.length).floorToDouble();

        // Create appropriately sized text fields
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          children: List.generate(
            widget.length,
            (index) => Container(
              width: fieldWidth,
              height: fieldWidth *
                  1.2, // Make height proportional to width for better appearance
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                autofocus: widget.autofocus && index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(fontSize: 20), // Smaller font size
                decoration: InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Add vertical padding
                  isDense: true, // Make the input field more compact
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) => _onCodeChanged(value, index),
              ),
            ),
          ),
        );
      },
    );
  }
}

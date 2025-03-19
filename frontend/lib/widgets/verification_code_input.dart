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
    // Calculate available width and adjust field size accordingly
    final screenWidth = MediaQuery.of(context).size.width;
    // Total space between items (widget.length - 1 spaces)
    final spaceBetween = (widget.length - 1) * 8.0;
    // Padding on both sides
    final sidePadding = 32.0;
    // Calculate field width based on available space
    final fieldWidth =
        (screenWidth - spaceBetween - sidePadding) / widget.length;
    // Ensure minimum size of 40 and maximum of 50
    final adjustedWidth = fieldWidth.clamp(40.0, 50.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.length,
          (index) => SizedBox(
            width: adjustedWidth,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              autofocus: widget.autofocus && index == 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: const TextStyle(fontSize: 24),
              decoration: InputDecoration(
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.zero,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) => _onCodeChanged(value, index),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.answer,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey.shade300;
    Color backgroundColor = Colors.white;

    if (showResult) {
      if (isSelected) {
        if (isCorrect) {
          borderColor = Colors.green;
          backgroundColor = Colors.green.withOpacity(0.1);
        } else {
          borderColor = Colors.red;
          backgroundColor = Colors.red.withOpacity(0.1);
        }
      } else if (isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
      }
    } else if (isSelected) {
      borderColor = const Color(0xFF6366F1);
      backgroundColor = const Color(0xFF6366F1).withOpacity(0.1);
    }

    return InkWell(
      onTap: showResult ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showResult && isCorrect)
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
            if (showResult && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: Colors.red, size: 28),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CheapCheckbox extends StatelessWidget {
  CheapCheckbox(this.value, {this.onChanged, Key? key}) : super(key: key);
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(value ? '✅' : '🔲'),
      onTap: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardInput extends StatelessWidget {
  const CardInput({
    super.key,
    this.initialValue,
    this.inputFormatters,
    this.keyboardType,
    this.onFieldSubmitted,
  });

  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
        ),
        initialValue: initialValue,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}

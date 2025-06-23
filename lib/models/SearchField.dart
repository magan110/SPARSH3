import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchField({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: (MediaQuery.of(context).size.width * 0.04).clamp(14.0, 18.0),
      ),
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(
          fontSize: (MediaQuery.of(context).size.width * 0.035).clamp(
            12.0,
            16.0,
          ),
        ),
        prefixIcon: Icon(
          Icons.search,
          size: (MediaQuery.of(context).size.width * 0.06).clamp(20.0, 28.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.04,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

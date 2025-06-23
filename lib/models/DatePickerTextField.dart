import 'package:flutter/material.dart';

class DatePickerTextField extends StatefulWidget {
  const DatePickerTextField({super.key});

  @override
  _DatePickerTextFieldState createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width * 0.02,
      ),
      child: TextFormField(
        controller: _controller,
        readOnly: true,
        onTap: () => _selectDate(context),
        style: TextStyle(
          fontSize: (MediaQuery.of(context).size.width * 0.04).clamp(
            14.0,
            18.0,
          ),
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: 'Select Date',
          labelStyle: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w600,
            fontSize: (MediaQuery.of(context).size.width * 0.035).clamp(
              12.0,
              16.0,
            ),
          ),
          hintText: 'yyyy-mm-dd',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
          filled: true,
          fillColor: Colors.blue.shade50,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 12.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

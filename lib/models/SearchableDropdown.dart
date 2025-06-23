import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

/// A reusable dropdown search widget function.
/// Usage: `buildSearchableDropdown(context, itemsList)`
Widget buildSearchableDropdown(BuildContext context, List<String> items) {
  return Padding(
    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
    child: DropdownSearch<String>(
      items: items,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          style: TextStyle(
            fontSize: (MediaQuery.of(context).size.width * 0.04).clamp(
              14.0,
              18.0,
            ),
          ),
          decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: TextStyle(
              fontSize: (MediaQuery.of(context).size.width * 0.035).clamp(
                12.0,
                16.0,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select an item",
          labelStyle: TextStyle(
            fontSize: (MediaQuery.of(context).size.width * 0.035).clamp(
              12.0,
              16.0,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
      onChanged: (value) {
        print("Selected: $value");
      },
    ),
  );
}

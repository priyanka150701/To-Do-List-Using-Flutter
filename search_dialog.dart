import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  final Function(String) onSearch;
  final TextEditingController _searchController = TextEditingController();

  SearchDialog({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Search',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _searchController.clear(); // Clear the search text field
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onSearch(_searchController.text); // Perform search
            _searchController.clear(); // Clear the search text field
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Search'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ExplorerSearchWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final TextEditingController searchController;

  const ExplorerSearchWidget(
      {super.key,
      required this.onSearchChanged,
      required this.searchController});

  @override
  State<ExplorerSearchWidget> createState() => _ExplorerSearchWidgetState();
}

class _ExplorerSearchWidgetState extends State<ExplorerSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: widget.searchController,
        decoration: InputDecoration(
          hintText: "Chercher...",
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          widget.onSearchChanged(value);
        },
      ),
    );
  }
}

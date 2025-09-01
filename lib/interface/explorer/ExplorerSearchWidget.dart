import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        controller: widget.searchController,
        decoration: InputDecoration(
          hintText: "Chercher...",
          filled: true,
          fillColor: Colors.black12,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
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

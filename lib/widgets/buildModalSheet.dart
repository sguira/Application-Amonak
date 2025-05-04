import 'package:flutter/material.dart';

Future<void> showCustomModalSheetWidget({
  required BuildContext context,
  required Widget child,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    
    isDismissible: true,
    enableDrag: true,
    elevation: 0, 
    showDragHandle: true,
    shape:const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16.0),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: child,
      );
    },
  );
}
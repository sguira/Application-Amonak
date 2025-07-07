
import 'package:flutter/material.dart';


SizedBox circularProgression(
  {
    Color? color, 
    double? size,
  }
){
  return SizedBox(
    width: size??12,
    height: size??12,
    child: CircularProgressIndicator(
      color: color, 
      strokeWidth: 1.5,
    ),
  );
}
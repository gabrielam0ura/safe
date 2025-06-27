import 'package:flutter/material.dart';

const backgroundColor = Color(0xFF00252D);
const inputBorderColor = Color(0xFF23636C);
const buttonColor = Color(0xFF2E808C);
const buttonTextColor = Colors.white;

final InputDecoration inputDecoration = InputDecoration(
  hintStyle: TextStyle(color: inputBorderColor),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: inputBorderColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: inputBorderColor, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: inputBorderColor),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: inputBorderColor, width: 2),
  ),
  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
  errorStyle: TextStyle(height: 0),
);

const correctUsername = 'gabrielam0ura';
const correctPassword = 'gabriela123';

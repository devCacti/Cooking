import 'package:flutter/material.dart';

Padding appTitle = Padding(
  padding: EdgeInsets.only(top: 10, bottom: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.fastfood_rounded,
        size: 40,
      ),
      SizedBox(
        width: 20,
      ),
      Text(
        'Cooking',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40,
        ),
      ),
      SizedBox(
        width: 20,
      ),
      Icon(
        Icons.local_dining_sharp,
        size: 40,
      ),
    ],
  ),
);

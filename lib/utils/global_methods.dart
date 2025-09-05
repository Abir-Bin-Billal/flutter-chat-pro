  import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

Widget buildDateTime(dynamic groupedByValue) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        formatDate(groupedByValue.timeSent!, [dd, ' ', M, ', ', yy]),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
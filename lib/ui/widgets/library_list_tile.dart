import 'package:flutter/material.dart';

ListTile sectionTile(String title, String thumbnail, void Function() onTap) {
  return ListTile(
    title: Center (
      child: Column(
        children: [
          Image.asset(thumbnail),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 30,
              color: Color.fromARGB(230, 255, 255, 255),
            ),
          ),
        ],
      ),
    ),
    minVerticalPadding: 10,
    onTap: onTap,
  );
}
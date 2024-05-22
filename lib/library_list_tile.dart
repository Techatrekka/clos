import 'package:flutter/material.dart';

ListTile imageTile(String title, String author, String thumbnail) {
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
          Text(
            author,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ),
    minVerticalPadding: 30,
    // shape: BeveledRectangleBorder(
    //   borderRadius: BorderRadius.circular(10),
    // ),
  );
}

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
    minVerticalPadding: 30,
    // shape: BeveledRectangleBorder(
    //   borderRadius: BorderRadius.circular(10),
    // ),
    onTap: onTap,
  );
}

ListTile optionTile(String title, String author, void Function() onTap) {
  return ListTile(
    title: Center (
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 30,
              color: Color.fromARGB(230, 255, 255, 255),
            ),
          ),
          Text(
            author,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ),
    minVerticalPadding: 30,
    onTap: onTap,
  );
}
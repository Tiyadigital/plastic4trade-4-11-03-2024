import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomeBottomnavidation extends StatelessWidget
    implements PreferredSizeWidget {
  String title = '';

  CustomeBottomnavidation(this.title, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return mybottombar(title);
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}

Widget mybottombar(String title) {
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: "Home",
        backgroundColor: Color.fromARGB(255, 231, 230, 228),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: "Home",
        backgroundColor: Color.fromARGB(255, 231, 230, 228),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: "Home",
        backgroundColor: Color.fromARGB(255, 231, 230, 228),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: "Home",
        backgroundColor: Color.fromARGB(255, 231, 230, 228),
      ),
    ],
  );
}

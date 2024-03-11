import 'package:flutter/material.dart';
import '../utill/constant.dart';

GlobalKey bottomNavKey = GlobalKey(debugLabel: 'btm_app_bar');

class BottomMenu extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  BottomMenu({super.key, this.selectedIndex, required this.onClicked});


  @override
  Widget build(BuildContext context) {
    return Theme(data: Theme.of(context).copyWith(
      canvasColor: const Color(0xFFFFFFFF),
      primaryColor: const Color(0xFFFFFFFF),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        iconSize: 25,
        key: bottomNavKey,
        backgroundColor: const Color(0xFFFFFFFF),
        currentIndex: selectedIndex,
        onTap: onClicked,
        selectedItemColor: const Color.fromARGB(255, 0, 91, 148),
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/Home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/sale.png')),
            label: 'Saller',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/Buyer.png')),
            label: 'Buyer',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/news.png')),
            label: 'News',
          ),
          constanst.image_url==null?
          BottomNavigationBarItem(
            icon:ImageIcon(AssetImage('assets/account.png'),size: 25),
            label: 'More',
          ):BottomNavigationBarItem(
            icon: Container(
              width: 30,
              height: 30,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  constanst.image_url.toString(),
                ),
              ),
            ),
            label: 'More',
          ),
        ],
      
        // selectedItemColor: Color.fromARGB(255, 0, 91, 148),
         // unselectedLabelStyle: TextStyle(Colors.amber)
         //unselectedItemColor: Colors.black,
        // backgroundColor: Colors.black,
      
       // unselectedItemColor: Colors.white,
      ),
    );
  }
}
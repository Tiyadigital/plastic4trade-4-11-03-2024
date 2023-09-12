import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Plastic4trade/screen/BuyerPost.dart';
import 'package:Plastic4trade/screen/HomePage.dart';
import 'package:Plastic4trade/screen/SalePost.dart';
import '../utill/constant.dart';

GlobalKey bottomNavKey = GlobalKey(debugLabel: 'btm_app_bar');

class BottomMenu extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  BottomMenu({this.selectedIndex, required this.onClicked});


  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      key: bottomNavKey,
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
      currentIndex: selectedIndex,
      onTap: onClicked,
      // selectedItemColor: Color.fromARGB(255, 0, 91, 148),
       // unselectedLabelStyle: TextStyle(Colors.amber)
       //unselectedItemColor: Colors.black,
      // backgroundColor: Colors.black,
      selectedItemColor: Color.fromARGB(255, 0, 91, 148),

      showUnselectedLabels: true,
      unselectedItemColor: Colors.black,
     // unselectedItemColor: Colors.white,
    );
  }
}
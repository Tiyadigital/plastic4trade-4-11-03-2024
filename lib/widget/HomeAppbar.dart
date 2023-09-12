import 'package:Plastic4trade/widget/AddPost_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:Plastic4trade/screen/Chat.dart';
import 'package:Plastic4trade/screen/Liveprice.dart';
import 'package:Plastic4trade/screen/Notifications.dart';
import 'package:badges/badges.dart' as badges;
import 'package:Plastic4trade/utill/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/AddPost.dart';
import '../screen/Register2.dart';
import '../screen/Videos.dart';
import 'BussinesPro_dialog.dart';
import 'Category_dialog.dart';
import 'Tutorial_Videos_dialog.dart';

class CustomeApp extends StatelessWidget implements PreferredSizeWidget {
  String title = '';

  CustomeApp(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return myAppbar(title, context);
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}

Widget myAppbar(String title, context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (title == 'Home')
          Image.asset('assets/plastic4trade logo final.png',
              height: 50, width: MediaQuery.of(context).size.width / 2.9)
        else if (title == 'Saller')
          Text('Sale Post',
              softWrap: false,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Metropolis',
              )),
        if (title == 'Buyer')
          Text('Buy Post',
              softWrap: false,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Metropolis',
              )),
        if (title == 'News')
          Text('News',
              softWrap: false,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Metropolis',
              )),
        if (title == 'More')
          Text('More',
              softWrap: false,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Metropolis',
              )),
        if (title == 'Exhibition')
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Text('Exhibition',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                  )),
            ],
          ),
        if (title == 'Directory')
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Text('Directory',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                  )),
            ],
          ),
        if (title == 'PremiumMember')
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Text('Premium Member',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                  )),
            ],
          ),
        if (title == 'Favourite')
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Text('Favourite',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                  )),
            ],
          ),
        if (title == 'Videos')
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Text('Videos',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                  )),
            ],
          ),
        if (title == 'Tutorial_Video')
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Text('Tutorial Video',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                  )),
            ],
          ),
        if (title == 'ContactUs')
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Text('Contact Us',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                  )),
            ],
          ),
        if (title == 'Exhibitor')
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Text('Exhibitor',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                  )),
            ],
          )
      ],
    ),

    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != 'Videos')
            GestureDetector(
                onTap: () {
                  showTutorial_Video(context, title);
                },
                child: SizedBox(
                    width: 40,
                    child: Image.asset(
                      'assets/Play.png',
                    ))),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
              onTap: () {
                constanst.redirectpage="live_price";
                if (constanst.appopencount == constanst.appopencount1) {
                  print(constanst.step);
                  if (!constanst.isgrade &&
                      !constanst.istype &&
                      !constanst.iscategory &&
                      !constanst.isprofile &&
                      constanst.step == 11) {
                    print(constanst.step);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LivepriceScreen(),
                        ));
                  } else if (constanst.isprofile) {
                    showInformationDialog(context);
                  } else if (constanst.iscategory) {
                    //Fluttertoast.showToast(msg: 'i m category');
                    categoryDialog(context);
                  } else if (constanst.isgrade) {
                    categoryDialog(context);
                  } else if (constanst.istype) {
                    categoryDialog(context);
                  } else if (constanst.step != 11) {
                    addPostDialog(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LivepriceScreen(),
                        ));
                  }
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LivepriceScreen(),
                      ));
                  /*if (constanst.isprofile) {
                    showInformationDialog(context);
                  } else if (constanst.iscategory) {
                    //Fluttertoast.showToast(msg: 'i m category');
                    categoryDialog(context);
                  } else if (constanst.isgrade) {
                    categoryDialog(context);
                  } else if (constanst.istype) {
                    categoryDialog(context);
                  } else if (constanst.step != 11) {
                    addPostDialog(context);
                  } else if (!constanst.isgrade &&
                      !constanst.istype &&
                      !constanst.iscategory &&
                      !constanst.isprofile &&
                      constanst.step == 11) {
                    print(constanst.step);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LivepriceScreen(),
                        ));
                  }*/
                }
              },
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  'assets/homeprice.png',
                ),
              )),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chat(),
                    ));
              },
              /*onTap: () {
                constanst.redirectpage=="chat";
               // constanst.productId=result.productId.toString();
              //  constanst.post_type=result.postType.toString();
               // constanst.redirectpage="sale_buy";
                print(constanst.appopencount);
                print(constanst.appopencount1);
                print(constanst.isprofile);
                print(constanst.iscategory);
                if(constanst.appopencount==constanst.appopencount1) {
                  print(constanst.step);
                  if (!constanst.isgrade &&
                      !constanst.istype &&
                      !constanst.iscategory &&
                      !constanst.isprofile && constanst.step == 11) {
                    print(constanst.step);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>Chat(),
                        ));
                  } else if (constanst.isprofile) {
                    showInformationDialog(context);
                  } else if (constanst.iscategory) {
                    //Fluttertoast.showToast(msg: 'i m category');
                    categoryDialog(context);
                  } else if (constanst.isgrade) {
                    categoryDialog(context);
                  } else if (constanst.istype) {
                    categoryDialog(context);
                  } else if (constanst.step != 11) {
                    addPostDialog(context);
                  }else{
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>Chat(),
                        ));
                  }
                  */ /* else {
                   showInformationDialog(context);
                 }*/ /*
                }else{
                  if (constanst.isprofile) {
                    showInformationDialog(context);
                  } else if (constanst.iscategory) {
                    //Fluttertoast.showToast(msg: 'i m category');
                    categoryDialog(context);
                  } else if (constanst.isgrade) {
                    categoryDialog(context);
                  } else if (constanst.istype) {
                    categoryDialog(context);
                  } else if (constanst.step != 11) {
                    addPostDialog(context);
                  }else  if (!constanst.isgrade &&
                      !constanst.istype &&
                      !constanst.iscategory &&
                      !constanst.isprofile && constanst.step == 11) {
                    print(constanst.step);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>Chat(),
                        ));
                  }
                }
              },*/
              child: SizedBox(
                width: 40,
                height: 50,
                child: Image.asset(
                  'assets/homemsg.png',
                ),
              )),
          SizedBox(
            width: 10,
          ),
          Align(
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
              badgeAnimation: badges.BadgeAnimation.slide(
                  animationDuration: Duration(milliseconds: 300)),
              badgeContent: Text(constanst.notification_count.toString(),
                  style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => notification()));
                  },
                  child: SizedBox(
                    width: 40,
                    //child: Icon(Icons.notifications_none_rounded,),
                    child: Image.asset(
                      'assets/Notification.png',
                      height: 34,
                    ),
                  )),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      )
    ],

    // actions: [
    //   Align(
    //     child: badges.Badge(
    //       position: badges.BadgePosition.topEnd(top: 3, end: 3),
    //       badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
    //       badgeAnimation: badges.BadgeAnimation.slide(
    //           animationDuration: Duration(milliseconds: 300)),
    //       badgeContent: Text(constanst.cartitem_count,
    //           style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
    //       child: IconButton(
    //           onPressed: () {
    //             Navigator.push(context,
    //                 MaterialPageRoute(builder: (context) => cart_screen()));
    //           },
    //           icon: Icon(Icons.shopping_cart)),
    //     ),
    //   )
    // ],
  );
}

Future<void> showInformationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BussinessPro_dialog();
    },
  );
}

Future<void> categoryDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Category_dialog();
    },
  );
}

Future<void> addPostDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AddPost_dialog();
    },
  );
}

Future<void> showTutorial_Video(BuildContext context, String title) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return Tutorial_Videos_dialog(title);
    },
  );
}

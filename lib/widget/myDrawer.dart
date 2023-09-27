import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Customedraw extends StatelessWidget implements PreferredSizeWidget {
  String name = '';
  String email = '';
  String image_url = '';
  Customedraw(this.name, this.email, this.image_url, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('drewer data');
    print(name);
    print(email);
    print(image_url);
    return myAppbar(name, email, image_url, context);
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}

Widget myAppbar(
    String name, String email, String image_url, BuildContext context) {
  return Drawer(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    child: ListView(
      padding: EdgeInsets.all(0),
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.red),
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            accountName: Text('$name', style: TextStyle(fontSize: 18)),
            accountEmail: Text('$email'),
            currentAccountPictureSize: Size.square(50),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,

              backgroundImage: image_url != ''
                  ? NetworkImage(image_url)
                  : AssetImage("assets/logo_2crop.png") as ImageProvider,
            ), //circleAvatar
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('My Account'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('My Order'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.favorite_border_outlined),
          title: const Text('Wishlist'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.contact_phone),
          title: const Text('contact us'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.star_border_outlined),
          title: const Text('Rate us'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outlined),
          title: const Text('About us'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.policy_outlined),
          title: const Text('Privacy Policy'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.terminal),
          title: const Text('Terms and Conditions'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            Navigator.pop(context);
            logout(context);
          },
        ),
      ],
    ),
  );
}

void logout(BuildContext context) async {
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.clear();
  // Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notificationsetting extends StatefulWidget {
  const Notificationsetting({Key? key}) : super(key: key);

  @override
  State<Notificationsetting> createState() => _NotificationsettingState();
}
class Choice {
   Choice({required this.title, required this.icon});
   String title;
   bool icon;
}

 List<Choice> choices =  <Choice>[
      Choice(title: 'Sell Post', icon: true),
   Choice(title: 'Buy Post', icon: true),
   Choice(title: 'Domestic', icon: true),
   Choice(title: 'International', icon: true),
   Choice(title: 'Category, Type, Grade Match', icon: true),
   Choice(title: 'Followers', icon: true),
   Choice(title: 'Post Interested', icon: true),
   Choice(title: 'Post Comment', icon: true),
   Choice(title: 'Favourite', icon: true),
   Choice(title: 'Business Profile Like', icon: true),
   Choice(title: 'User Follow', icon: true),
   Choice(title: 'User Unfollow', icon: true),
   Choice(title: 'Live Price', icon: true),
   Choice(title: 'Quick News', icon: true),
   Choice(title: 'News', icon: true),
   Choice(title: 'Blog', icon: true),
   Choice(title: 'Video', icon: true),
   Choice(title: 'Banner', icon: true),
   Choice(title: 'Chat', icon: true),

];


class _NotificationsettingState extends State<Notificationsetting> {


  @override
  Widget build(BuildContext context) {
    return initwidget();
  }

  Widget initwidget() {
    return Scaffold(
       // backgroundColor: Color.fromARGB(240, 218, 218, 218),
        backgroundColor: Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          elevation: 0,
          title: Text('Notification Settings',
              softWrap: true,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Metropolis',
              )),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: notificationsetting()


    );
  }

  Widget notificationsetting() {
    return Container(
      margin: EdgeInsets.all(15.0),
        child: FutureBuilder(

      //future: load_subcategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            //List<dynamic> users = snapshot.data as List<dynamic>;
            return ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: choices.length,
                padding: EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                itemBuilder: (context, index) {
                  Choice record = choices[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: Container(
                        height: 65,

                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  12.0))
                          ),
                          //elevation: 2,
                          child: Container(
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.fromLTRB(
                                      10.0, 0, 5.0, 0.0),
                                      child: Image.asset(
                                        'assets/Notification.png',
                                      color: Colors.black54,height: 20,)),
                                  Expanded(

                                      child: Text(
                                        '${record.title}', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(fontSize: 15,fontWeight: FontWeight.w500),)
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 10),
                                      child:Switch(
                                        value: record.icon,
                                        onChanged: (value) {
                                          setState(() {
                                            record.icon=value;
                                            print(record.icon);
                                          });
                                        },
                                        activeTrackColor: Color.fromARGB(255, 0, 91, 148),
                                        activeColor: Colors.grey,
                                      ),
                                  ),
                                ]),
                          ),
                        )),
                  );
                });

            return CircularProgressIndicator();
          }
        }));
  }

}
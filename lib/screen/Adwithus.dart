// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

import 'Videos.dart';

class Adwithus extends StatefulWidget {
  const Adwithus({Key? key}) : super(key: key);

  @override
  State<Adwithus> createState() => _AdwithusState();
}

class Choice {
  const Choice({required this.title, required this.type,required this.price,required this.size,required this.icon});
  final String title;
  final String type;
  final String price;
  final String size;
  final String icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Homepage Banner Advertisement', type: 'Image or Video',price: '₹5000/- Per Month',size: '350*12',icon: 'assets/homegrid.png'),
  Choice(title: 'Pop-up Banner Advertisement',type: 'Image',price: '₹500/- Per Month',size: '350*12', icon: 'assets/homegrid.png'),
  Choice(title: 'Paid Post', type: 'Image',price: '2500',size: '350*12',icon: 'assets/homegrid.png'),
  Choice(title: 'Notification Ads', type: 'Image',price: '₹5000/- Per Month',size: '350*12',icon: 'assets/homegrid.png'),
  Choice(title: 'Email, WhatsApp, SMS Marketing to Users',type: 'Video', price: '2500',size: '350*12',icon: 'assets/homegrid.png'),
];

class _AdwithusState extends State<Adwithus> {
  @override
  Widget build(BuildContext context) {
    return initwidget();
  }

  Widget initwidget() {
    return Scaffold(
        backgroundColor: const Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          elevation: 0,
          title: const Text('Advertise With Us',
              softWrap: false,
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
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const YoutubeViewer('i9t8rSVLUxg')));
                },
                child: SizedBox(
                    width: 40,
                    child: Image.asset(
                      'assets/Play.png',
                    ))),
          ],
        ),
        body: category());
  }

  Widget category() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
        child: FutureBuilder(

            //future: load_subcategory(),
            builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            //List<dynamic> users = snapshot.data as List<dynamic>;
            return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: choices.length,
                itemBuilder: (context, index) {
                  Choice record = choices[index];

                  return GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child:

                         Container(
                           margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.white),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,

                                  children: [
                                    Stack(fit: StackFit.passthrough, children: <
                                        Widget>[
                                      Container(
                                        height: 218,
                                        width: 101,
                                        margin: const EdgeInsets.all(15.0),
                                        child: Image(
                                          errorBuilder:
                                              (context, object, trace) {
                                            return Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromARGB(
                                                    255, 223, 220, 220),
                                              ),
                                            );
                                          },
                                          image: AssetImage(record.icon

                                              ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ]),
                                    const SizedBox(width: 15,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(record.title,
                                                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                                      .copyWith(
                                                          fontSize: 15),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,),
                                          const SizedBox(height: 10,),
                                          const SizedBox(
                                              height: 15,
                                              child: Text('Type',
                                                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                                                  maxLines: 2,
                                                  softWrap: false)),
                                          Text(record.type,
                                            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(
                                                fontSize: 15),),
                                          const SizedBox(height: 5,),
                                          const Text(
                                            'Size:',
                                            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                                          ),
                                          Text(record.size,
                                            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(
                                                fontSize: 15),),
                                          const SizedBox(height: 5,),
                                          const Text(
                                            'Price:',
                                            style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                                          ),
                                          Text(record.price,
                                            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(
                                                fontSize: 15),),

                                        ],
                                      ),
                                    ),
                                  ]),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                margin: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: const Color.fromARGB(255, 0, 91, 148)),
                                child: TextButton(
                                  onPressed: () {

                                  },
                                  child: const Text('Contact us',

                                      style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w800,color: Colors.white,fontFamily: 'assets/fonst/Metropolis-Black.otf')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                });

          }
        }));
  }
}

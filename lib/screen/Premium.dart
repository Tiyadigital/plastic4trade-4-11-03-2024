// ignore_for_file: non_constant_identifier_names, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'Videos.dart';

class Premiun extends StatefulWidget {
  const Premiun({Key? key}) : super(key: key);

  @override
  State<Premiun> createState() => _PremiunState();
}
class Choice {
  const Choice({required this.title, required this.icon});
  final String title;
  final String icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
];
class _PremiunState extends State<Premiun> with SingleTickerProviderStateMixin  {

   var init_page=0;
  late TabController _tabController;
   PageController? _pageController;
  //late TabController _tabController1;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this,initialIndex: init_page);
    _pageController =PageController(initialPage: init_page,viewportFraction: 0.8);
    /*init_page=0;*/
   // _tabController1 = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return DefaultTabController(length: 5,
        initialIndex: init_page,
        child: Scaffold(
          backgroundColor: const Color(0xFFDADADA),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            elevation: 0,
            title: const Text('Premium',
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
            bottom:  TabBar(
              controller: _tabController,

              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              onTap: (value) {
                setState(() {
                   init_page=value;
                   _pageController?.jumpToPage(init_page);
                });
              },
              tabs: const [
                Tab(child: Text('Free',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600))),
                Tab(child: Text('Basic',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600))),
                Tab(child: Text('Standard',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600))),
                Tab(child: Text('Premium',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600))),
                Tab(child: Text('Gold',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600))),

              ],
            ),
          ),
          body: TabBarView(
            children: [
              demo(init_page),
              demo(init_page),
              demo(init_page),
              demo(init_page),
              demo(init_page),



            ],
          ),
        ));
  }
   Widget tab() {
     return SingleChildScrollView(
       child: Container(
         // color: Colors.white,
         margin: const EdgeInsets.all(15),
         width: 150,
         height: 500,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15),
           color:Colors.white,
         ),
         child: Container(
             margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),

             child: Column(
                 children: [
                   Stack(
                     children: [
                       Image.asset('assets/Premium1.png'),


                       const Positioned(
                           top: 55,
                           left: 155,
                           child: Text('Free')),
                       const Positioned(
                           bottom: 25,
                           left: 25,
                           child: Text('₹0/Month')),
                       const Positioned(
                           bottom: 25,
                           right: 25,
                           child: Text('0/M                  ')
                       )],),
                   FutureBuilder(
                     //future: load_category(),
                       builder: (context, snapshot) {
                         if (snapshot.hasError) {
                           return Text('Error: ${snapshot.error}');
                         } else {
                           //List<dynamic> users = snapshot.data as List<dynamic>;
                           return ListView.builder(
                            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                               // crossAxisCount: 2,
                               // mainAxisSpacing: 5,
                               // crossAxisSpacing: 5,
                               // childAspectRatio: .90,

                             /*  childAspectRatio:MediaQuery.of(context).size.height/330,
                               mainAxisSpacing: 1.0,
                               crossAxisCount: 1,
                             ),*/
                             physics: const AlwaysScrollableScrollPhysics(),
                             itemCount: 1,
                             shrinkWrap: true,
                             itemBuilder: (context, index) {
                               //Choice record = choices[index];
                               return GestureDetector(
                                   onTap: (() {

                                   }),
                                   child: Card(

                                     elevation: 2,

                                     child: Container(
                                       margin: const EdgeInsets.all(8.0),
                                       child: Column(children: [
                                         Row(
                                           children: [
                                             Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                             const Text('Free Post')
                                           ],
                                         ),
                                         Row(
                                           children: [
                                             Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                             const Text('Domestic Live Price')
                                           ],
                                         ),
                                         Row(
                                           children: [
                                             Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                             const Text('International Live Price')
                                           ],
                                         ),
                                         Row(
                                           children: [
                                             Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                             const Text('International News')
                                           ],
                                         ),
                                         Row(
                                           children: const [
                                             Icon(Icons.cancel,color: Colors.red ,),
                                             Text('Chat Functionality')
                                           ],
                                         )
                                         //SizedBox(height: 5.0,)

                                       ]),
                                     ),
                                   ));
                             },
                           );
                         }

                       })
                 ])),
       ),
     );
   }

   Widget demo( initPage){
     return SingleChildScrollView(
       child: _buildCarousel(context),
     );}
   
   Widget _buildCarousel(BuildContext context) {
     return Column(
       mainAxisSize: MainAxisSize.min,
       //crossAxisAlignment: CrossAxisAlignment.center,
       children: <Widget>[
         //Text('Carousel $carouselIndex'),
         SizedBox(
           // you may want to use an aspect ratio here for tablet support
           height: MediaQuery.of(context).size.height,
           child: PageView.builder(
             // store this controller in a State to save the carousel scroll position
             controller: _pageController,
             itemCount: 5,
             pageSnapping: false,
             //padEnds: false,
             itemBuilder: (BuildContext context, int itemIndex) {
               return _buildCarouselItem(context, itemIndex);
             },
             onPageChanged: (value) {
               setState(() {
                 init_page=value;
                 //_tabController.addListener(() {

                 _tabController.animateTo(init_page);
                 //});
               });

             },

           ),
         )
       ],
     );
   }

   Widget _buildCarouselItem(BuildContext context, int itemIndex) {
     return Container(

         padding: const EdgeInsets.symmetric(horizontal: 4.0),
         //padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
         margin: const EdgeInsets.fromLTRB(0,10.0,0.0,150.0),

         child: Container(
           decoration: const BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.all(Radius.circular(10.0)),
           ),
           padding: const EdgeInsets.all(10),
           // child: Container(
           //   margin: EdgeInsets.fromLTRB(5, 10, 5, 10),

           child: Column(
               children: [
                 Stack(
                   children: [
                     Image.asset('assets/Premium1.png'),


                     Positioned(
                         top: 28,
                         left: 98,
                         child: Text('Free',style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf').copyWith(fontSize: 41,color: Colors.white))),
                     Positioned(
                         bottom: 18,
                         left: 25,
                         child: Text('₹0/Month',style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf').copyWith(fontSize: 15,color: Colors.white))),
                     Positioned(
                         bottom: 18,
                         right: 25,
                         child: Text('0/Month',style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf').copyWith(fontSize: 15,color: Colors.white)))

                   ],),
                 FutureBuilder(
                   //future: load_category(),
                     builder: (context, snapshot) {
                       if (snapshot.hasError) {
                         return Text('Error: ${snapshot.error}');
                       } else {
                         //List<dynamic> users = snapshot.data as List<dynamic>;
                         return ListView.builder(
                          /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                             // crossAxisCount: 2,
                             // mainAxisSpacing: 5,
                             // crossAxisSpacing: 5,
                             // childAspectRatio: .90,

                             childAspectRatio:MediaQuery.of(context).size.height/1400,
                             mainAxisSpacing: 1.0,
                             crossAxisCount: 1,
                           ),*/
                           physics: const AlwaysScrollableScrollPhysics(),
                           itemCount: 1,
                           shrinkWrap: true,
                           itemBuilder: (context, index) {
                             //Choice record = choices[index];
                             return GestureDetector(
                               onTap: (() {

                               }),


                               child: Container(
                                 margin: const EdgeInsets.all(8.0),
                                 child: Column(children: [
                                   Row(
                                     children: [
                                       Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                       const SizedBox(width: 3,),
                                       const Text('Free Post',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),)
                                     ],
                                   ),
                                   const SizedBox(height: 6,),
                                   Row(
                                     children: [
                                       Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                       const SizedBox(width: 3,),
                                       const Text('Domestic Live Price',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),)
                                     ],
                                   ),const SizedBox(height: 6,),
                                   Row(
                                     children: [
                                       Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                       const SizedBox(width: 3,),
                                       const Text('International Live Price',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),)
                                     ],
                                   ),const SizedBox(height: 6,),
                                   Row(
                                     children: [
                                       Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                       const SizedBox(width: 3,),
                                       const Text('International News',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),)
                                     ],
                                   ),const SizedBox(height: 6,),
                                   Row(
                                     mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                     children: [
                                       Row(
                                         children: const [
                                           Icon(Icons.cancel,color: Colors.red ,),
                                           SizedBox(width: 3,),
                                           Text('Chat Functionality',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),),
                                         ],
                                       ),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: const [
                                           Icon(Icons.info_outline,color: Colors.grey ,),
                                         ],
                                       )
                                     ],
                                   ),const SizedBox(height: 6,),

                                   Row(
                                     mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                     children: [
                                       Row(
                                         children: const [
                                           Icon(Icons.cancel,color: Colors.red ,),
                                           SizedBox(width: 3,),
                                           Text('Business Profile View',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),),
                                         ],
                                       ),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: const [
                                           Icon(Icons.info_outline,color: Colors.grey ,),
                                         ],
                                       )
                                     ],
                                   ),const SizedBox(height: 6,),

                                   Row(
                                     mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                     children: [
                                       Row(
                                         children: const [
                                           Icon(Icons.cancel,color: Colors.red ,),
                                           SizedBox(width: 3,),
                                           Text('Chat Functionality',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),),
                                         ],
                                       ),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: const [
                                           Icon(Icons.info_outline,color: Colors.grey ,),
                                         ],
                                       )
                                     ],
                                   ),const SizedBox(height: 6,),

                                   Row(
                                     mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                     children: [
                                       Row(
                                         children: const [
                                           Icon(Icons.cancel,color: Colors.red ,),
                                           SizedBox(width: 3,),
                                           Text('Reversible (Open Contact)',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),),
                                         ],
                                       ),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: const [
                                           Icon(Icons.info_outline,color: Colors.grey ,),
                                         ],
                                       )
                                     ],
                                   ),const SizedBox(height: 6,),
                                   Row(
                                     mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                     children: [
                                       Row(
                                         children: const [
                                           Icon(Icons.cancel,color: Colors.red ,),
                                           SizedBox(width: 3,),
                                           Text('Notification Ads',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),),
                                         ],
                                       ),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: const [
                                           Icon(Icons.info_outline,color: Colors.grey ,),
                                         ],
                                       )
                                     ],
                                   ),const SizedBox(height: 6,),
                                   Row(
                                     mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                     children: [
                                       Row(
                                         children: const [
                                           Icon(Icons.cancel,color: Colors.red ,),
                                           SizedBox(width: 3,),
                                           Text('Paid Post',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),),
                                         ],
                                       ),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: const [
                                           Icon(Icons.info_outline,color: Colors.grey ,),
                                         ],
                                       )
                                     ],
                                   ),const SizedBox(height: 6,),
                                   Row(
                                     mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                     children: [
                                       Row(
                                         children: const [
                                           Icon(Icons.cancel,color: Colors.red ,),
                                           SizedBox(width: 3,),
                                           Text('Business Directory',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),),
                                         ],
                                       ),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: const [
                                           Icon(Icons.info_outline,color: Colors.grey ,),
                                         ],
                                       )
                                     ],
                                   ),const SizedBox(height: 6,),
                                   Row(
                                     mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                     children: [
                                       Row(
                                         children: const [
                                           Icon(Icons.cancel,color: Colors.red ,),
                                           SizedBox(width: 3,),
                                           Text('Time Duration: Monthly',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),),
                                         ],
                                       ),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: const [
                                           Icon(Icons.info_outline,color: Colors.grey ,),
                                         ],
                                       )
                                     ],
                                   ),
                                   SizedBox(height: MediaQuery.of(context).size.height/20,),
                                   Container(
                                     width: MediaQuery.of(context).size.width * 0.9,
                                     margin: const EdgeInsets.only(bottom: 10),
                                     decoration: BoxDecoration(
                                         border: Border.all(width: 1),
                                         borderRadius: BorderRadius.circular(50.0),
                                         color: const Color.fromARGB(255, 0, 91, 148)),
                                     child: TextButton(
                                       onPressed: () {

                                       },
                                       child: const Text('Free',

                                           style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w800,color: Colors.white,fontFamily: 'assets/fonst/Metropolis-Black.otf')),
                                     ),
                                   ),
                                   //SizedBox(height: 5.0,)

                                 ]),
                               ),
                             );
                           },
                         );
                       }

                     })

               ]),
         ));
   }

}

class YourWidget extends StatefulWidget {
  var init_pages;

   YourWidget({Key? key ,@required this.init_pages}) : super(key: key);

  @override
  State<YourWidget> createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> with SingleTickerProviderStateMixin {

   late TabController _tabController;
  List<String> items = [
    'Manufacturer',
    'Traders',
    'Importer',
    'Exporter',
    'Wholesaler',
    'Distributor',
    'Retailer',
    'Machinery',
    'Job Work',
  ];
  List<IconData> itemsCheck = [
    Icons.circle_outlined,
    Icons.circle_outlined,
    Icons.circle_outlined,
    Icons.circle_outlined,
    Icons.circle_outlined,
    Icons.circle_outlined,
    Icons.circle_outlined,
    Icons.circle_outlined,
    Icons.circle_outlined,
    Icons.circle_outlined
  ];
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _tabController = TabController(length: 5, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 5,
    initialIndex: widget.init_pages,
    child: Scaffold(
        backgroundColor: const Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          title: Text(widget.init_pages.toString(),
              softWrap: false,
              style: const TextStyle(
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
          bottom:  TabBar(
             controller: _tabController,
            isScrollable: true,

            tabs: [
              Tab(text: widget.init_pages.toString()),
              const Tab(text: 'Basic'),
              const Tab(text: 'Standard'),
              const Tab(text: 'Premium'),
              const Tab(text: 'Gold'),

            ],
          ),
        ),
        body: TabBarView(
          children: [
            demo(widget.init_pages),
            demo(widget.init_pages),
            demo(widget.init_pages),
            demo(widget.init_pages),
            demo(widget.init_pages),



          ],
        ),
      ));
  }

  Widget tab() {
    return SingleChildScrollView(
      child: Container(
        // color: Colors.white,
        margin: const EdgeInsets.all(15),
        width: 150,
        height: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Container(
            margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),

            child: Column(
                children: [
                  Stack(
                    children: [
                      Image.asset('assets/Premium1.png'),


                      const Positioned(
                          top: 55,
                          left: 155,
                          child: Text('Free')),
                      const Positioned(
                          bottom: 25,
                          left: 25,
                          child: Text('₹0/Month')),
                      const Positioned(
                          bottom: 25,
                          right: 25,
                          child: Text('0/Month'))

                    ],),
                  FutureBuilder(
                    //future: load_category(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          //List<dynamic> users = snapshot.data as List<dynamic>;
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              // crossAxisCount: 2,
                              // mainAxisSpacing: 5,
                              // crossAxisSpacing: 5,
                              // childAspectRatio: .90,

                              childAspectRatio:MediaQuery.of(context).size.height/330,
                              mainAxisSpacing: 1.0,
                              crossAxisCount: 1,
                            ),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 1,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              //Choice record = choices[index];
                              return GestureDetector(
                                  onTap: (() {

                                  }),
                                  child: Card(

                                    elevation: 2,

                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                            const Text('Free Post')
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                            const Text('Domestic Live Price')
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                            const Text('International Live Price')
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                            const Text('International News')
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Icon(Icons.cancel,color: Colors.red ,),
                                            Text('Chat Functionality')
                                          ],
                                        )
                                        //SizedBox(height: 5.0,)

                                      ]),
                                    ),
                                  ));
                            },
                          );
                        }

                      })
                ])),
      ),
    );
  }
  Widget demo( initPage){
    return SingleChildScrollView(
      child: _buildCarousel(context),
    );




  }
  Widget _buildCarousel(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        //Text('Carousel $carouselIndex'),
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: MediaQuery.of(context).size.height,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.8,initialPage: widget.init_pages),
            itemCount: 5,
            pageSnapping: false,
            //padEnds: false,
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem(context, itemIndex);
            },
            onPageChanged: (value) {
              setState(() {
              widget.init_pages=value;
              //_tabController.addListener(() {

            _tabController.animateTo(widget.init_pages);
              //});
               });

            },

          ),
        )
      ],
    );
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex) {
    return Container(

        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        //padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
        margin: const EdgeInsets.fromLTRB(0,10.0,0.0,10.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          // child: Container(
          //   margin: EdgeInsets.fromLTRB(5, 10, 5, 10),

          child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset('assets/Premium1.png'),


                    const Positioned(
                        top: 55,
                        left: 155,
                        child: Text('Free')),
                    const Positioned(
                        bottom: 25,
                        left: 25,
                        child: Text('₹0/Month')),
                    const Positioned(
                        bottom: 25,
                        right: 25,
                        child: Text('0/Month'))

                  ],),
                FutureBuilder(
                  //future: load_category(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        //List<dynamic> users = snapshot.data as List<dynamic>;
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            // crossAxisCount: 2,
                            // mainAxisSpacing: 5,
                            // crossAxisSpacing: 5,
                            // childAspectRatio: .90,

                            childAspectRatio:MediaQuery.of(context).size.height/530,
                            mainAxisSpacing: 1.0,
                            crossAxisCount: 1,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: 1,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            //Choice record = choices[index];
                            return GestureDetector(
                              onTap: (() {

                              }),


                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                       Text(widget.init_pages.toString())
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                      const Text('Domestic Live Price')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                      const Text('International Live Price')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle,color: Colors.green.shade600 ,),
                                      const Text('International News')
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      Icon(Icons.cancel,color: Colors.red ,),
                                      Text('Chat Functionality')
                                    ],
                                  )
                                  //SizedBox(height: 5.0,)

                                ]),
                              ),
                            );
                          },
                        );
                      }

                    })

              ]),
        ));
  }
}



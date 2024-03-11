// ignore_for_file: non_constant_identifier_names, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:info_popup/info_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import '../model/premium_plan_model.dart';
import 'Videos.dart';
import 'dart:io';


class Premiun extends StatefulWidget {
  const Premiun({Key? key}) : super(key: key);

  @override
  State<Premiun> createState() => _PremiunState();
}

class _PremiunState extends State<Premiun> with TickerProviderStateMixin {
  var init_page = 0;
  late TabController _tabController;
  late PageController _pageController;
  bool? load;
  ShowPremiumPlan showPremiumPlan = ShowPremiumPlan();
  List<Plan> showPremiumPlanList = <Plan>[];

  @override
  void initState() {
    _tabController = TabController(length: showPremiumPlanList.length, vsync: this, initialIndex: init_page);
    _pageController = PageController(initialPage: init_page, viewportFraction: 0.8);
    super.initState();
    checknetowork();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'Internet Connection not available');
    } else {
      fetch_premium_plan();
    }
  }

  Future fetch_premium_plan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getPremiumPlan(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );
    if (res['status'] == 1) {
      if (res['plan'] != null) {
        showPremiumPlan = ShowPremiumPlan.fromJson(res);
        showPremiumPlanList = showPremiumPlan.plan ?? [];
        _tabController.dispose();
        _tabController = TabController(length: showPremiumPlanList.length, vsync: this, initialIndex: init_page);
        load = true;
      } else {
        load = true;
      }
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
    }
    setState(() {});
    return load;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: showPremiumPlanList.length,
        initialIndex: init_page,
        child: Scaffold(
          backgroundColor: const Color(0xFFDADADA),
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width , 100),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              title: const Text('Premium',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.w600,
                    height: 0.05,
                    letterSpacing: -0.24,
                  )),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.black,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YoutubeViewer('i9t8rSVLUxg'),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 13),
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: Image.asset(
                        'assets/Play.png',
                      ),
                    ),
                  ),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                onTap: (value) {
                  setState(() {
                    init_page = value;
                    _pageController.jumpToPage(init_page);
                  });
                },
                tabs: showPremiumPlanList.map((e) => _buildCommanTab(title: e.name.toString())).toList(),
              ),
            ),
          ),
          body: TabBarView(
            children: showPremiumPlanList.map((e) => demo(init_page)).toList(),
            //[demo(init_page),],
          ),
        ));
  }

  Widget _buildCommanTab({required String title}){
    return  Tab(
        child: Text(title,
          style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.w600,
          height: 0.09,)));
  }

  Widget demo(initPage) {
    return PageView.builder(
      controller: _pageController,
      itemCount: showPremiumPlanList.length,
      pageSnapping: false,
      itemBuilder: (BuildContext context, int itemIndex) {
        return
          load == true ? _buildCarouselItem(context, itemIndex) : Center(
        child: Platform.isAndroid
        ? const CircularProgressIndicator(
        value: null,
        strokeWidth: 2.0,
        color: Color.fromARGB(255, 0, 91, 148),
        )
            : Platform.isIOS
        ? const CupertinoActivityIndicator(
        color: Color.fromARGB(255, 0, 91, 148),
        radius: 20,
        animating: true,
        )
            : Container());
      },
      onPageChanged: (value) {
        setState(() {
           init_page = value;
          _tabController.animateTo(init_page);
        });
      },
    );
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex) {
    return Container(
      margin: const EdgeInsets.only(top: 17,bottom: 50,left: 8,right: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3FA6A6A6),
            blurRadius: 16.32,
            offset: Offset(0, 3.26),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Stack(
              children: [
                (showPremiumPlanList[itemIndex].name!.toLowerCase() == "free") ?  ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Image.asset('assets/Premium1.png',fit: BoxFit.cover,height: 131,width: MediaQuery.of(context).size.width,)) : ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Image.asset('assets/Premium2.png',fit: BoxFit.cover,height: 131,width: MediaQuery.of(context).size.width,)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),
                    Align(
                     alignment: Alignment.center,
                        child: Text(showPremiumPlanList[itemIndex].name ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 41,
                            fontFamily: 'assets/fonst/Metropolis-Black.otf',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        )),
                  ],
                ),
                Positioned(
                    bottom: 10,
                    left: 15,
                    child: Text(
                        '₹${showPremiumPlanList[itemIndex].priceInr}/${showPremiumPlanList[itemIndex].timeDurationInText ?? "Month"}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'assets/fonst/Metropolis-Black.otf',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                    )),
                Positioned(
                  bottom: 10,
                  right: 15,
                  child: Text(
                    '\$${showPremiumPlanList[itemIndex].priceDoller}/${showPremiumPlanList[itemIndex].timeDurationInText ??"Month"}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: showPremiumPlanList[itemIndex].services!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              //Choice record = choices[index];
              return _buildShowPlanList(services: showPremiumPlanList[itemIndex].services![index]);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.9, 46),
                backgroundColor: const Color(0xFF292D32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // button's shape
                ),
              ),
              onPressed: () {},
              child:  Text(showPremiumPlanList[itemIndex].name!.toLowerCase() == "free" ? "Free" : "Buy Now",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      height: 0,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowPlanList({required Services services}){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children:  [
                (services.value!.toUpperCase() == "NO") ?
                const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 20,
                ) : Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 20,
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  '${services.title}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.24,
                      fontFamily:
                      'assets/fonst/Metropolis-SemiBold.otf'),
                ),
              ],
            ),
           // (services.description != null && services.description != "" && services.description != "null" && services.description!.isNotEmpty) ?
            (services.value!.toUpperCase() == "NO")?
            InfoPopupWidget(
            contentMaxWidth: MediaQuery.of(context).size.width/ 2,
            contentTitle: 'Business directory is very useful feature for the buyers and sellers both they can find any kind of plastic suppliers from this feature. it will also help them to grow business in new areas by contacting other buyers',
            arrowTheme: InfoPopupArrowTheme(
            color: Colors.black.withOpacity(0.6000000238418579),
            arrowDirection: ArrowDirection.down,
            ),
            contentTheme: InfoPopupContentTheme(
            infoContainerBackgroundColor: Colors.black.withOpacity(0.6000000238418579),
            infoTextStyle: const TextStyle(color: Colors.white,
            fontSize: 11,
            fontFamily: 'assets/fonst/Metropolis-Black.otf',
            fontWeight: FontWeight.w600,
            ),
            contentPadding: const EdgeInsets.all(10),
            contentBorderRadius: const BorderRadius.all(Radius.circular(10)),
            infoTextAlign: TextAlign.justify,
            ),
            dismissTriggerBehavior: PopupDismissTriggerBehavior.anyWhere,
            areaBackgroundColor: Colors.transparent,
            indicatorOffset: Offset.zero,
            contentOffset: Offset.zero,
            onControllerCreated: (controller) {
            print('Info Popup Controller Created');
            },
            onAreaPressed: (InfoPopupController controller) {
            print('Area Pressed');
            },
            infoPopupDismissed: () {
            print('Info Popup Dismissed');
            },
            onLayoutMounted: (Size size) {
            print('Info Popup Layout Mounted');
            },
            child: const Icon(
            Icons.info_outline,
            color: Colors.black,
            size: 20,
            ),
            ) : const SizedBox()
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

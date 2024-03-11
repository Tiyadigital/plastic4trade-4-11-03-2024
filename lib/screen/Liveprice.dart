// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import 'package:Plastic4trade/model/GetPriceList.dart' as price;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../api/api_interface.dart';
import '../model/DataPoint.dart';
import '../model/get_graph.dart';
import '../utill/constant.dart';
import '../widget/live_priceFilterScreen.dart';
import 'Liveprice_detail.dart';
import 'Videos.dart';

class LivepriceScreen extends StatefulWidget {
  const LivepriceScreen({Key? key}) : super(key: key);

  @override
  State<LivepriceScreen> createState() => _LivepriceScreenState();
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

class _LivepriceScreenState extends State<LivepriceScreen> {
  PackageInfo? packageInfo;
  String? packageName;
  bool isgraph = false;
  final scrollercontroller = ScrollController();
  List<price.Result> price_data = [];
  List<bool> show_graph_data = [];
  bool loadmore = false;
  bool isload = false;
  int offset = 0;
  int count = 0;
  List<DataPoint> data1 = [];
  List<DataPoint> data2 = [];
  List<DataPoint> data3 = [];
  String type_post = "";
  String category_id = '',
      grade_id = '',
      company_id = '',
      state = '',
      country = '';
  int? selectedItemIndex;
  List<RadioModel> sampleData1 = <RadioModel>[];
  final TextEditingController _search = TextEditingController();
  GlobalKey previewContainer = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollercontroller.addListener(_scrollercontroller);
    sampleData1.add(RadioModel(true, 'Month'));
    sampleData1.add(RadioModel(false, 'Year'));
    sampleData1.add(RadioModel(false, 'All'));
    clear();
    checknetowork();
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo!.packageName;
  }

  Future<void> _captureSocialPng() {
    List<String> imagePaths = [];
    final RenderBox box = context.findRenderObject() as RenderBox;
    return Future.delayed(const Duration(milliseconds: 20), () async {
      if(previewContainer.currentContext != null){
      RenderRepaintBoundary? boundary = previewContainer.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = File('$directory/screenshot.png');
      imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {
        await Share.shareFiles(imagePaths,
            subject: 'Share',
            text: "Live Price\t\n\nHey check out my app at: https://play.google.com/store/apps/details?id=${packageName!}",
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }).catchError((onError) {
        print(onError);
      });
    }else{
        print("context:- ${previewContainer.currentContext}");
      }});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          title: const Text('Live Price',
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Videos()));
                },
                child: SizedBox(
                    width: 40,
                    child: Image.asset(
                      'assets/Play.png',
                    ))),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
                onTap: _captureSocialPng,
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      'assets/share1.png',
                    ))),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: RefreshIndicator(
          displacement: 50,
          color: const Color(0xFF005C94),
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: ()async{},
          child: Column(
            children: [
              SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(left: 10.0),
                        width: MediaQuery.of(context).size.width / 1.35,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(47),
                          ),
                          shadows: const [
                          BoxShadow(
                          color: Color(0x3FA6A6A6),
                          blurRadius: 16.32,
                          offset: Offset(0, 3.26),
                          spreadRadius: 0,
                        )]),
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          controller: _search,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIconConstraints:
                                  BoxConstraints(minWidth: 24),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 10,right: 10),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black45,
                                  size: 20,
                                ),
                              ),
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf')),
                          onSubmitted: (value) {
                            price_data.clear();
                            count = 0;
                            offset = 0;
                            _onLoading();
                            get_HomePost();
                            setState(() {});
                          },
                          onChanged: (value) {
                            if (value.isEmpty) {
                              _search.clear();
                              count = 0;
                              offset = 0;
                              price_data.clear();
                              _onLoading();
                              get_HomePost();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      isgraph
                          ? GestureDetector(
                              onTap: () {
                                //ViewItem(context);
                                // showAlertDialog(context);
                                // setState(() {
                                //   isgraph = false;
                                // });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                padding: const EdgeInsets.all(8.0),
                                // padding: EdgeInsets.only(right: 5),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white),
                                child: Image.asset(
                                  'assets/list_data.png',
                                  width: 20,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                // setState(() {
                                //   isgraph = true;
                                // });

                                //ViewItem(context);
                                // showAlertDialog(context);
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                padding: const EdgeInsets.all(8.0),
                                // padding: EdgeInsets.only(right: 5),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white),
                                child: Image.asset(
                                  'assets/diagram.png',
                                  width: 20,
                                ),
                              ),
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            ViewItem(context);
                          },
                          child: Container(
                                height: 40,
                                width: 40,
                              // padding: EdgeInsets.only(right: 5),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,),
                              child: const Icon(
                                Icons.filter_alt,
                                color: Colors.black,
                              ),),
                      ),
                    ],
                  )),
              Expanded(
                child: RepaintBoundary(
                  key: previewContainer,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Category',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Metropolis',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.24,
                                )),
                            Text('Code',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Metropolis',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.24,
                                )),
                            Text('Grade',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Metropolis',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.24,
                                )),
                            Text('Price',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Metropolis',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.24,
                                )),
                            Text('+/-',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Metropolis',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.24,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      pricelist()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<List<LastMonthRecord>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://www.plastic4trade.com/api/getdatabytimeduration?code_id=34'));
    List<LastMonthRecord> lastMonthRecords = [];
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      get_graph graph = get_graph.fromJson(res);
      if (graph.lastMonthRecord != null) {
        lastMonthRecords = graph.lastMonthRecord!;
        // Use the lastMonthRecords list as needed
        // ...
      }
      return lastMonthRecords;
      // return graph.lastMonthRecord!.map((data) => DataPoint(data.priceDate.toString(), data.price.toString())).toList();
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  // List<charts.Series<DataPoint, DateTime>> createSeries(List<DataPoint> records) {
  //   return [
  //     charts.Series<DataPoint, DateTime>(
  //       id: 'Price',
  //       colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
  //       domainFn: (DataPoint record, _) => DateTime.parse(record.price_date),
  //       measureFn: (DataPoint record, _) => double.parse(record.price),
  //       data: records,
  //     ),
  //   ];
  // }

  ViewItem(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          // <-- SEE HERE
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        )),
        builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize:
                0.85, // Initial height as a fraction of screen height
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return const live_priceFilterScreen();
                },
              );
            })).then(
      (value) {
        category_id = constanst.select_categotyId.join(",");
        company_id = constanst.select_typeId.join(",");
        country = constanst.select_country.join(",");
        state = constanst.select_state.join(",");

        price_data.clear();
        _onLoading();

        get_HomePost();
        constanst.select_categotyId.clear();
        constanst.select_typeId.clear();
        constanst.select_gradeId.clear();
        constanst.selectbusstype_id.clear();
        constanst.select_categotyType.clear();
        constanst.select_state.clear();
        constanst.select_country.clear();
        constanst.date = "";

        setState(() {});
      },
    );
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      getPackage();
      get_HomePost();

      // get_data();
    }
  }

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      loadmore = false;

      count++;
      if (count == 1) {
        offset = offset + 21;
      } else {
        offset = offset + 20;
      }
      _onLoading();
      get_HomePost();
    } /*else{
      print('hello');
    }*/
  }

  Widget pricelist() {
    return isload == true
        ? Expanded(
            child: price_data.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.only(left: 7,right: 7,bottom: 10),
                  shrinkWrap: false,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: price_data.length,
                  controller: scrollercontroller,
                  itemBuilder: (context, index) {
                    // Choice record = choices[index];
                    price.Result result = price_data[index];
                    return Column(
                      children: [
                        Container(
                          decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3FA6A6A6),
                              blurRadius: 16.32,
                              offset: Offset(0, 3.26),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                          padding: const EdgeInsets.symmetric(horizontal: 8,),
                          child: GestureDetector(
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: result.codeId.toString());

                              Fluttertoast.showToast(
                                  msg: show_graph_data[index]
                                      .toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Liveprice_detail(
                                            category: result
                                                .category
                                                .toString(),
                                            changed: result.changed
                                                .toString(),
                                            codeName: result
                                                .codeName
                                                .toString(),
                                            price: result.price
                                                .toString(),
                                            priceDate: result
                                                .priceDate
                                                .toString(),
                                            company: result.company
                                                .toString(),
                                            code_id: result.codeId
                                                .toString(),
                                            grade: result.grade
                                                .toString(),
                                          )));
                            },
                            child: Column(children: [
                              SizedBox(
                                // margin: EdgeInsets.all(10.0),
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Flexible(
                                       // flex: 1,
                                        child: Text(
                                            result.category
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                                letterSpacing: -0.24,
                                                fontFamily: 'assets/fonst/Metropolis-Black.otf'
                                            ),)),
                                    Flexible(
                                        //flex: 1,
                                        child: Text(
                                          result.codeName.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                              letterSpacing: -0.24,
                                              fontFamily: 'assets/fonst/Metropolis-Black.otf'
                                          ),
                                          maxLines: 2,
                                        )),
                                    Flexible(
                                       // flex: 1,
                                        child: Text(
                                          result.grade.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                              letterSpacing: -0.24,
                                              fontFamily: 'assets/fonst/Metropolis-Black.otf'
                                          ),
                                        )),
                                    Flexible(
                                        //flex: 1,
                                        child: Text(
                                          result.currency
                                                  .toString() +
                                              result.price
                                                  .toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                              letterSpacing: -0.24,
                                              fontFamily: 'assets/fonst/Metropolis-Black.otf'
                                          ),
                                        )),
                                    Flexible(
                                      //flex: 1,
                                      child: Text(
                                         (result.sign != null ? result.sign.toString() : '') + result.currency.toString() + (result.changed!.replaceFirst("-", "").toString()),
                                          // result.changed![0] == "0" ? result.currency.toString() + result.changed.toString() :
                                          // result.changed![0] == "-"  ? '-${result.currency}${result.changed!.replaceFirst('-', '')}':
                                          // '+${result.currency}${result.changed}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                            letterSpacing: -0.24,
                                            //color: result.changed![0] == "0" ? result.changed!.length >= 2 ? result.changed![1] == "." ?Colors.green :Colors.black :Colors.black:  result.changed![0] == "-" ? Colors.redAccent : Colors.green),
                                          color: result.sign == "+" ? Colors.green : result.sign == "-" ? Colors.redAccent : Colors.black,)
                                      )),
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.grey,height: 1),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        DateFormat("dd MMM, yyyy").format(DateFormat("dd-MM-yyyy").parse(result.priceDate.toString())),
                                        //result.priceDate.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                          letterSpacing: -0.24,)
                                    ),
                                    Text(
                                        '${result.company} - ${result.state}, ${result.country}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontFamily: 'Metropolis',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                          letterSpacing: -0.24,
                                    ),)
                                  ],
                                ),
                              ),
                              /*choices[index].showgraph ? graph() : Container()*/
                              //SizedBox(height: 5.0,)
                            ]),
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    );
                  },
                )
              : const Center(child: Text('Not Found '))
            )
        : Center(
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
  }

  Widget monthgraph(String? category, String? price, String? company,
      String? codeName, String? changed, String? priceDate) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1,
        child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
                enable: true,
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  return CustomTooltip(
                    category: category.toString(),
                    price: point.y.toString(),
                    company: company.toString(),
                    codeName: codeName.toString(),
                    changed: changed.toString(),
                    priceDate: priceDate.toString(),
                  );
                } // Customize the tooltip text as per your requirements
                ),
            primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                //Hide the axis line of x-axis
                axisLine: const AxisLine(width: 0),
                labelRotation: 45),
            primaryYAxis:
                NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
            // Chart title
            title: ChartTitle(text: 'Month data'),
            // Enable legend
            legend: Legend(isVisible: false),

            /*  loadMoreIndicatorBuilder:
                (BuildContext context, ChartSwipeDirection direction) => buildLoadMoreView(context, direction),*/

            series: <AreaSeries<DataPoint, String>>[
              AreaSeries(
                  borderColor: const Color.fromARGB(255, 176, 159, 255),
                  borderWidth: 3,
                  borderDrawMode: BorderDrawMode.top,
                  gradient: LinearGradient(colors: [
                    const Color.fromARGB(255, 176, 159, 255).withOpacity(0.4),
                    const Color.fromARGB(255, 176, 159, 255).withOpacity(0.2),
                    const Color.fromARGB(255, 176, 159, 255).withOpacity(0.1)
                  ], stops: const [
                    0.1,
                    0.3,
                    0.6
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  dataSource: data1,
                  xValueMapper: (DataPoint data, _) => data.price_date,
                  yValueMapper: (DataPoint data, _) =>
                      double.tryParse(data.price))
            ]),
      ),
    );
  }

  Widget yeargraph(String? category, String? price, String? company,
      String? codeName, String? changed, String? priceDate) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1,
        child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
                enable: true,
                builder: (data, point, series, pointIndex, seriesIndex) {
                  return CustomTooltip(
                    category: category.toString(),
                    price: price.toString(),
                    company: company.toString(),
                    codeName: codeName.toString(),
                    changed: changed.toString(),
                    priceDate: priceDate.toString(),
                  );
                } // Customize the tooltip text as per your requirements
                ),
            primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                //Hide the axis line of x-axis
                axisLine: const AxisLine(width: 0),
                labelRotation: 45),
            primaryYAxis:
                NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
            // Chart title
            title: ChartTitle(text: 'year data'),
            // Enable legend
            legend: Legend(isVisible: false),

            /*  loadMoreIndicatorBuilder:
                (BuildContext context, ChartSwipeDirection direction) => buildLoadMoreView(context, direction),*/

            series: <AreaSeries<DataPoint, String>>[
              AreaSeries(
                  borderColor: const Color.fromARGB(255, 176, 159, 255),
                  borderWidth: 3,
                  borderDrawMode: BorderDrawMode.top,
                  gradient: LinearGradient(colors: [
                    const Color.fromARGB(255, 176, 159, 255).withOpacity(0.4),
                    const Color.fromARGB(255, 176, 159, 255).withOpacity(0.2),
                    const Color.fromARGB(255, 176, 159, 255).withOpacity(0.1)
                  ], stops: const [
                    0.1,
                    0.3,
                    0.6
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  dataSource: data2,
                  xValueMapper: (DataPoint data, _) => data.price_date,
                  yValueMapper: (DataPoint data, _) =>
                      double.tryParse(data.price))
            ]),
      ),
    );
  }

  findcartItem(productId) {
    var found = false;
    //if (cartdata != Null) {
    for (var i = 0; i < price_data.length; i++) {
      if (price_data[i].codeId == (productId)) {
        //if (_cartItems!.any((element) => element.pid == cartdata?.pid)) {
        found = true;
      }
    }
    //}
    return found;
  }

  Widget allgraph(String? category, String? price, String? company,
      String? codeName, String? changed, String? priceDate) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1,
        child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
                enable: true,
                builder: (data, point, series, pointIndex, seriesIndex) {
                  return CustomTooltip(
                    category: category.toString(),
                    price: price.toString(),
                    company: company.toString(),
                    codeName: codeName.toString(),
                    changed: changed.toString(),
                    priceDate: priceDate.toString(),
                  );
                } // Customize the tooltip text as per your requirements
                ),
            primaryXAxis: CategoryAxis(
                isVisible: true,
                majorGridLines: const MajorGridLines(width: 0),
                //Hide the axis line of x-axis
                axisLine: const AxisLine(width: 0),
                labelRotation: 45),
            primaryYAxis:
                NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
            // Chart title
            title: ChartTitle(text: 'All data'),
            // Enable legend
            legend: Legend(isVisible: false),

            /*  loadMoreIndicatorBuilder:
                (BuildContext context, ChartSwipeDirection direction) => buildLoadMoreView(context, direction),*/

            series: <AreaSeries<DataPoint, String>>[
              AreaSeries(
                  borderColor: const Color.fromARGB(255, 176, 159, 255),
                  borderWidth: 3,
                  borderDrawMode: BorderDrawMode.top,
                  gradient: LinearGradient(colors: [
                    const Color.fromARGB(255, 176, 159, 255).withOpacity(0.4),
                    const Color.fromARGB(255, 176, 159, 255).withOpacity(0.2),
                    const Color.fromARGB(255, 176, 159, 255).withOpacity(0.1)
                  ], stops: const [
                    0.1,
                    0.3,
                    0.6
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  dataSource: data3,
                  xValueMapper: (DataPoint data, _) => data.price_date,
                  yValueMapper: (DataPoint data, _) =>
                      double.tryParse(data.price))
            ]),
      ),
    );
  }

  // Widget buildLoadMoreView(
  //     BuildContext context, ChartSwipeDirection direction) {
  //   if (direction == ChartSwipeDirection.end) {
  //     return FutureBuilder<String>(
  //       future: get_graphmonthvalue(), /// Adding additional data using updateDataSource method
  //       builder: (BuildContext futureContext, AsyncSnapshot<String> snapShot) {
  //         return snapShot.connectionState != ConnectionState.done
  //             ? const CircularProgressIndicator()
  //             : SizedBox.fromSize(size: Size.zero);
  //       },
  //     );
  //   } else {
  //     return SizedBox.fromSize(size: Size.zero);
  //   }
  // }

  void _onLoading() {
    BuildContext dialogContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context; // Store the context in a variable
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            width: 300.0,
            height: 150.0,
            child: Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: Center(
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
                            : Container()),
              ),
            ),
          ),
          /*Container(
            child: Stack(
              children: <Widget>[
                Container(
                  width: 300.0,
                  height: 150.0,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    width: 300.0,
                    height: 150.0,
                    alignment: AlignmentDirectional.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const
                      */ /*  Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          child: Center(
                            child: Text(
                              "loading.. wait...",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),*/ /*
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )*/
        );
      },
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      // Dialog closed
    });
  }

  clear() {
    constanst.select_categotyId.clear();
    constanst.select_typeId.clear();
    constanst.select_gradeId.clear();
    constanst.selectbusstype_id.clear();
    constanst.select_categotyType.clear();
    constanst.select_state.clear();
    constanst.select_country.clear();
    constanst.date = "";
  }

  get_HomePost() async {
    var res = await getlive_price(offset.toString(), '20', _search.text,
        category_id, company_id, country, state, constanst.date);
    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          print("Livedata:-${data}");
          price.Result record = price.Result(
              codeId: data['codeId'],
              codeName: data['CodeName'],
              priceId: data['priceId'],
              category: data['Category'],
              grade: data['Grade'],
              priceDate: data['PriceDate'],
              price: data['Price'],
              changed: data['Changed'],
              currency: data['Currency'],
              state: data['State'],
              company: data['Company'],
              country: data['Country'],
              sign: data['sign']
          );
          price_data.add(record);
        }
        for (int i = 0; i < price_data.length; i++) {
          show_graph_data.add(false);
        }
        isload = true;
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
  }

  get_graphmonthvalue(String string) async {
    var res = await get_databytimeduration(string);
    if (res['status'] == 1) {
      // gethomepost = get_graph.fromJson(res);
      //if (res.statusCode == 200) {
      get_graph graph = get_graph.fromJson(res);
      if (graph.lastMonthRecord != null) {
        // Use the lastMonthRecords list as needed
        // ...
      }
      return graph.lastMonthRecord!
          .map((data) =>
              DataPoint(data.priceDate.toString(), data.price.toString()))
          .toList();
      /* } else {
        throw Exception('Failed to fetch data from API');
      }*/
    }
  }

  get_graphyearvalue(String string) async {
    var res = await get_databytimeduration(string);
    if (res['status'] == 1) {
      // gethomepost = get_graph.fromJson(res);

      //if (res.statusCode == 200) {
      get_graph graph = get_graph.fromJson(res);
      if (graph.lastYearRecord != null) {
        // Use the lastMonthRecords list as needed
        // ...
      }
      return graph.lastYearRecord!
          .map((data) =>
              DataPoint(data.priceDate.toString(), data.price.toString()))
          .toList();
      /* } else {
        throw Exception('Failed to fetch data from API');
      }*/
    }
  }

  get_graphallvalue(String string) async {
    var res = await get_databytimeduration(string);
    if (res['status'] == 1) {
      // gethomepost = get_graph.fromJson(res);

      //if (res.statusCode == 200) {
      get_graph graph = get_graph.fromJson(res);
      if (graph.allRecord != null) {
        // Use the lastMonthRecords list as needed
        // ...
      }
      return graph.allRecord!
          .map((data) =>
              DataPoint(data.priceDate.toString(), data.price.toString()))
          .toList();
    }
  }
}

class CustomTooltip extends StatelessWidget {
  final String category, price, company, codeName, changed, priceDate;

  const CustomTooltip({
    //super.key,
    required this.category,
    required this.price,
    required this.company,
    required this.codeName,
    required this.changed,
    required this.priceDate,
  });

  @override
  Widget build(BuildContext context) {
    var old = double.tryParse(price)! - double.tryParse(changed)!;
    return Container(
      height: 120,
      //width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'New Price:$price ',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'old Price:$old',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                'change:$changed',
                style: const TextStyle(color: Colors.white),
              )),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              company,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "$category/$codeName",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                priceDate,
                style: const TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}

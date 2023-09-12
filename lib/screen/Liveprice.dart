import 'dart:core';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../api/api_interface.dart';
import '../model/DataPoint.dart';
import '../model/GetPriceList.dart';
import 'package:Plastic4trade/model/GetPriceList.dart' as price;
import '../model/get_graph.dart';
import '../widget/live_priceFilterScreen.dart';
import 'Liveprice_detail.dart';
import 'Videos.dart';
import '../utill/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

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
  bool isgraph = false;
  static const cutOffYValue = 0.0;
  final scrollercontroller = ScrollController();
  List<price.Result> price_data = [];
  List<bool> show_graph_data = [];
  bool loadmore = false;
  bool isload = false;
  int offset = 0;
  int count = 0;
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
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
  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollercontroller.addListener(_scrollercontroller);
    sampleData1.add(new RadioModel(true, 'Month'));
    sampleData1.add(new RadioModel(
      false,
      'Year',
    ));
    sampleData1.add(new RadioModel(
      false,
      'All',
    ));
    clear();
    checknetowork();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
        backgroundColor: const Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          title: Text('Live Price',
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
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Videos()));
                },
                child: SizedBox(
                    width: 40,
                    child: Image.asset(
                      'assets/Play.png',
                    ))),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
                onTap: () {},
                child: SizedBox(
                    width: 30,
                    height: 20,
                    child: Image.asset(
                      'assets/share1.png',
                    ))),
            SizedBox(
              width: 5,
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                  height: 65,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: 55,
                          margin: EdgeInsets.only(left: 5.0),
                          width: MediaQuery.of(context).size.width / 1.35,
                          child: Card(
                              //margin: EdgeInsets.all(10),
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.white)),
                              child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceEvenly,
                                children: [
                                  /*  Padding(
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      child: ImageIcon(
                                          AssetImage('assets/search.png'))),*/
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(40.0),
                                              bottomRight:
                                                  Radius.circular(40.0),
                                              topLeft: Radius.circular(40.0),
                                              bottomLeft:
                                                  Radius.circular(40.0)),
                                          color: Colors.white),
                                      height: 40,
                                      margin: EdgeInsets.only(left: 8.0),
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: TextField(
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                            controller: _search,
                                            textInputAction:
                                                TextInputAction.search,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                prefixIconConstraints:
                                                    BoxConstraints(
                                                        minWidth: 24),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
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
                                                        'assets\fonst\Metropolis-Black.otf')),
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
                                          ))),
                                ],
                              ))),
                      SizedBox(
                        width: 5,
                      ),
                      isgraph
                          ? GestureDetector(
                              onTap: () {
                                //ViewItem(context);
                                // showAlertDialog(context);
                                setState(() {
                                  isgraph = false;
                                });
                              },
                              child: Container(
                                  height: 65,
                                  width:
                                      MediaQuery.of(context).size.width / 9.5,
                                  padding: EdgeInsets.all(8.0),
                                  // padding: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Image.asset(
                                    'assets/list_data.png',
                                    width: 20,
                                  )))
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isgraph = true;
                                });

                                //ViewItem(context);
                                // showAlertDialog(context);
                              },
                              child: Container(
                                  height: 65,
                                  width:
                                      MediaQuery.of(context).size.width / 9.5,
                                  padding: EdgeInsets.all(8.0),
                                  // padding: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Image.asset(
                                    'assets/diagram.png',
                                    width: 20,
                                  ))),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            ViewItem(context);
                          },
                          child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width / 9.5,
                              // padding: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 0, 91, 148)),
                              child: Icon(
                                Icons.filter_alt,
                                color: Colors.white,
                              ))),
                    ],
                  )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Category',
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'assets\fonst\Metropolis-Black.otf',
                            color: Colors.black)),
                    Text('Grade',
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'assets\fonst\Metropolis-Black.otf',
                            color: Colors.black)),
                    Text('Code',
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'assets\fonst\Metropolis-Black.otf',
                            color: Colors.black)),
                    Text('Price',
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'assets\fonst\Metropolis-Black.otf',
                            color: Colors.black)),
                    Text('+/-',
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'assets\fonst\Metropolis-Black.otf',
                            color: Colors.black)),
                  ],
                ),
              ),
              isgraph ? Container() : pricelist()
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
      print(lastMonthRecords);
      return lastMonthRecords;
      // return graph.lastMonthRecord!.map((data) => DataPoint(data.priceDate.toString(), data.price.toString())).toList();
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  List<charts.Series<DataPoint, DateTime>> createSeries(
      List<DataPoint> records) {
    return [
      charts.Series<DataPoint, DateTime>(
        id: 'Price',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPoint record, _) => DateTime.parse(record.price_date!),
        measureFn: (DataPoint record, _) => double.parse(record.price!),
        data: records,
      ),
    ];
  }

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
                  return live_priceFilterScreen();
                },
              );
            })).then(
      (value) {
        category_id = constanst.select_categotyId.join(",");
        print(category_id);
        company_id = constanst.select_typeId.join(",");
        print(company_id);
        country = constanst.select_country.join(",");
        print(country);
        state = constanst.select_state.join(",");
        print(state);

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
            child: Container(
                //height: 200,

                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                    //future: load_category(),

                    builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    //List<dynamic> users = snapshot.data as List<dynamic>;
                    return price_data.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: price_data.length,
                            controller: scrollercontroller,
                            itemBuilder: (context, index) {
                              // Choice record = choices[index];
                              price.Result result = price_data[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
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
                                          Container(
                                            // margin: EdgeInsets.all(10.0),
                                            height: 30,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                        result.category
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 13.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-Black.otf'))),
                                                Flexible(
                                                    flex: 3,
                                                    child: Text(
                                                      result.codeName
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf',
                                                          color: Colors.black),
                                                      maxLines: 2,
                                                    )),
                                                Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                      result.grade.toString(),
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf',
                                                          color: Colors.black),
                                                    )),
                                                Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                      result.currency
                                                              .toString() +
                                                          result.price
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf',
                                                          color: Colors.black),
                                                    )),
                                                Flexible(
                                                    child: Text(
                                                      result.changed.toString(),
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf',
                                                          color: Colors.black),
                                                    ),
                                                    flex: 1),
                                              ],
                                            ),
                                          ),
                                          Divider(color: Colors.grey),
                                          Container(
                                              //height: 50,
                                              margin: const EdgeInsets.fromLTRB(
                                                  10.0, 2.0, 0.0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      result.priceDate
                                                          .toString(),
                                                      style: TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .black38,
                                                              fontSize: 11)),
                                                  Text(
                                                      result.company
                                                              .toString() +
                                                          '-' +
                                                          result.state
                                                              .toString() +
                                                          result.country
                                                              .toString(),
                                                      style: TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .black38,
                                                              fontSize: 11)),
                                                ],
                                              )),

                                          /*choices[index].showgraph ? graph() : Container()*/
                                          //SizedBox(height: 5.0,)
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: Text('Not Found '));
                  }

                  return CircularProgressIndicator();
                })))
        : Center(
            child: Platform.isAndroid
                ? CircularProgressIndicator(
                    value: null,
                    strokeWidth: 2.0,
                    color: Color.fromARGB(255, 0, 91, 148),
                  )
                : Platform.isIOS
                    ? CupertinoActivityIndicator(
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
      child: Container(
        width: MediaQuery.of(context).size.width / 1,
        child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
                enable: true,
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  print('tooltip');
                  print(point.x);
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
                majorGridLines: MajorGridLines(width: 0),
                //Hide the axis line of x-axis
                axisLine: AxisLine(width: 0),
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
                  borderColor: Color.fromARGB(255, 176, 159, 255),
                  borderWidth: 3,
                  borderDrawMode: BorderDrawMode.top,
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 176, 159, 255).withOpacity(0.4),
                    Color.fromARGB(255, 176, 159, 255).withOpacity(0.2),
                    Color.fromARGB(255, 176, 159, 255).withOpacity(0.1)
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
      child: Container(
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
                majorGridLines: MajorGridLines(width: 0),
                //Hide the axis line of x-axis
                axisLine: AxisLine(width: 0),
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
                  borderColor: Color.fromARGB(255, 176, 159, 255),
                  borderWidth: 3,
                  borderDrawMode: BorderDrawMode.top,
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 176, 159, 255).withOpacity(0.4),
                    Color.fromARGB(255, 176, 159, 255).withOpacity(0.2),
                    Color.fromARGB(255, 176, 159, 255).withOpacity(0.1)
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
    print(productId);
    //if (cartdata != Null) {
    for (var i = 0; i < price_data.length; i++) {
      if (price_data[i].codeId == (productId)) {
        //if (_cartItems!.any((element) => element.pid == cartdata?.pid)) {
        found = true;
      }
    }
    //}
    print('found $found');
    return found;
  }

  Widget allgraph(String? category, String? price, String? company,
      String? codeName, String? changed, String? priceDate) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
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
                majorGridLines: MajorGridLines(width: 0),
                //Hide the axis line of x-axis
                axisLine: AxisLine(width: 0),
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
                  borderColor: Color.fromARGB(255, 176, 159, 255),
                  borderWidth: 3,
                  borderDrawMode: BorderDrawMode.top,
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 176, 159, 255).withOpacity(0.4),
                    Color.fromARGB(255, 176, 159, 255).withOpacity(0.2),
                    Color.fromARGB(255, 176, 159, 255).withOpacity(0.1)
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

  Widget buildLoadMoreView(
      BuildContext context, ChartSwipeDirection direction) {
    if (direction == ChartSwipeDirection.end) {
      return FutureBuilder<String>(
        //future: get_graphmonthvalue(), /// Adding additional data using updateDataSource method
        builder: (BuildContext futureContext, AsyncSnapshot<String> snapShot) {
          return snapShot.connectionState != ConnectionState.done
              ? const CircularProgressIndicator()
              : SizedBox.fromSize(size: Size.zero);
        },
      );
    } else {
      return SizedBox.fromSize(size: Size.zero);
    }
  }

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
                        ? CircularProgressIndicator(
                      value: null,
                      strokeWidth: 2.0,
                      color: Color.fromARGB(255, 0, 91, 148),
                    )
                        : Platform.isIOS
                        ? CupertinoActivityIndicator(
                      color: Color.fromARGB(255, 0, 91, 148),
                      radius: 20,
                      animating: true,
                    )
                        : Container()
                ),
              ),
            ),
          ), /*Container(
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

    Future.delayed(const Duration(seconds: 5), () {
      print('exit');
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
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
    GetPriceList gethomepost = GetPriceList();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(country);
    var res = await getlive_price(offset.toString(), '20', _search.text,
        category_id, company_id, country, state, constanst.date);
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      gethomepost = GetPriceList.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        print(jsonarray);

        for (var data in jsonarray) {
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
              country: data['Country']);
          price_data.add(record);
        }
        for (int i = 0; i < price_data.length; i++) {
          show_graph_data.add(false);
        }
        print(price_data);
        isload = true;
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }

  get_graphmonthvalue(String string) async {
    get_graph gethomepost = get_graph();
    var res = await get_databytimeduration(string);
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      // gethomepost = get_graph.fromJson(res);
      List<LastMonthRecord> lastMonthRecords = [];
      List<LastYearRecord> lastYearRecord = [];
      List<AllRecord> allRecord = [];
      //if (res.statusCode == 200) {
      get_graph graph = get_graph.fromJson(res);
      if (graph.lastMonthRecord != null) {
        lastMonthRecords = graph.lastMonthRecord!;
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
      return jsonarray;
    }
  }

  get_graphyearvalue(String string) async {
    get_graph gethomepost = get_graph();
    var res = await get_databytimeduration(string);
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      // gethomepost = get_graph.fromJson(res);

      List<LastYearRecord> lastYearRecord = [];

      //if (res.statusCode == 200) {
      get_graph graph = get_graph.fromJson(res);
      if (graph.lastYearRecord != null) {
        lastYearRecord = graph.lastYearRecord!;
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
      return jsonarray;
    }
  }

  get_graphallvalue(String string) async {
    get_graph gethomepost = get_graph();
    var res = await get_databytimeduration(string);
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      // gethomepost = get_graph.fromJson(res);

      List<AllRecord> allRecord = [];

      //if (res.statusCode == 200) {
      get_graph graph = get_graph.fromJson(res);
      if (graph.allRecord != null) {
        allRecord = graph.allRecord!;
        // Use the lastMonthRecords list as needed
        // ...
      }
      return graph.allRecord!
          .map((data) =>
              DataPoint(data.priceDate.toString(), data.price.toString()))
          .toList();
      /* } else {
        throw Exception('Failed to fetch data from API');
      }*/
      return jsonarray;
    }
  }
}

class CustomTooltip extends StatelessWidget {
  final String category, price, company, codeName, changed, priceDate;

  CustomTooltip({
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
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'New Price:$price ',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'old Price:$old',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                'change:$changed',
                style: TextStyle(color: Colors.white),
              )),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              company,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "$category/$codeName",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                priceDate,
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}

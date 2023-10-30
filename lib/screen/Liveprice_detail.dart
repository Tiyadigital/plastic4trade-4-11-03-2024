// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:core';
import 'dart:io';

import 'package:Plastic4trade/model/Getcoderecord.dart' as price;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../api/api_interface.dart';
import '../model/DataPoint.dart';
import '../model/get_graph.dart';
import '../utill/constant.dart';

class Liveprice_detail extends StatefulWidget {
  String? category,
      price,
      company,
      codeName,
      changed,
      priceDate,
      code_id,
      grade;

  Liveprice_detail(
      {Key? key,
      this.category,
      this.changed,
      this.codeName,
      this.price,
      this.priceDate,
      this.company,
      this.code_id,
      this.grade})
      : super(key: key);

  @override
  State<Liveprice_detail> createState() => _Liveprice_detailState();
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

class _Liveprice_detailState extends State<Liveprice_detail> {
  bool isgraph = false;
  final scrollercontroller = ScrollController();
  List<bool> show_graph_data = [];
  bool loadmore = false;
  bool isload = false;
  int offset = 0;
  int count = 0;
  List<price.Result> price_data = [];
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollercontroller.addListener(_scrollercontroller);
    sampleData1.add(
      RadioModel(true, 'Month'),
    );
    sampleData1.add(
      RadioModel(false, 'Year'),
    );
    sampleData1.add(
      RadioModel(false, 'All'),
    );
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
        title: const Text(
          'Live Price Detail ',
          softWrap: false,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'Metropolis',
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.fromLTRB(10.5, 5.0, 10.5, 5.0),
            decoration: const BoxDecoration(

                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: sampleData1[0].isSelected == true
                          ? Icon(Icons.check_circle,
                              color: Colors.green.shade600)
                          : const Icon(Icons.circle_outlined,
                              color: Colors.black38),
                      onTap: () {
                        setState(() {
                          sampleData1[0].isSelected = true;
                          type_post = sampleData1[0].buttonText;
                          sampleData1[1].isSelected = false;
                          sampleData1[2].isSelected = false;
                          setState(() {});
                        });
                      },
                    ),
                    Text(
                      sampleData1[0].buttonText,
                      style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'assets/fonst/Metropolis-Black.otf')
                          .copyWith(fontSize: 17),
                    )
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: sampleData1[1].isSelected == true
                          ? Icon(Icons.check_circle,
                              color: Colors.green.shade600)
                          : const Icon(Icons.circle_outlined,
                              color: Colors.black38),
                      onTap: () {
                        setState(() {
                          sampleData1[1].isSelected = true;
                          type_post = sampleData1[1].buttonText;
                          sampleData1[0].isSelected = false;
                          sampleData1[2].isSelected = false;
                          setState(() {});
                        });
                      },
                    ),
                    Text(
                      sampleData1[1].buttonText,
                      style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'assets/fonst/Metropolis-Black.otf')
                          .copyWith(fontSize: 17),
                    )
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: sampleData1[2].isSelected == true
                          ? Icon(Icons.check_circle,
                              color: Colors.green.shade600)
                          : const Icon(Icons.circle_outlined,
                              color: Colors.black38),
                      onTap: () {
                        setState(() {
                          sampleData1[2].isSelected = true;
                          type_post = sampleData1[2].buttonText;
                          sampleData1[0].isSelected = false;
                          sampleData1[1].isSelected = false;
                          setState(() {});
                        });
                      },
                    ),
                    Text(
                      sampleData1[2].buttonText,
                      style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'assets/fonst/Metropolis-Black.otf')
                          .copyWith(fontSize: 17),
                    )
                  ],
                ),
              ],
            ),
          ),

          sampleData1[0].isSelected
              ? monthgraph(widget.category, widget.price, widget.company,
                  widget.codeName, widget.changed, widget.priceDate)
              : sampleData1[1].isSelected
                  ? yeargraph(widget.category, widget.price, widget.company,
                      widget.codeName, widget.changed, widget.priceDate)
                  : sampleData1[2].isSelected
                      ? allgraph(widget.category, widget.price, widget.company,
                          widget.codeName, widget.changed, widget.priceDate)
                      : Container(),
          pricelist(),
        ],
      ),
    );
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');

    } else {
      get_graphmonthvalue(
        widget.code_id.toString(),
      ).then((fetchedData) {
        setState(() {
          data1 = fetchedData;
        });
      });
      get_graphyearvalue(
        widget.code_id.toString(),
      ).then((fetchedData) {
        setState(() {
          data2 = fetchedData;
        });
      });
      get_graphallvalue(
        widget.code_id.toString(),
      ).then((fetchedData) {
        setState(() {
          data3 = fetchedData;
        });
      });
      get_HomePost();
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

    }
  }

  Widget pricelist() {
    return isload == true
        ? Expanded(
            child: Container(


              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(


                  builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {

                  return price_data.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: false,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: price_data.length,
                          controller: scrollercontroller,
                          itemBuilder: (context, index) {

                            price.Result result = price_data[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(

                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              widget.category.toString(),
                                              style: const TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf'),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 3,
                                            child: Text(
                                              widget.codeName.toString(),
                                              style: const TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf',
                                                  color: Colors.black),
                                              maxLines: 2,
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              widget.grade.toString(),
                                              style: const TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf',
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              result.currency.toString() +
                                                  result.price.toString(),
                                              style: const TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf',
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Text(
                                              result.changed.toString(),
                                              style: const TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf',
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(color: Colors.grey),
                                    Container(

                                      margin: const EdgeInsets.fromLTRB(
                                          10.0, 2.0, 0.0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            result.priceDate.toString(),
                                            style: const TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(
                                                    color: Colors.black38,
                                                    fontSize: 11),
                                          ),
                                          Text(
                                            '${widget.company}-${result.state}${result.country}',
                                            style: const TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(
                                                    color: Colors.black38,
                                                    fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('Not Found '),
                        );
                }
              }),
            ),
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
                    : Container(),
          );
  }

  Widget monthgraph(String? category, String? price, String? company,
      String? codeName, String? changed, String? priceDate) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.5, 5.0, 10.5, 5.0),
      width: MediaQuery.of(context).size.width / 1,
      decoration: const BoxDecoration(

          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          color: Colors.white),
      child: SingleChildScrollView(
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
                }
                ),
            primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),

                axisLine: const AxisLine(width: 0),
                labelRotation: 45),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),

            title: ChartTitle(
              text: 'Month data',
              textStyle: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')
                  .copyWith(fontSize: 17),
            ),

            legend: Legend(isVisible: false),


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
                    double.tryParse(data.price),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget yeargraph(String? category, String? price, String? company,
      String? codeName, String? changed, String? priceDate) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.5, 5.0, 10.5, 5.0),
      decoration: const BoxDecoration(

          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          color: Colors.white),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1,
          child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
                enable: true,
                builder: (data, point, series, pointIndex, seriesIndex) {
                  return CustomTooltip(
                    category: category.toString(),
                    price: point.y.toString(),
                    company: company.toString(),
                    codeName: codeName.toString(),
                    changed: changed.toString(),
                    priceDate: priceDate.toString(),
                  );
                }
                ),
            primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),

                axisLine: const AxisLine(width: 0),
                labelRotation: 45),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),

            title: ChartTitle(
              text: 'year data',
              textStyle: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')
                  .copyWith(fontSize: 17),
            ),

            legend: Legend(isVisible: false),

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
                    double.tryParse(data.price),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget allgraph(String? category, String? price, String? company,
      String? codeName, String? changed, String? priceDate) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.5, 5.0, 10.5, 5.0),
      decoration: const BoxDecoration(

          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          color: Colors.white),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1,
          child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
                enable: true,
                builder: (data, point, series, pointIndex, seriesIndex) {
                  return CustomTooltip(
                    category: category.toString(),
                    price: point.y.toString(),
                    company: company.toString(),
                    codeName: codeName.toString(),
                    changed: changed.toString(),
                    priceDate: priceDate.toString(),
                  );
                }
                ),
            primaryXAxis: CategoryAxis(
                isVisible: true,
                majorGridLines: const MajorGridLines(width: 0),

                axisLine: const AxisLine(width: 0),
                labelRotation: 45),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),

            title: ChartTitle(
              text: 'All data',
              textStyle: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')
                  .copyWith(fontSize: 17),
            ),

            legend: Legend(isVisible: false),

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
                    double.tryParse(data.price),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onLoading() {
    BuildContext dialogContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
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
                          : Container(),
                ),
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(dialogContext)
          .pop();
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
    var res = await get_coderecord(
      widget.code_id.toString(),
      offset.toString(),
    );
    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          price.Result record = price.Result(
            priceDate: data['price_date'],
            price: data['price'],
            changed: data['changed'],
            currency: data['currency'],
            state: data['state'],
            country: data['country'],
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
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
    return jsonArray;
  }

  get_graphmonthvalue(String string) async {
    var res = await get_databytimeduration(string);
    if (res['status'] == 1) {

      get_graph graph = get_graph.fromJson(res);
      if (graph.lastMonthRecord != null) {

      }
      return graph.lastMonthRecord!
          .map(
            (data) => DataPoint(
              data.priceDate.toString(),
              data.price.toString(),
            ),
          )
          .toList();

    }
  }

  get_graphyearvalue(String string) async {
    var res = await get_databytimeduration(string);
    if (res['status'] == 1) {



      get_graph graph = get_graph.fromJson(res);
      if (graph.lastYearRecord != null) {

      }
      return graph.lastYearRecord!
          .map(
            (data) => DataPoint(
              data.priceDate.toString(),
              data.price.toString(),
            ),
          )
          .toList();

    }
  }

  get_graphallvalue(String string) async {
    var res = await get_databytimeduration(string);
    if (res['status'] == 1) {

      get_graph graph = get_graph.fromJson(res);
      if (graph.allRecord != null) {
      }
      return graph.allRecord!
          .map(
            (data) => DataPoint(
              data.priceDate.toString(),
              data.price.toString(),
            ),
          )
          .toList();

    }
  }
}

class CustomTooltip extends StatelessWidget {
  final String category, price, company, codeName, changed, priceDate;

  const CustomTooltip({
    super.key,
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
            ),
          ),
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
            ),
          ),
        ],
      ),
    );
  }
}

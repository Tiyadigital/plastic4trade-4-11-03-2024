// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison, non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'dart:io';

import 'package:Plastic4trade/api/api_interface.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../widget/HomeAppbar.dart';

class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  State<Videos> createState() => _YourWidgetState();
}

class _YourWidgetState extends State<Videos> {
  String? assignedName;
  bool load = false;
  String link = "";
  String content = "";
  List<String> videolist = [];
  List<String> videocontent = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checknetowork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 218, 218, 218),
      appBar: CustomeApp('Videos'),
      body: load
          ? RefreshIndicator(
            displacement: 50,
            color: const Color(0xFF005C94),
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: ()async{},
            child: FutureBuilder(
              future: get_videolist(),
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
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: videolist.length,
                //padding: EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                itemBuilder: (context, index) {
                  //Choice record = choices[index];
                  return Container(
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(13.05)),
                          color: Colors.white),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Padding(
                          padding: const EdgeInsets.all(13.05),
                          child: Column(children: [
                            YoutubeViewer(videolist[index]),
                            Text(
                              videocontent[index].toString(),
                              style: const TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf')
                                  .copyWith(fontSize: 15),
                            )
                          ])));
                });
                        }
                      }),
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
                      : Container()),
    );
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      get_videolist();
      // get_data();
    }
  }

  Future<void> get_videolist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getvideolist(pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        //
        for (var data in jsonArray) {
          link = data['videoendUrl'];
          content = data['videoTitle'];

          videolist.add(link);
          videocontent.add(content);
          //loadmore = true;
        }
        load = true;
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
  }
}

class YoutubeViewer extends StatefulWidget {
  final String videoID;

  const YoutubeViewer(this.videoID,
     // {super.key}
      );
  // const YoutubeViewer({super.key});

  @override
  _YoutubeViewerState createState() => _YoutubeViewerState();
}

class _YoutubeViewerState extends State<YoutubeViewer>
    with AutomaticKeepAliveClientMixin {
  late final YoutubePlayerController controller;
  bool isPlaying = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController.fromVideoId(
        params: const YoutubePlayerParams(
          enableCaption: false,
          showVideoAnnotations: false,
          playsInline: false,
          showFullscreenButton: true,
          pointerEvents: PointerEvents.auto,
          showControls: true,
        ),
        videoId: widget.videoID);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final player = YoutubePlayer(
      controller: controller,
      key: ValueKey(widget.videoID),
    );

    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(13.05), // Image border
      child: player,
    );
  }
}

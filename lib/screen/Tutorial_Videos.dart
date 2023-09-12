import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/api/api_interface.dart';
import 'package:Plastic4trade/model/GetVideoList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:flutter/gestures.dart';
import 'package:Plastic4trade/model/GetVideoList.dart' as video;
import '../widget/HomeAppbar.dart';

class Tutorial_Videos extends StatefulWidget {
  const Tutorial_Videos({Key? key}) : super(key: key);

  @override
  State<Tutorial_Videos> createState() => _YourWidgetState();
}




class _YourWidgetState extends State<Tutorial_Videos> {
  int? _radioValue = 0;
  int? _managerValue = 0;
  String? assignedName;
  bool load = false;
  String link="";
  String content="";
  int offset = 0;
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
        backgroundColor: Color.fromARGB(240, 218, 218, 218),
        appBar: CustomeApp('Tutorial_Video'),
        body:load? Container(
    margin: EdgeInsets.fromLTRB( 10.0,10.0,10.0,0.0),
    child: SingleChildScrollView(
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
                physics: NeverScrollableScrollPhysics(),
                itemCount: videolist.length,
                //padding: EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                itemBuilder: (context, index) {
                  //Choice record = choices[index];
                  return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(children: [
                            YoutubeViewer(videolist[index]),
                            SizedBox(height: 10,),
                            Text(
                              videocontent[index].toString(),
                              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                  ?.copyWith(fontSize: 15),
                            )
                          ])));
                });
          }
        }))):Center(
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
                : Container()),);
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
    GetVideoList getsimmilar = GetVideoList();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await gettutorialvideolist(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),offset.toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = GetVideoList.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];



        //
        for (var data in jsonarray) {

        link=data['video_id'];
        content=data['title'];

          videolist.add(link);
          videocontent.add(content);
          //loadmore = true;
        }
        load=true;
        print(link);
        if (mounted) {
          setState(() {

          });
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
    setState(() {});
  }
}

class YoutubeViewer extends StatefulWidget {
  final String videoID;

  const YoutubeViewer(this.videoID, {super.key});
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

      // gestureRecognizers: Set()
      //   ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
      //   ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
      //   ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
      //   ..add(Factory<VerticalDragGestureRecognizer>(
      //           () => VerticalDragGestureRecognizer())),
      //gestureRecognizers: isPlaying ? null : isPlaying =true //<Factory<OneSequenceGestureRecognizer>>{},
    );

    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(20), // Image border
      child: player,
      // Positioned.fill(
      //   child: PointerInterceptor(
      //     intercepting: !isPlaying,
      //     child: MouseRegion(
      //
      //       cursor: SystemMouseCursors.move,
      //       child: GestureDetector(
      //         //onTap: () async => controller.playVideo(),
      //         onTap: () {
      //           // final _newCode = videosList[index].youtubeId;
      //           isPlaying == false ? controller
      //               .playVideo() : controller
      //               .pauseVideo();
      //         },
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

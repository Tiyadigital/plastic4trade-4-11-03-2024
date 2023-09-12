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
import '../model/getTutorialVideo_dialog.dart';
import '../widget/HomeAppbar.dart';

class Tutorial_Videos_dialog extends StatefulWidget {
  String title;
   Tutorial_Videos_dialog(this.title, {Key? key}) : super(key: key);

  @override
  State<Tutorial_Videos_dialog> createState() => _YourWidgetState();
}




class _YourWidgetState extends State<Tutorial_Videos_dialog> {
  int? _radioValue = 0;
  int? _managerValue = 0;
  String? assignedName;
  bool? load;
  bool availble = false;
  String link="";
  String content="";
  String screen_id = "0";
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
    return load==true?
      Dialog(
            alignment: Alignment.center,
            elevation: 0,

            backgroundColor: Color.fromARGB(255, 0, 91, 148),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child :Container(

              margin: EdgeInsets.only(right: 5.0,bottom: 5.0,left: 5.0),

              height: 250,
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Color.fromARGB(255, 0, 91, 148)),
                borderRadius: BorderRadius.circular(25.0),
                // color: Color.fromARGB(255, 0, 91, 148)
              ),
              /*decoration: Decoration(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              ),*/

            child: Column(
              mainAxisSize: MainAxisSize.min,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Align(
                 alignment: Alignment.bottomRight,
                 child: IconButton(
                   icon: Icon(Icons.cancel_rounded,color: Colors.white),
                   onPressed: () {
                     Navigator.pop(context);
                   },
                 ),
               ),
                link!=""?Column(
                  children: [
                    YoutubeViewer(link),
                    Text(
                      content.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontSize: 15,color: Colors.white),
                    )
                  ],
                ):Text(
                  "Not Found",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 15,color: Colors.white),
                )

              ],
            )),
    ):Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 0, 91, 148)));
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {

      get_videolistScreen();
      // get_data();
    }
  }
  Future<void> get_videolistScreen() async {
    getTutorialVideo_dialog getsimmilar = getTutorialVideo_dialog();
    SharedPreferences _pref = await SharedPreferences.getInstance();

        if (widget.title == 'Home')
          screen_id="1";
        else if (widget.title == 'Saller')
          screen_id="0";
        if (widget.title == 'Buyer')
          screen_id="0";
        if (widget.title == 'News')
          screen_id="2";
        if (widget.title == 'More')
          screen_id="0";
        if (widget.title == 'Exhibition')
          screen_id="5";
        if (widget.title == 'Directory')
          screen_id="4";
        if (widget.title == 'PremiumMember')
          screen_id="0";
        if (widget.title == 'Favourite')
          screen_id="8";
        if (widget.title == 'Videos')
          screen_id="6";
        if (widget.title == 'Tutorial_Video')
          screen_id="0";
        if (widget.title == 'ContactUs')
          screen_id="7";
        if (widget.title == 'Exhibitor')
          screen_id="10";


    var res = await gettutorialvideo_screen(screen_id);

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = getTutorialVideo_dialog.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];



        //
       // for (var data in jsonarray) {

        link=jsonarray['video_id'];
        content=jsonarray['title'];

          /*videolist.add(link);
          videocontent.add(content);*/
          //loadmore = true;
        //}
        load=true;
        print(link);
        if (mounted) {
          setState(() {

          });
        }
      }else{
        load=true;
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

      borderRadius: BorderRadius.circular(15), // Image border
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

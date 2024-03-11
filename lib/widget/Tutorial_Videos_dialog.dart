// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, prefer_typing_uninitialized_variables, depend_on_referenced_packages, camel_case_types, must_be_immutable

import 'package:Plastic4trade/api/api_interface.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Tutorial_Videos_dialog extends StatefulWidget {
  String title;
   Tutorial_Videos_dialog(this.title, {Key? key}) : super(key: key);

  @override
  State<Tutorial_Videos_dialog> createState() => _YourWidgetState();
}


class _YourWidgetState extends State<Tutorial_Videos_dialog> {
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
            backgroundColor: const Color.fromARGB(255, 0, 91, 148),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child :Container(
                height: 300,
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: const Color(0xFF005C94),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
            child: Stack(
              children: [
                link!=""?
                Column(
                  children: [
                    const SizedBox(height: 40),
                    YoutubeViewer(link),
                    Text(
                      content.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontSize: 15,color: Colors.white),
                    )
                  ],
                )
                    : Center(
                  child: Text(
                    "Not Found",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 15,color: Colors.white),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.2199999988079071),
                        shape: const OvalBorder(),
                      ),
                      child: const Icon(Icons.close,color: Colors.white, size: 25),
                    ),
                  ),
                ),

              ],
            )),
    ):const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 0, 91, 148)));
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');

    } else {
      get_videolistScreen();
      // get_data();
    }
  }

  Future<void> get_videolistScreen() async {
        if (widget.title == 'Home') {
          screen_id="1";
        } else if (widget.title == 'Saller') {
          screen_id="0";
        }
        if (widget.title == 'Buyer') {
          screen_id="13";
        }
        if (widget.title == 'News') {
          screen_id="2";
        }
        if (widget.title == 'More') {
          screen_id="0";
        }
        if (widget.title == 'Exhibition') {
          screen_id="5";
        }
        if (widget.title == 'Directory') {
          screen_id="4";
        }
        if (widget.title == 'PremiumMember') {
          screen_id="0";
        }
        if (widget.title == 'Favourite') {
          screen_id="8";
        }
        if (widget.title == 'Videos') {
          screen_id="6";
        }
        if (widget.title == 'Tutorial_Video') {
          screen_id="0";
        }
        if (widget.title == 'ContactUs') {
          screen_id="7";
        }
        if (widget.title == 'Exhibitor') {
          screen_id="10";
        }


    var res = await gettutorialvideo_screen(screen_id);

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];
        link = jsonArray['video_id'] ?? "";
        content=jsonArray['title'] ?? "";
        load=true;
      }else{
        load=true;
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
        setState(() {});
    return jsonArray;
  }
}

class YoutubeViewer extends StatefulWidget {
  final String videoID;

  const YoutubeViewer(this.videoID, {Key? key}) : super(key: key);

  @override
  _YoutubeViewerState createState() => _YoutubeViewerState();
}

class _YoutubeViewerState extends State<YoutubeViewer> {
  late final YoutubePlayerController controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoID,
      params: const YoutubePlayerParams(
        enableCaption: false,
        showVideoAnnotations: false,
        playsInline: false,
        showFullscreenButton: true,
        pointerEvents: PointerEvents.auto,
        showControls: true,
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = YoutubePlayer(
      controller: controller,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: player,
    );
  }
}

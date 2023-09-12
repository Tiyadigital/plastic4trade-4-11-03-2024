import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Plastic4trade/model/Getmybusinessprofile.dart';
import 'package:Plastic4trade/model/getUserProfile.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:Plastic4trade/screen/Bussinessverification.dart';
import 'dart:io' as io;
import 'dart:ui';
import 'package:Plastic4trade/screen/EditBussinessProfile.dart';
import 'package:Plastic4trade/screen/Logindetail.dart';
import 'package:Plastic4trade/screen/socialmedia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Plastic4trade/utill/constant.dart';
import '../api/api_interface.dart';
import '../constroller/GetBussinessTypeController.dart';
import '../constroller/GetUserProfileController.dart';
import '../constroller/Getmybusinessprofile.dart';
import 'package:Plastic4trade/model/getUserProfile.dart' as user;
import 'package:image_cropper/image_cropper.dart';
import 'dart:io' show Platform;
import '../model/common.dart';
import '../widget/MainScreen.dart';

class Bussinessinfo extends StatefulWidget {
  const Bussinessinfo({Key? key}) : super(key: key);

  @override
  State<Bussinessinfo> createState() => _BussinessinfoState();
}

class _BussinessinfoState extends State<Bussinessinfo> {
  var _formKey = GlobalKey<FormState>();
  PickedFile? _imagefiles;
  final ImagePicker _picker = ImagePicker();
  io.File? file;
  CroppedFile? _croppedFile;
  String? path;
  bool isprofile=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checknetowork();
    //file=io.File(constanst.getuserprofile.)
  }

  Future<void> checknetowork()  async {
    final connectivityResult =
    await Connectivity()
        .checkConnectivity();

    if (connectivityResult ==
        ConnectivityResult.none) {
      Fluttertoast.showToast(
          msg: 'Internet Connection not available');
      isprofile=true;
    } else {
      getBussinessProfile();
     //           get_data();
    }
  }

  @override
  Widget build(BuildContext context) {
    return initwidget();
  }
  Future<bool> _onbackpress(BuildContext context) async {


    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainScreen(4)));

    return Future.value(true);
  }
  Widget initwidget() {
    return WillPopScope(
      onWillPop: () => _onbackpress(context),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xFFDADADA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            title: Text('Profile Settings',
                softWrap: false,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Metropolis',
                )),
            leading: InkWell(
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainScreen(4)));
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          body: isprofile? Container(
              child: Column(
            children: [
              Container(
                //height: 400,
                margin: EdgeInsets.all(50.0),
                child: SafeArea(
                    top: true,
                    left: true,
                    right: true,
                    maintainBottomViewPadding: true,
                    child: Column(
                      children: [
                        path != null
                            ? imageprofile(context)
                            : imageprofile1(context),
                      ],
                    )),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 8.0, 0.0),
                  child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditBussinessProfile()));
                          },
                          child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditBussinessProfile()));
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            height: 60,
                                            child: Center(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: const [
                                                  Align(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20.0),
                                                      child: Text('Business Info',
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')),
                                                    ),
                                                  ),
                                                ]))),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditBussinessProfile()));
                                          },
                                          child: Image.asset(
                                            'assets/forward.png',
                                            height: 18,
                                            width: 50,
                                          ),
                                        )
                                      ]))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Bussinessverification()));
                          },
                          child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Bussinessverification()));
                                },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          height: 60,
                                          child: Center(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                Align(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                        'Business Verification',
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-Black.otf')),
                                                  ),
                                                ),
                                              ]))),
                                      Image.asset(
                                        'assets/forward.png',
                                        height: 18,
                                        width: 50,
                                      )
                                    ]),
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => socialmedia()));
                          },
                          child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => socialmedia()));
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            height: 60,
                                            child: Center(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                  Align(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20.0),
                                                      child: Text(
                                                          'Social Media URL',
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')),
                                                    ),
                                                  ),
                                                ]))),
                                        Image.asset(
                                          'assets/forward.png',
                                          height: 18,
                                          width: 50,
                                        )
                                      ]))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginDetail()));
                          },
                          child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginDetail()));
                                  },
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            height: 55,
                                            child: Center(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                  Align(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20.0),
                                                      child: Text('Login Details',
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')),
                                                    ),
                                                  ),
                                                ]))),
                                        Image.asset(
                                          'assets/forward.png',
                                          height: 18,
                                          width: 50,
                                        )
                                      ]))),
                        ),
                      ])),
            ],
          )): Center(
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
                  : Container())
      ),
    );
  }

  Widget imageprofile(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 100.0,
            backgroundImage: file != null
                ? FileImage(file!)
                : NetworkImage(path!) as ImageProvider,
            //: AssetImage('assets/Ellipse 1.png') as ImageProvider,
            //File imageFile = File(pickedFile.path);

            backgroundColor: Color.fromARGB(255, 240, 238, 238),
          ),
          Positioned(
            bottom: 3.0,
            right: 5.0,
            child: Container(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 0, 91, 148),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context, builder: (context) => bottomsheet());
                  },
                  child: ImageIcon(AssetImage('assets/Vector (1).png')),
                )),
          ),
        ],
      ),
    );
  }

  Widget imageprofile1(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 60.0,
            backgroundImage: _imagefiles != null
                ? FileImage(file!)
                : AssetImage('assets/Ellipse 1.png') as ImageProvider,
            //File imageFile = File(pickedFile.path);

            backgroundColor: Color.fromARGB(255, 240, 238, 238),
          ),
          Positioned(
            bottom: 3.0,
            right: 5.0,
            child: Container(
                width: 40,
                height: 33,
                child: FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 0, 91, 148),
                  onPressed: () {
                    /* showModalBottomSheet(
                        context: context, builder: (context) => bottomsheet());*/
                  },
                  child: ImageIcon(AssetImage('assets/Vector (1).png')),
                )),
          ),
        ],
      ),
    );
  }

  getBussinessProfile() async {

    getUserProfile getprofile = getUserProfile();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    print(_pref.getString('user_id').toString());
    print(_pref.getString('api_token').toString());
    var res = await getuser_Profile(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());
    print(res);

    if (res['status'] == 1) {
      getprofile = getUserProfile.fromJson(res);

      var jsonarray = res['user'];

      print(jsonarray['image_url']);
      path = jsonarray['image_url'];
      _pref.setString('userImage',path!).toString();
      constanst.image_url=_pref.getString('userImage').toString();
     // _pref.setString('userImage',constanst.image_url.toString());
      isprofile=true;
      // for (var data in jsonarray) {

      setState(() {});

      // buss.add(record);
      // }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    // setState(() {});
    // print(constanst.btype_data);
  }
  void _onLoading(BuildContext context) {
   // BuildContext dialogContext=context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        //dialogContext = context; // Store the context in a variable
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child:  SizedBox(
            width: 300.0,
            height: 150.0,
            child: Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 7.0,
                  color:   Color.fromARGB(255, 0, 91, 148),
                ),
              ),
            ),
          ),/*Container(
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
                      *//*  Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          child: Center(
                            child: Text(
                              "loading.. wait...",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),*//*
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

    Future.delayed(const Duration(seconds: 2), () {
      print('exit');
      Navigator.of(context).pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
    });
  }
  void get_data() async {
    GetBussinessTypeController bt = await GetBussinessTypeController();
    constanst.bt_data = bt.getBussiness_Type();

    constanst.bt_data!.then((value) {
      if (value != null) {
        for (var item in value) {
          constanst.btype_data.add(item);
        }
      }
    });

    // setState(() {});
    print(constanst.btype_data);
  }



  Widget bottomsheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takephoto(ImageSource.camera);
                  },
                  icon:
                      Icon(Icons.camera, color: Color.fromARGB(255, 0, 91, 148)),
                  label: Text(
                    'Camera',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image, color: Color.fromARGB(255, 0, 91, 148)),
                  label: Text(
                    'Gallary',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void takephoto(ImageSource imageSource) async {
    final pickedfile = await _picker.getImage(source: imageSource);


    _imagefiles = pickedfile!;
    //file = io.File(_imagefiles!.path);
    file = await _cropImage(imagefile: io.File(_imagefiles!.path));
    Saveimage();
    Navigator.of(context).pop();

   /* setState(() async {


      // print('image path : ');
      // print(_imagefiles!.path);
    });*/
  }

  Future<io.File?> _cropImage({required io.File imagefile}) async {
    if (_imagefiles != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: _imagefiles!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Color.fromARGB(255, 0, 91, 148),
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ]);
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });

        return io.File(croppedFile.path);
      }
    } else {
      return null;
    }
  }

  Saveimage() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(_pref.getString('user_id').toString());

    var res = await saveProfile(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(), file);
    /* 'userId':userId,'userToken':userToken,'business_name':business_name,'business_type':business_type,'location':location,'longitude':longitude,'longitude':latitude,'other_mobile1':other_mobile1,'country':country,
    'countryCode':countryCode,
    'business_phone':business_phone,'business_type':business_type,'city':city,'email':email,'website':website,'about_business':about_business,
    'profilePicture':file,'gst_tax_vat':gst_tax_vat,'state':state*/

    print(res);
    if (res['status'] == 1) {
     /* Fluttertoast.showToast(msg: 'Profile Update ');*/
      //_onLoading(context);
      Fluttertoast.showToast(msg: 'Profile Update ');
      getBussinessProfile();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));
    } else {
      // Fluttertoast.showToast(msg: res['message']);
    }
  }
}

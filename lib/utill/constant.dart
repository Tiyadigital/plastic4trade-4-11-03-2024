import 'dart:core';
import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:Plastic4trade/model/GetCategory.dart' as cat;
import 'package:Plastic4trade/model/GetBusinessType.dart' as bt;
import 'package:Plastic4trade/model/GetCategoryType.dart' as type;
import 'package:Plastic4trade/model/GetCategoryGrade.dart' as grade;
import 'package:Plastic4trade/model/Getmybusinessprofile.dart' as profile;
import 'package:Plastic4trade/model/getUserProfile.dart' as user_profile;
import 'package:Plastic4trade/model/GetColors.dart' as color;
import 'package:Plastic4trade/model/GetUnit.dart' as unit;
import '../model/ChatMessage.dart';
import 'package:Plastic4trade/model/getannualcapacity.dart' as cat;
import 'package:Plastic4trade/model/Getbusiness_document_types.dart'
    as doc_type;

class constanst {
  static String usernm = "";
  static String count = "0";
  static String Bussiness_nature = "";
  static String Bussiness_nature_name = "";
  static String Product_Capcity_name = "";
  static String Document_type_name = "";
  static String select_Bussiness_nature = "";
  static List<String> lstBussiness_nature = [];
  static List<String> lstBussiness_nature_name = [];
  static List<String> selectcategory_id = [];
  static List<String> selectbusstype_id = [];
  static List<String> selectgrade_id = [];
  static List<String> selectcolor_id = [];
  static List<String> selectcolor_name = [];
  static String select_color_id = "";
  static String select_color_name = "";
  static String select_cat_id = "";
  static String select_product_cap_id = "";
  static String select_document_type_id = "";
  static String select_cat_name = "";
  static int? select_cat_idx;
  static int? select_product_cap_idx;
  static int? select_document_type_idx;
  static String select_type_id = "";
  static int? select_type_idx;
  static String select_type_name = "";
  static String select_grade_id = "";
  static List<String> select_grade_name = [];
  static int? select_grade_idx;
  static String Product_color = "";
  static int? select_prodcolor_idx;
  static int? select_prodcap_idx;
  static String select = "";
  static String api_token = "";
  static String fcm_token = "";
  static String android_device_id = "";
  static String APNSToken = "";
  static String devicename = "";
  static String ios_device_id = "";
  static String userid = "";
  static int step = 0;
  static int appopencount = 1;
  static int appopencount1 = 1;
  static List<io.File> imagesList = <io.File>[];
  static int notification_count = 0;
  static String post_type = "";
  static String productId = "";
  static String redirectpage = "";
  static List<String> imagelist = [];
  static List<cat.Annual> production_cap = [];
  static List<ChatMessage> messages = [
    ChatMessage(
        messageContent: "Hello, Will",
        userType: "receiver",
        msgtype: "text",
        fillname: ""),
    ChatMessage(
        messageContent: "How have you been?",
        userType: "receiver",
        msgtype: "text",
        fillname: ""),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu? ",
        userType: "sender",
        msgtype: "text",
        fillname: ""),
    ChatMessage(
        messageContent: "ehhhh, doing OK.",
        userType: "receiver",
        msgtype: "text",
        fillname: ""),
    ChatMessage(
        messageContent: "hello What are you doing Today?????",
        userType: "receiver",
        msgtype: "text",
        fillname: ""),
    ChatMessage(
        messageContent: "Is there any thing wrong?",
        userType: "sender",
        msgtype: "text",
        fillname: ""),
  ];

// get Category
  static List<cat.Result> catdata = [];
  static List<IconData> itemsCheck = [];
  static List<IconData> category_itemsCheck = [];
  static List<IconData> category_itemsCheck1 = [];
  static List<IconData> bussiness_type_itemsCheck = [];
  static List<IconData> Type_itemsCheck = [];
  static List<IconData> Type_itemsCheck1 = [];
  static List<IconData> Grade_itemsCheck = [];
  static List<IconData> Grade_itemsCheck1 = [];
  static List<IconData> Color_itemsCheck = [];
  static List<IconData> Prodcap_itemsCheck = [];
  static List<IconData> Document_type_itemsCheck = [];
  static Future<List<cat.Result>>? cat_data;
  static List<String> select_categotyId = [];
  static List<String> select_categotyType = [];
  static List<String> select_inserestlocation = [];
  static List<doc_type.Types> doc_typess = [];

  // get Busssiness
  static List<bt.Result> btype_data = [];
  static Future<List<bt.Result>>? bt_data;

  // Category Type
  static List<type.Result> cat_type_data = [];
  static Future<List<type.Result>>? cat_typedata;
  static List<String> select_typeId = [];

  // Category Grade

  static List<grade.Result> cat_grade_data = [];
  static Future<List<grade.Result>>? cat_gradedata;
  static List<String> select_gradeId = [];

  static List<String> select_state = [];
  static List<String> select_country = [];

  // Get Bussiness Profile

  static bool isprofile = false;
  static bool iscategory = false;
  static bool istype = false;
  static bool isgrade = false;
  static Future<profile.Getmybusinessprofile?>? getmyprofile;
  static Future<user_profile.User?>? getuserprofile;

  // Get Colors

  static List<color.Result> colordata = [];
  static List<IconData> colorsitemsCheck = [];
  static Future<List<color.Result>>? color_data;

  static List<String> color_name_list = [];
  static List<String> color_id_list = [];

  // Get Unit

  static List<String> unitdata = [];
  static Future<List<String>>? unit_data;

  static String lat = "";
  static String log = "";
  static String location = "";
  static String date = "";
  static String? image_url;

  ///Manage Notification redirection
  static bool isFromNotification = false;
  static String notificationtype="";
  static String notiuser="";
  static String notipostid="";
  static String notypost_type="";
}

import 'package:flutter/widgets.dart';

// ignore: camel_case_types
class files_Updater{
  final String name;
  final String filekey;
  final String user;
  final String date;
  final String url;
  final String icon;
  String size;
  String desc;
files_Updater({
  @required this.name,
  @required this.filekey,
  @required this.user,
  @required this.date,
  @required this.url,
  @required this.icon,
  this.size,
  this.desc
  }
);
}
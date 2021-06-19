
import 'dart:io';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fstore/models/fileclass.dart';
import 'package:intl/intl.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';


// ignore: must_be_immutable
class UpdateAll extends StatefulWidget {
  // ignore: non_constant_identifier_names
  List<files_Updater> Allfiles = [];
  List<files_Updater> pfiles = [];
  UpdateAll(this.Allfiles, this.pfiles);
  @override
  _UpdateAllState createState() => _UpdateAllState();
}

TextEditingController filenameController = TextEditingController();
TextEditingController descController = TextEditingController();
File file;

class _UpdateAllState extends State<UpdateAll> {
  String filetest1 = "";
  String filetest = "";
  var choosen;
  String type;
  TextEditingController checkcontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  String check;
  String errormessage = "File name is required";
  String errormessage2 = "Describe File";
  bool filenameisgiven = false;
  bool isdescgiven = false;
  bool isfileseelected = false;
  bool alertbox = false;
  File myfile ;
  bool change = false;
  int radio = 0;
 
 @override
  void initState() {
    super.initState();
    radio = 0;
  }

  void myradio(int val){
    setState(() {
      radio = val;
    });
  }
  void showuploaded(){
  SuccessAlertBox(
      context: context,
      title: "Succesful",
      messageText: "File Succesfully Uploaded"
      );
      setState(() {
        change = false;
      });
      mydispose();
  }

  void checkextension() {  
    if(checkcontroller.text.isNotEmpty)
    {
      if (checkcontroller.text.contains(".")){
      int i = checkcontroller.text.length;
      int j = checkcontroller.text.indexOf(".");
      type = checkcontroller.text.substring(j, i);
      if (type.length > 3 && filetest1.contains(type)) {
        setState(() {
          errormessage = null;
            filenameisgiven = true;
        });
      } else {
        setState(() {
          errormessage = "Add valid extension for ex: .pdf, .doc, .png";
        });
      }
      }
      else{
        setState(() {
          errormessage = "Add valid extension for ex: .pdf, .doc, .png";
        });
      }
    }
  }

  void checkdesc(){
    if(desccontroller.text.isNotEmpty)
    {
      if(desccontroller.text.length<30)
      {
        setState(() {
        errormessage2 = "Description Should Have At Least 30 Charascters";
      });
      }
      else {
        setState(() {
          errormessage2 = null;
          isdescgiven = true;
        });
      }
    }
    else {
      setState(() {
        errormessage2 = "Describe File";
      });
      
    }
  }

  Future<void> choosefile() async {
      FilePickerResult result = await FilePicker.platform.pickFiles();
    int i, j;
      file = File(result.files.single.path);
          setState(() {
            filetest = file.toString();
             i = filetest.lastIndexOf("/");
             j = filetest.length;
             filetest = filetest.substring(i+1,j-1);
             filetest1 = filetest;
          });
      setState(() {
        isfileseelected = true;
      });
      checkextension();   
  }
String key= '';
  // ignore: non_constant_identifier_names
  Future<void> file_uploader() async {
    setState(() {
      change = true;
    });
    var res = await Amplify.Auth.getCurrentUser();
        if(radio==1){
        key = new DateTime.now().toString() + 
        "user:" + res.username   + 
        "desc:" + desccontroller.text + 
        "fname:" + checkcontroller.text +
        "private:" + "false" ;
        }
        else {
         key = new DateTime.now().toString() + 
        "user:" + res.username   + 
        "desc:" + desccontroller.text + 
        "fname:" + checkcontroller.text + 
        "private:" + "true" ;
        }     
      S3UploadFileOptions options =
          S3UploadFileOptions(accessLevel: StorageAccessLevel.guest);
        // ignore: unused_local_variable
        UploadFileResult result = await Amplify.Storage.uploadFile(
            key: key, local: file, options: options);
        GetUrlResult res2 = await Amplify.Storage.getUrl(key: key);
      final newfile = files_Updater(name: checkcontroller.text, filekey: key, user: res.username, 
      date: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(), 
      url: res2.url, 
      desc: desccontroller.text,
      icon: checkcontroller.text.substring(checkcontroller.text.indexOf(".")+1, checkcontroller.text.length)
      );
      setState(() {
        if(newfile.filekey.contains("false"))
        {
          widget.Allfiles.add(newfile);
        }
        else
        {
          widget.pfiles.add(newfile);
        }
                
      });   
   showuploaded();   
  }

  void mydispose() {   
    checkcontroller.clear();
    desccontroller.clear();
    setState(() {
      filetest1 = '';
      errormessage = "File name is required";
      errormessage2 = "Describe File"; 
    });
  }

  
  @override
  Widget build(BuildContext mycontext) {
    return Scaffold(
      body:
    ListView(
      children: [
        Center(
          child: Column(
            children: [
              Container(
                  width: 300,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                  child: MaterialButton(
                    color: Colors.black,
                    onPressed: () {
                     choosefile();
                    },
                    child: Text("Choose File", style: TextStyle(color:Colors.white, fontSize: 17.5),),
                  )),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Text('$filetest1'),
                  ),
                  Container(
                width: 300,
                child: TextField(
                    cursorHeight: 20.0,
                    onChanged: (value) {
                      checkextension();
                    },
                    style: TextStyle(fontWeight: FontWeight.bold),
                    controller: checkcontroller,
                    decoration: InputDecoration(
                      errorText: errormessage,
                      labelText: "Filename",
                    )),
              ),
              Container(
                width: 300,
                child: TextField(
                    cursorHeight: 20.0,
                    onChanged: (value) {
                      checkdesc();
                    },
                    maxLength: 100,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    controller: desccontroller,
                    decoration: InputDecoration(
                      errorText: errormessage2,
                      labelText: "Add Description For The File",
                    )),
              ),
                  Center(
                    child: 
                  RadioListTile(
                      value: 1,
                      groupValue: radio,
                      subtitle: Text("Accessible To Everyone"),
                      onChanged: (val) {
                        myradio(val);
                        print(radio);
                      },
                      title: Text("Public"),
                      activeColor: Colors.black,
                       )),
                  Center(
                    child:RadioListTile(
                      value: 2,
                      groupValue: radio, 
                      subtitle: Text("Keep To Yourself"),
                      onChanged: (val) {
                        myradio(val);
                        print(radio);
                      },
                      title: Text("Private"),
                      activeColor: Colors.black,
                       )
                    ),  
                    Container(
                      child: errormessage==null && errormessage2==null && radio > 0? 
                      (change ? CircularProgressIndicator(
                      backgroundColor: Colors.black,) : MaterialButton(
                        color: Colors.black,
                        onPressed: (){
                          file_uploader();
                        },
                      child: Text("Upload", style: TextStyle(color:Colors.white),),
                      )
                    )  :  Container(
                  ))       
            ],
          ),
        )
      ],
    ));
  }
}

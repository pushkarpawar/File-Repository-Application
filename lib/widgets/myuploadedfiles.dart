import 'dart:math';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fstore/models/fileclass.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
List<files_Updater> myfiles;
// ignore: must_be_immutable
class MyUploadfiles extends StatefulWidget {
  List<files_Updater> myfiles = [];
  MyUploadfiles(this.myfiles);

  @override
  _MyUploadfilesState createState() => _MyUploadfilesState();
}

class _MyUploadfilesState extends State<MyUploadfiles> {

  @override
  void initState() { 
    super.initState();
    getusername();
  }
  
  List<files_Updater> partfile = [];
  
  void insertfile(String username){
    setState(() {
    widget.myfiles.forEach((element) {
      if(element.filekey.contains(username))
      {
        partfile.add(element);
      }
    });  
    });
  }
  String username;
  Future<void> getusername() async {
    var res = await Amplify.Auth.getCurrentUser();
        setState(() {
          username = res.username;
        });
        if(res.username!=null){
          insertfile(username);
        }
  }

  Future<void> deletefile(String key) async {
            try {
                RemoveResult res = await Amplify.Storage.remove(
                  key: key,
                );
              } catch (e) {
                print(e.toString());
              }

              setState(() {
                widget.myfiles.removeWhere((e) => e.filekey == key);
              });
  }

  Future<void> download(String name, String url)
 async {
   final status = Permission.storage.request();
    if(status.isGranted != null){
      final externalDir = await getExternalStorageDirectory();
     FlutterDownloader.enqueue(
     url: url, 
     savedDir: externalDir.path,
     fileName: name,
      showNotification: true,
      openFileFromNotification: true,
     );
    }
    else{
      print("Permision Denied");
    }
   
 }

 void share(BuildContext context, String url){
    final RenderBox box = context.findRenderObject();
    final String text = url;
    Share.share(text, subject: "CLOUDFIREFILESHARING", sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,);
  }

  static String formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(2)) +
        ' ' +
        suffixes[i];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
            title: Text(
                "CLOUD-FILE",
                style:
                    TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: 25),
              ),
             centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
                children: partfile.map((e) {
                 return Card(
                   elevation: 10.0,
                      color: Colors.grey,
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: Image.asset("images/" + e.icon + ".png", height: 40, width: 40,)
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: 250,
                                          child: Text(
                                            e.name,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 250,
                                          alignment: Alignment.centerLeft,
                                          child: Text(e.date),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: Builder(
                                          builder: (mycontext) => IconButton(
                                              icon: Icon(Icons.more_vert),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    context: mycontext,
                                                    builder: (builder) {
                                                      return new Container(
                                                        child: new Wrap(
                                                          children: <Widget>[
                                                            new ListTile(
                                                              leading: new Icon(
                                                                  Icons.download_outlined, color: Colors.black, size: 30),
                                                              title: new Text(
                                                                  'Download', style: TextStyle(fontWeight: FontWeight.bold)),
                                                              onTap: () => {
                                                                 download(e.name, e.url)
                                                              },
                                                            ),
                                                            new ListTile(
                                                              leading: new Icon(
                                                                  Icons.share_sharp, color: Colors.black, size: 30),
                                                              title: new Text(
                                                                  'Share', style: TextStyle(fontWeight: FontWeight.bold)),
                                                              onTap: () => {
                                                                share(context,e.url)
                                                              },
                                                            ),
                                                            new ListTile(
                                                              leading: new Icon(
                                                                  Icons.delete, color: Colors.black, size: 30),
                                                              title: new Text(
                                                                  'Delete', style: TextStyle(fontWeight: FontWeight.bold)),
                                                              onTap: () => {
                                                                deletefile(e.filekey)
                                                              },
                                                            ),
                                                          ],
                                                      ),
                                                      );
                                                    });
                                              })),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 325,
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: Text(e.desc),
                                )
                              ],
                            )
                          ],
                        ),
                      ));
                      }).toList()
              ),
        ],
      )
    );
  }
}

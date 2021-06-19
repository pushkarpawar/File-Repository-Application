import 'dart:math';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fstore/widgets/Updateall.dart';
import 'package:fstore/widgets/myuploadedfiles.dart';
import 'package:fstore/widgets/privatefile.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'SigninPage.dart';
import './models/fileclass.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

List<files_Updater> allfiles = [];
List<files_Updater> pallfiles = [];

class _DashboardPageState extends State<DashboardPage> {
  void signOut() {
    try {
      Amplify.Auth.signOut();
      setState(() {
        allfiles = null;
      });
      gotosigninPage();
    } catch (e) {
      print(e);
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void createSnackBar(String message) {
    final snackBar =
        new SnackBar(content: new Text(message), backgroundColor: Colors.black);
    // ignore: deprecated_member_use
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  void gotosigninPage() {
    Navigator.pop(context);
    ///Navigator.pushReplacement(
      //  context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  String username, _name, _filekey, _user, _date, _size2, _url, _desc; int _size, index = 0;
  bool showwait = true;
  bool listed = false;
 

  void initState() {
    super.initState();
    getusername();
    setState(() {
      allfiles = [];
    });
  listallfiles();
  }

  void listallfiles() async {
            try {
                ListResult res = await Amplify.Storage.list();
                // ignore: unused_local_variable
                int i, j;
                for(i=0;i<=res.items.length;i++)
                { 
                        _filekey =res.items[i].key; 
                        _size = res.items[i].size;
                       try {
                        GetUrlResult result =
                                await Amplify.Storage.getUrl(key: _filekey);
                              _url = result.url;
                            } catch (e) {   
                      }
                      int p = _filekey.lastIndexOf("user:");
                      int q = _filekey.lastIndexOf("desc:");
                      int z = _filekey.lastIndexOf("fname:");
                      int l = _filekey.lastIndexOf("private:");
                      
                      _user = _filekey.substring(p+5,q);
                      _date = _filekey.substring(0,p);
                      _desc = _filekey.substring(q+5,z);
                      _name = _filekey.substring(z+6,l);

                      formatBytes(_size);
                      final newfile = files_Updater(name: _name, size: _size2, filekey: _filekey, user: _user, date: _date, 
                      url: _url, desc: _desc, icon: _name.substring(_name.indexOf(".")+1, _name.length));
                      setState(() {
                        if(newfile.filekey.contains("false"))
                        {
                          allfiles.add(newfile);
                        }
                        else{
                          pallfiles.add(newfile);
                      }
                        listed = true;
                      });    
                }
                setState(() {
                   showwait = false;
                });
                
              } catch (e) {
                print(e);
              }
  }

  Future<void> getusername() async {
      var res = await Amplify.Auth.getCurrentUser();
        setState(() {
          username = res.username;
        });
  }

 Future<void> download(String name, String url) async {
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
  
    void formatBytes(int bytes) {
    
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    setState(() {
      _size2 =  ((bytes / pow(1024, i)).toStringAsFixed(2)) +
        ' ' +
        suffixes[i];
    });
    
  }
  
  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        home: Scaffold(
            drawer: Drawer(
              child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              "Hello,\n$username",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            decoration: BoxDecoration(
              color: Colors.amber
            ),
          ),
          ListTile(
            leading: Image.asset('images/folder.png', height: 30, width: 30),
            title: Text('My Uploaded Files',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_)=> MyUploadfiles(allfiles)));
            },
          ),
          ListTile(
            leading: Image.asset('images/folder.png', height: 30, width: 30),
            title: Text('Private Files',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_)=> PrivateFiles(pallfiles)));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.black, size: 30,),
            title: Text('Logout',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            onTap: () => {
              signout(),
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> SignInPage()))
            },
          ),
          
        ],
      ),
            ),
            key: _scaffoldkey,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: Icon(Icons.swipe, color: Colors.black),
              title: Text(
                "CLOUD-FILE",
                style:
                    TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: 25),
              ),
             centerTitle: true,
          actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right:20.0),
            child: GestureDetector(
            child: Icon(Icons.search, color: Colors.black),
            onTap: (){
              showSearch(context: context, delegate: DataSearch());
            },
          )
          ),
        ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) => setState(() => index = value),
              currentIndex: index,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.home,
                      color: Colors.black,
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.cloud_upload_fill,
                        color: Colors.black),
                    label: "Upload"),
              ],
            ),
            body: index == 0 ? ListView(
              children: [
              Column(
                children: allfiles.map((e) {
                 return Card(
                   elevation: 10.0,
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
                                          EdgeInsets.fromLTRB(10, 10, 10, 0),                                         
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
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 5),  
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
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                          width: 250,
                                          alignment: Alignment.centerLeft,
                                          child: Text(e.date.substring(0,19)),
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
      ) : UpdateAll(allfiles,pallfiles)
            ));
  }
}

void signout() {
  try {
    Amplify.Auth.signOut();

  } catch (e) {
    print(e);
  }
}

class DataSearch extends SearchDelegate<String> {

  @override
  List<Widget> buildActions(BuildContext context) {
      return [
        IconButton(icon: Icon(Icons.clear), onPressed: (){
        })
      ];
    }
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(icon: AnimatedIcon
      (icon: AnimatedIcons.menu_arrow,
      progress: transitionAnimation,),
      onPressed: (){
        close(context, null);
      });
    }
    @override
    Widget buildResults(BuildContext context) {
    }
    @override
    Widget buildSuggestions(BuildContext context) {
    final suggestionlist = allfiles.where((e) => e.desc.toLowerCase().contains(query.toLowerCase())).toList();//cities.where((p) => p.contains(query)).toList();
    return ListView(
              children: [
              Column(
                children: suggestionlist.map((e) {
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
                                          child: Text(DateFormat.yMEd()
                                              .add_jms()
                                              .format(DateTime.now())
                                              .toString()),
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
                                                                //download(e.name, e.url)
                                                              },
                                                            ),
                                                            new ListTile(
                                                              leading: new Icon(
                                                                  Icons.share_sharp, color: Colors.black, size: 30),
                                                              title: new Text(
                                                                  'Share', style: TextStyle(fontWeight: FontWeight.bold)),
                                                              onTap: () => {
                                                                //share(context,e.url)
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
      );
  }
}
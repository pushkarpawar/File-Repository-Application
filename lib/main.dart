import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:fstore/waiting.dart';
import 'Dashboard.dart';
import 'SigninPage.dart';
import 'amplifyconfiguration.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool islogged = false;
  int state = 0;
  bool yesdone = false;
  bool say = false;

  void initState() {
    super.initState();
  _configureAmplify();
  }

  @override
  void dispose() { 
    super.dispose();
  }
  Future<void> _configureAmplify() async {
    try {
      var auth = AmplifyAuthCognito();
      var storage = AmplifyStorageS3();
      await Amplify.addPlugins([auth, storage]);
      await Amplify.configure(amplifyconfig);
      setState(() {
        yesdone = true;
      });
  check();
    } catch (e) {
      SnackBar(content: Text(e.message));
    }
  }
Future<void> check() async {
  var res = await Amplify.Auth.fetchAuthSession();
  if(res.isSignedIn){
    setState(() {
      islogged = true;
    });
  }
  dispose();
}
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: yesdone ? (islogged ? DashboardPage() : SignInPage()) : waitingPage()
    );
  }
}

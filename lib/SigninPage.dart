import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'Dashboard.dart';
import 'Recoverpassword.dart';
import 'SingupPage.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _showPass = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  int state = 1;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void showPassword() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  Future<void> signinAuth() async {
    setState(() {
      state = 0;
    });

    try {
      final email = emailController.text;
      final password = passwordController.text;
      var signedin =
          await Amplify.Auth.signIn(username: email, password: password);
      if (signedin.isSignedIn) {
        setState(() {
          state = 1;
        });
        gotoDashboard();
      }
    } catch (e) {
      setState(() {
        state = 1;
      });
      createSnackBar(e.message);
    }
  }

  void createSnackBar(String message) {
    final snackBar =
        new SnackBar(content: new Text(message), backgroundColor: Colors.black);
    // ignore: deprecated_member_use
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  void gotoDashboard() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashboardPage()));
  }

  void errormessage() {
    print("error");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
           backgroundColor: Colors.white,
              title: Text(
                "CLOUD-FILE",
                style:
                    TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: 25),
              ),
             centerTitle: true,
        ),
        body: ListView(

          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50, bottom: 50),
                    child: Text("Login to your account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic)),
                    alignment: Alignment.center,
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: 70,
                      width: 300,
                      child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )))),
                  Container(
                      alignment: Alignment.center,
                      height: 70,
                      width: 300,
                      child: TextFormField(
                          obscureText: _showPass,
                          controller: passwordController,
                          decoration: InputDecoration(
                              errorBorder: InputBorder.none,
                              labelText: "Password",
                              suffix: InkWell(
                                child: Icon(Icons.remove_red_eye_sharp),
                                onTap: () {
                                  showPassword();
                                },
                              ),
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )))),
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(right: 30),
                    child: Builder(
                        builder: (mycontext) => TextButton(
                            onPressed: () {
                              Navigator.push(
                                  mycontext,
                                  MaterialPageRoute(
                                      builder: (_) => RecoverpassPage()));
                            },
                            child: Text("Forgot Password?", style: TextStyle(color: Colors.black),))),
                  ),
                  Container(
                      height: 50,
                      child: Builder(
                          builder: (mycontext) => MaterialButton(
                                color: Colors.black,
                                onPressed: () {
                                  signinAuth();
                                },
                                child: state == 1
                                    ? Text(
                                        "Login",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : CircularProgressIndicator(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                              ))),
                  Container(
                      height: 150,
                      alignment: Alignment.bottomCenter,
                      child: Builder(
                        builder: (mycontext) => TextButton(
                            onPressed: () {
                              Navigator.push(
                                  mycontext,
                                  MaterialPageRoute(
                                      builder: (_) => SignUpPage()));
                            },
                            child: Text("Create New Account", style: TextStyle(color: Colors.black))),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

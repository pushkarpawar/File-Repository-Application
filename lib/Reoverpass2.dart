// ignore: implementation_imports
import 'package:amplify_auth_plugin_interface/src/Password/UpdatePasswordResult.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/services.dart';
import 'package:fstore/SigninPage.dart';

import 'Dashboard.dart';

class RecoverPage2 extends StatefulWidget {
  final mail;
  RecoverPage2({Key key, @required this.mail}) : super(key: key);

  @override
  _RecoverPage2State createState() => _RecoverPage2State();
}

class _RecoverPage2State extends State<RecoverPage2> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool _showPass = true;
  int state = 1;
  void showPassword() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  var passwordController = TextEditingController();
  var codeController = TextEditingController();

  Future<void> recoverpassword() async {
    setState(() {
      state = 0;
    });
    final password = passwordController.text;
    final code = codeController.text;
    try {
      print(widget.mail);
      // ignore: unused_local_variable
      UpdatePasswordResult res = await Amplify.Auth.confirmPassword(
        username: widget.mail,
        newPassword: password,
        confirmationCode: code,
      );
      gotoDashboard();
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
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.grey,
            title: Text(
                "CLOUD-FILE",
                style:
                    TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: 25),
              ),
             centerTitle: true,
        ),
        body: ListView(children: [
          Center(
              child: Column(children: [
            Container(
                height: 100,
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _showPass,
                  decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: Icon(Icons.lock),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      suffix: InkWell(
                        child: Icon(Icons.remove_red_eye_sharp),
                        onTap: () {
                          showPassword();
                        },
                      )),
                )),
            Container(
                height: 100,
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Verification Code",
                    prefixIcon: Icon(Icons.lock),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            Container(
                height: 50,
                child: Builder(
                    builder: (mycontext) => MaterialButton(
                          color: Colors.black,
                          onPressed: () {
                            recoverpassword();
                          },
                          child: state == 1
                              ? Text(
                                  "Verify",
                                  style: TextStyle(color: Colors.white),
                                )
                              : CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                        ))),
          ]))
        ]));
  }
}

import './Reoverpass2.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';

class RecoverpassPage extends StatefulWidget {
  RecoverpassPage({Key key}) : super(key: key);

  @override
  _RecoverpassPageState createState() => _RecoverpassPageState();
}

final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
void createSnackBar(String message) {
  final snackBar =
      new SnackBar(content: new Text(message), backgroundColor: Colors.black);
  // ignore: deprecated_member_use
  _scaffoldkey.currentState.showSnackBar(snackBar);
}

class _RecoverpassPageState extends State<RecoverpassPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  var emailController = TextEditingController();
  int state = 1;
  Future<void> resetpass() async {
    final email = emailController.text;
    state = 0;
    try {
      // ignore: unused_local_variable
      var res = await Amplify.Auth.resetPassword(
        username: email,
      );

      gotopage2();
    } catch (e) {
      setState(() {
        state = 1;
      });
      createSnackBar(e.message);
    }
  }

  void gotopage2() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => RecoverPage2(
                  mail: emailController.text,
                )));
  }

  bool _showPass = true;
  void showPassword() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  void createSnackBar(String message) {
    final snackBar =
        new SnackBar(content: new Text(message), backgroundColor: Colors.black);
    // ignore: deprecated_member_use
    _scaffoldkey.currentState.showSnackBar(snackBar);
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
        key: _scaffoldkey,
        body: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 40, bottom: 30),
                    child: Text("You have only 3 reset passwords limits",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic)),
                    alignment: Alignment.center,
                  ),
                  Container(
                    height: 100,
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          prefixIcon: Icon(Icons.email_sharp)),
                    ),
                  ),
                  Container(
                      height: 50,
                      child: Builder(
                          builder: (mycontext) => MaterialButton(
                                color: Colors.black,
                                onPressed: () {
                                  resetpass();
                                },
                                child: state == 1
                                    ? Text(
                                        "Recover",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : CircularProgressIndicator(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                              ))),
                ],
              ),
            )
          ],
        ));
  }
}

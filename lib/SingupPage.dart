import './Verification.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool _showPass = true;
  int state = 1;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Future<void> signupAuth() async {
    final email = emailController.text;
    final password = passwordController.text;
    setState(() {
      state = 0;
    });
    try {
      SignUpResult res = await Amplify.Auth.signUp(
          username: email,
          password: password,
          options: CognitoSignUpOptions(userAttributes: {'email': email}));

      if (res.isSignUpComplete) {
        setState(() {
          state = 1;
        });
        gotoverityPage(email);
      }
    } catch (e) {
      setState(() {
        state = 1;
      });
      createSnackBar(e.message);
    }
  }

  void gotoverityPage(var email) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return VerifyPage(mail: email);
    }));
  }

  void createSnackBar(String message) {
    final snackBar =
        new SnackBar(content: new Text(message), backgroundColor: Colors.black);
    // ignore: deprecated_member_use
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  void showPassword() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Scaffold(
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
                  child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 40, bottom: 30),
                    child: Text("Create your account",
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
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 10.0))))),
                  Container(
                      alignment: Alignment.center,
                      height: 70,
                      width: 300,
                      child: TextFormField(
                          controller: passwordController,
                          obscureText: _showPass,
                          decoration: InputDecoration(
                              errorBorder: InputBorder.none,
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock),
                              suffix: InkWell(
                                child: Icon(Icons.remove_red_eye_sharp),
                                onTap: () {
                                  showPassword();
                                },
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 10.0))))),
                  Container(
                      margin: EdgeInsets.only(top: 20.0),
                      height: 50,
                      child: Builder(
                          builder: (mycontext) => MaterialButton(
                                onPressed: () {
                                  signupAuth();
                                },
                                child: state == 1
                                    ? Text(
                                        "Signup",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : CircularProgressIndicator(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                color: Colors.black,
                              ))),
                  Container(
                      height: 150,
                      alignment: Alignment.bottomCenter,
                      child: Builder(
                        builder: (mycontext) => TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Already have an account", style: TextStyle(color: Colors.black))),
                      ))
                ],
              ))
            ])));
  }
}
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:fstore/SigninPage.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';


// ignore: must_be_immutable
class VerifyPage extends StatefulWidget {
  final mail;
  VerifyPage({Key key, @required this.mail, email}) : super(key: key);

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
 var codeController = TextEditingController();
 int state =1;
 
  Future<void> verifyCode() async {
  final confirmationCode = codeController.text;
  setState(() {
    state = 0;
  });
  try {
  SignUpResult res = await Amplify.Auth.confirmSignUp(
         username: widget.mail,
          confirmationCode: confirmationCode,
        );
        if (res.isSignUpComplete) {
          setState(() {
            state = 1;
          });
            gotodashboardPage();
      }
      
     } catch (e) {
      setState(() {
        state = 1;
      });
      createSnackBar(e.message);
    }
}
final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

void gotodashboardPage(){
  SuccessAlertBox(
      context: context,
      title: "Succesful",
      messageText: "Created Account Successfully\nYou Can Login With Your Email"
      );
 Navigator.pushReplacement(context, 
 MaterialPageRoute(builder: (context)=> SignInPage())
 );
}

 void createSnackBar(String message) {
    final snackBar =
        new SnackBar(content: new Text(message), backgroundColor: Colors.black);
    // ignore: deprecated_member_use
   _scaffoldkey.currentState.showSnackBar(snackBar);
  }
Future<void> resendcode() async {
          try {
      // ignore: unused_local_variable
      var res = await Amplify.Auth.resendSignUpCode(
        username: widget.mail
      );
    } catch (e) {
      createSnackBar(e.message);
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red
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
        body: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    height: 100,
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: "Verification Code",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    prefixIcon: Icon(Icons.mark_email_read_outlined)
                  ),
                ),
              ),
              Container(
                    height: 30,
                    // ignore: deprecated_member_use
                    child: OutlineButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                     resendcode();
                      },
                      child: Text(
                        "Resend Code",
                      ),
                    ),
                  ),
                  Container( 
                    margin: EdgeInsets.only(top: 20),
                    height: 50,
                      child: Builder(builder: 
                      (mycontext)=>MaterialButton(
                        onPressed: () {
                          verifyCode();
                        },
                        child: state == 1
                            ? Text(
                                "Verify",
                                style: TextStyle(color: Colors.white),
                              )
                            : CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                        color: Colors.black,
                      )
                      )
              ),
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

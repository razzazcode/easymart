import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Admin/adminRegister.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController _emailTextEditingControler = TextEditingController();
  final TextEditingController _passwordTextEditingControler = TextEditingController();



  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery
        .of(context)
        .size
        .width,
        _screenHeight = MediaQuery
            .of(context)
            .size
            .height;


    return SingleChildScrollView(

      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            Container(

              alignment: Alignment.bottomCenter,
              child: Image.asset("image/login.png",
                height: 240.0,
                width: 240.0,

              ),
            ),

            Padding(padding: EdgeInsets.all(8.0),
              child: Text(

                "Login To your Account",
                style: TextStyle(

                  color: Colors.white,
                ),

              ),

            ),

            Form(
              key: _formkey,
              child: Column(
                children: [


                  CustomTextField(

                    controller: _emailTextEditingControler,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),

                  CustomTextField(

                    controller: _passwordTextEditingControler,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),


                ],
              ),
            ),

            RaisedButton(
              onPressed: () {
                _emailTextEditingControler.text.isNotEmpty &&
                    _passwordTextEditingControler.text.isNotEmpty
                    ?
                loginUser()
                    : showDialog(context: context,

                    builder: (c) {
                      return ErrorAlertDialog(
                        message: "Please write email and password",);
                    }
                );
              },

              color: Colors.pink,
              child: Text(" Login", style: TextStyle(color: Colors.white),),
            ),


            SizedBox(
              height: 50.0,

            ),

            Container(
              height: 4.0,
              width: _screenwidth * 0.8,
              color: Colors.pink,
            ),

            SizedBox(
              height: 10.0,
            ),

            FlatButton.icon(

              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AdminSignInPage())),
              icon: (Icon(Icons.nature_people, color: Colors.pink,)),
              label: Text(" I am An Admin ", style: TextStyle(
                  color: Colors.pink, fontWeight: FontWeight.bold),),

            ),





            SizedBox(
              height: 10.0,
            ),

            FlatButton.icon(

              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => adminRegister())),
              icon: (Icon(Icons.nature_people, color: Colors.pink,)),
              label: Text(" Register An Admin ", style: TextStyle(
                  color: Colors.pink, fontWeight: FontWeight.bold),),

            ),



















          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser()  async {
    showDialog(context: context,

        builder: (c) {
          return LoadingAlertDialog(message: " Authinticatinc , Please wait",);
        }
    );

    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(
      email: _emailTextEditingControler.text.trim(),
      password: _passwordTextEditingControler.text.trim(),
    ).then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);

      showDialog(
          context: context,

          builder: (c) {
            return ErrorAlertDialog(message: error.message.toString(),);
          }
      );
    });

    if (firebaseUser != null) {
      readData(firebaseUser).then((s){

        Navigator.pop(context);

        Route route = MaterialPageRoute(builder: (c) => StoreHome());

        Navigator.pushReplacement(context, route);


      });
    }
  }

  Future readData(FirebaseUser fUser) async {

    Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot ) async {

      await EcommerceApp.sharedPreferences.setString("uid", dataSnapshot.data[EcommerceApp.userUID]);

      await EcommerceApp.sharedPreferences.setString( EcommerceApp.userEmail,  dataSnapshot.data[EcommerceApp.userEmail]);


      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName,dataSnapshot.data[EcommerceApp.userName]);

      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapshot.data[EcommerceApp.userAvatarUrl]);

      await EcommerceApp.sharedPreferences.setString( EcommerceApp.passWord, _passwordTextEditingControler.text.trim());

      List<String> cartList = dataSnapshot.data[EcommerceApp.userCartList].cast<String>();

      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, cartList);

    }
    );

    }


  }


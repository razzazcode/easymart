import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        flexibleSpace: Container(
        decoration: new BoxDecoration(
        gradient: new LinearGradient(
        colors: [ Colors.pink , Colors.lightGreenAccent ],
        begin: const FractionalOffset(0.0, 0.0),
    end: const FractionalOffset(1.0, 0.0),
    stops: [0.0 , 1.0],
    tileMode: TileMode.clamp,),
    ),
    ),
    title: Text(
    "EasyMart",
    style: TextStyle(fontSize: 55.0 , color: Colors.white, fontFamily: "Signatra") ,
    ),
    centerTitle: true,









    ),
body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{


  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController _admindEmailTextEditingControler = TextEditingController();
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


        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [ Colors.pink , Colors.lightGreenAccent ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0 , 1.0],
            tileMode: TileMode.clamp,),
        ),


        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            Container(

              alignment: Alignment.bottomCenter,
              child: Image.asset("image/admin.png",
                height: 240.0,
                width: 240.0,

              ),
            ),

            Padding(padding: EdgeInsets.all(8.0),
              child: Text(

                "ADMIN",
                style: TextStyle(

                  color: Colors.white, fontSize: 28.0 , fontWeight: FontWeight.bold
                ),

              ),

            ),

            Form(
              key: _formkey,
              child: Column(
                children: [


                  CustomTextField(

                    controller: _admindEmailTextEditingControler,
                    data: Icons.person,
                    hintText: "id",
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

            SizedBox(
              height: 25.0,
            ),//;


            RaisedButton(
              onPressed: () {
                _admindEmailTextEditingControler.text.isNotEmpty &&
                    _passwordTextEditingControler.text.isNotEmpty
                    ?
                loginAdmin()
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
              height: 20.0,
            ),

            FlatButton.icon(

              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AuthenticScreen())),
              icon: (Icon(Icons.nature_people, color: Colors.pink,)),
              label: Text(" I am not Admin ", style: TextStyle(
                  color: Colors.pink, fontWeight: FontWeight.bold),),

            ),
            SizedBox(
              height: 50.0,
            ),

          ],
        ),
      ),
    );
  }

 /* loginAdmin() {

Firestore.instance.collection("admins").getDocuments().then((snapshot){

  snapshot.documents.forEach((result) {

if(result.data["adminname"]  != _admindIdTextEditingControler.text.trim()) {

Scaffold.of(context).showSnackBar(SnackBar(content : Text(" Youe Id Is Not Correct"),));

}

else

if(result.data["password"]  != _passwordTextEditingControler.text.trim()) {

  Scaffold.of(context).showSnackBar(SnackBar(content : Text(" Youe Password Is Not Correct"),));

}


else{


  Scaffold.of(context).showSnackBar(SnackBar(content : Text(" Welcome Dear Admin " + result.data["name"]),));


  setState(() {
    _admindIdTextEditingControler.text = " ";

    _passwordTextEditingControler.text= " ";



  });



  Route route = MaterialPageRoute(builder: (c) => UploadPage());

  Navigator.pushReplacement(context, route);




}

  });

});


  }
*/



  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginAdmin()  async {
    showDialog(context: context,

        builder: (c) {
          return LoadingAlertDialog(message: " Authinticatinc , Please wait",);
        }
    );

    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(
      email: _admindEmailTextEditingControler.text.trim(),
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

        Route route = MaterialPageRoute(builder: (c) => UploadPage());

        Navigator.pushReplacement(context, route);


      });
    }
  }

  Future readData(FirebaseUser fadminUser) async {

    Firestore.instance.collection("admins").document(fadminUser.uid).get().then((dataSnapshot ) async {

      await EcommerceApp.sharedPreferences.setString("adminid", dataSnapshot.data[EcommerceApp.userUID]);

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

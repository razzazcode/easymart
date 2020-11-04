import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
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

  final TextEditingController _admindIdTextEditingControler = TextEditingController();
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

                    controller: _admindIdTextEditingControler,
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
            ),


            RaisedButton(
              onPressed: () {
                _admindIdTextEditingControler.text.isNotEmpty &&
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

  loginAdmin() {

Firestore.instance.collection("admins").getDocuments().then((snapshot){

  snapshot.documents.forEach((result) {

if(result.data["id"]  != _admindIdTextEditingControler.text.trim()) {

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



}

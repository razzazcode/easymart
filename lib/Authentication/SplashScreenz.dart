
import 'dart:async';

import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';

import 'authenication.dart';

class SplashScreenz extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenz>
    with SingleTickerProviderStateMixin {
  Animation<double> opacity;
  AnimationController controller;
  Animation<int> customTween;



/*
  cupertino_icons: ^0.1.2
  cloud_firestore: ^0.13.2+1
  firebase_auth: ^0.15.4
  shared_preferences: ^0.5.6+1
  fluttertoast: ^3.1.3
  image_picker: ^0.6.3+1
  firebase_storage: ^3.1.1
  flutter_staggered_grid_view: ^0.3.0
  provider: ^4.0.4
  path_provider: ^0.5.0+1
  image: ^2.0.7
  intl:

 */












  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 2500), vsync: this);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
     ..addListener(() {
       setState(() {});
      });


  //  customTween = IntTween(
     //   begin: 0, end: 255).animate(controller)..addListener(() {setState(() {});});


    controller.forward().then((_) {

    //  displaySplash();


      navigationPage();
    });




  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }




  /*
  void navigationPage() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => WelcomeBackPage()));
  }
*/
  Widget build(BuildContext context) {
    return Material(
  /*      child: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/gg.jpg'), fit: BoxFit.cover)),*/
      child: Container(
        decoration: BoxDecoration(color: Colors.lightGreenAccent),




        child: SafeArea(
          child: new Scaffold(
            body: Column(









              children: <Widget>[
                Expanded(
                  child: Opacity(



                      opacity: 1 , // opacity.value,
                      child:  Image.asset('images/gg.png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: 'Powered by '),
                          TextSpan(
                              text: 'H2Code ',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    )

    ;
  }

  navigationPage(){

    Timer(Duration(seconds: 1) , () async{


      if( await EcommerceApp.auth.currentUser != null) {


        Route route = MaterialPageRoute(builder: (_)=> StoreHome());
        Navigator.pushReplacement(context, route);


      }

      else
      {
        Route route = MaterialPageRoute(builder: (_)=> AuthenticScreen());
        Navigator.pushReplacement(context, route);


      }



    });



  }


}

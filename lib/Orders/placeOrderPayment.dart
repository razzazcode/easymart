import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/SplashScreenz.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

//import '../main.dart';

class PaymentPage extends StatefulWidget {


  final String adressId ;

  final double totalAmount ;

  PaymentPage({Key key , this.adressId , this.totalAmount, }) : super (key: key);



  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(


child: Container (

  decoration: new BoxDecoration(
    gradient: new LinearGradient(
      colors: [ Colors.pink , Colors.lightGreenAccent ],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 0.0),
      stops: [0.0 , 1.0],
      tileMode: TileMode.clamp,),
  ),

  child: Center(
    child: Column(


      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        Padding(padding: EdgeInsets.all(8.0),

        child: Image.asset("images/cash.png"),



        ),

        SizedBox(height: 10.0 ,),

        FlatButton(


          color: Colors.pink,
          textColor: Colors.white,

          padding: EdgeInsets.all(8.0),

          splashColor: Colors.deepOrange,


          onPressed: ()=> addOrderDetails(),

          child: Text("Place Order Here " , style: TextStyle(fontSize: 30.0),),



        ),
      ],
    ),
  ),
),




    );

  }



  addOrderDetails()   {



    writeOrederDetailsForUser({



      EcommerceApp.addressID: widget.adressId,
      EcommerceApp.totalAmount : widget.totalAmount,

      "orderBy" : EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) ,

      EcommerceApp.productID : EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList) ,

      EcommerceApp.paymentDetails : " Cah on Delivery " ,

EcommerceApp.orderTime : DateTime.now().millisecondsSinceEpoch.toString(),


      EcommerceApp.isSuccess : true ,

    });





    writeOrederDetailsForAdmin({



      EcommerceApp.addressID: widget.adressId,
      EcommerceApp.totalAmount : widget.totalAmount,

      "orderBy" : EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) ,

      EcommerceApp.productID : EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList) ,

      EcommerceApp.paymentDetails : " Cah on Delivery " ,

      EcommerceApp.orderTime : DateTime.now().millisecondsSinceEpoch.toString(),


      EcommerceApp.isSuccess : true ,

    }).whenComplete(() => {


      emptyCartNow()
    });
    



  }




  emptyCartNow(){

    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);

    List tempList =  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);


    Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) )

        .updateData({






      EcommerceApp.userCartList: tempList,

    })
    
    .then((value) {


      EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempList);

      Provider.of<CartItemCounter>(
        context , listen: false
      ).displayResult();

      
    });






    
    Fluttertoast.showToast(msg: "Congratulations , your order has been added ");

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());

    Navigator.pushReplacement(context, route);
    

  }








  Future writeOrederDetailsForUser (Map <String , dynamic > data )  async
  {


    await  EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))

        .collection(EcommerceApp.collectionOrders)

        .document( EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) + data ['orderTime'] )
        .setData(data) ;


  }


  Future writeOrederDetailsForAdmin (Map <String , dynamic > data )  async
  {


    await  EcommerceApp.firestore

        .collection(EcommerceApp.collectionOrders)

        .document( EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) + data ['orderTime'] )
        .setData(data) ;


  }





}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../main.dart';

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


      




    );

  }



  addOrderDetails() {



    writeOrederDetailsForUser({



      EcommerceApp.addressID: widget.adressId,
      EcommerceApp.totalAmount : widget.totalAmount,

      " orderBy" : EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) ,

      EcommerceApp.productID : EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList) ,

      EcommerceApp.paymentDetails : " Cah on Delivery " ,

EcommerceApp.orderTime : DateTime.now().millisecondsSinceEpoch.toString(),


      EcommerceApp.isSuccess : true ,

    });





    writeOrederDetailsForAdmin({



      EcommerceApp.addressID: widget.adressId,
      EcommerceApp.totalAmount : widget.totalAmount,

      " orderBy" : EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) ,

      EcommerceApp.productID : EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList) ,

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

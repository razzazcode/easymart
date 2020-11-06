import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {



  double totalAmount ;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  
totalAmount = 0 ;

Provider.of<TotalAmount>(context , listen: false).display(0);

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      floatingActionButton: FloatingActionButton.extended(

          onPressed: (){
        
         if( EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length == 1 )

           {

             Fluttertoast.showToast(msg: " your cart is Empty ");



           }
        


          else {

            Route route = MaterialPageRoute(builder: (c) => Address (totalAmount : totalAmount));

            Navigator.pushReplacement(context, route);



         }
      },


        label: Text(" Check Out"),
        backgroundColor:  Colors.pinkAccent,

        icon: Icon(Icons.navigate_next),


      ),
      

      appBar:  MyAppBar(),

      drawer:  MyDrawer(),

      body:  CustomScrollView (
        
        
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount , CartItemCounter> (
              
              builder: (context , amountProvider , cartProvider , c ) {
                
                
                return Padding(padding: EdgeInsets.all(8.0) ,
                
                child: Center (
                  child: cartProvider.count ==0
                  
                  ? Container() : 
                  
                  Text( r" Total Price : $" + " ${amountProvider.totalAmount.toString()}" , 
                    style: TextStyle ( color: Colors.black , fontSize: 20.0 , fontWeight: FontWeight.w500),
    
    ),
                  
                  
                ),
                
                );
                
              },
            ),
          ),
          
          StreamBuilder<QuerySnapshot> (
            
            stream: EcommerceApp.firestore.collection("items").
            where("shortInfo" ,  whereIn: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList)).snapshots(),

            builder: (context , snapshot) {

              return !snapshot.hasData

                  ?SliverToBoxAdapter( child: Center( child: circularProgress(),),)
                  :
                  snapshot.data.documents.length ==0
                  ?
                      beginBuildingCart()
                      :
                      SliverList(

                          delegate: SliverChildBuilderDelegate ( (context , index){

                        ItemModel model =  ItemModel.fromJson(snapshot.data.documents[index].data);

                        if( index == 0)
                          {

                            totalAmount = 0 ;

                            totalAmount = model.price  + totalAmount ;

                          }
else {

                          totalAmount = model.price  + totalAmount ;

                        }


if (snapshot.data.documents.length - 1 == index)
  {

    WidgetsBinding.instance.addPostFrameCallback((t) {

      Provider.of<TotalAmount>(context , listen:  false ) .display (totalAmount);

    });



  }

return sourceInfo(model, context , removeCartFunction: ()=> removeItemFromUserCart(model.shortInfo));

                      },
                            childCount: snapshot.hasData ? snapshot.data.documents.length : 0




                      ),
                      );
            },

          )
          
        ],
      ) ,


    );
  }

  removeItemFromUserCart(String shortInfoAsId) {}

  beginBuildingCart() {}
}

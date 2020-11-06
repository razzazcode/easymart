import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Orders//placeOrderPayment.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/wideButton.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget
{


  final double totalAmount ;
  const Address ( {Key key , this.totalAmount} ) : super(key : key);


  @override
  _AddressState createState() => _AddressState();
}


class _AddressState extends State<Address>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(



      child: Scaffold(
        appBar: MyAppBar(),

        floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pink,

            label:Text ( " Add New Address"),
        icon: Icon(Icons.add_location),

        onPressed: () {

          Route route =  MaterialPageRoute (builder: (c) => AddAddress());

        },

        ),
      ),
    );
  }

  noAddressCard() {
    return Card(

    );
  }
}

class AddressCard extends StatefulWidget {



  final AddressModel model;
  final  int currentIndex;
  final int value ;
  final String addressId;
  final double totalAmount ;

  AddressCard ( { Key  key , this.model , this.currentIndex , this.totalAmount , this.addressId , this.value }) : super (key : key ) ;

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(

      child: Card(
        color: Colors.pinkAccent.withOpacity(0.4),


        child: Column(


          children: [


            Row(

              children: [

                Radio(groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.pink,
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                  },

                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),

                      width: screenWidth * 0.8,
                      child: Table(

                        children: [
                          TableRow(
                            children: [

KeyText(

  msg: " Name ",
),
                              Text(widget.model.name),

                            ]
                          ),

                          TableRow(
                              children: [

                                KeyText(

                                  msg: " Phone Number ",
                                ),
                                Text(widget.model.phoneNumber),

                              ]
                          ),
                          TableRow(
                              children: [

                                KeyText(

                                  msg: " Flat Number ",
                                ),
                                Text(widget.model.flatNumber),

                              ]
                          ),

                          TableRow(
                              children: [

                                KeyText(

                                  msg: " City ",
                                ),
                                Text(widget.model.city),

                              ]
                          ),
                          TableRow(
                              children: [

                                KeyText(

                                  msg: " State or Country ",
                                ),
                                Text(widget.model.state),

                              ]
                          ),
                          TableRow(
                              children: [

                                KeyText(

                                  msg: " PIN code ",
                                ),
                                Text(widget.model.pincode),

                              ]
                          ),


                        ],
                      ),


                    ),
                  ],
                )
              ],
            ),


            widget.value == Provider.of <AddressChanger> (context).count

            ? WideButton(

              message: " Proceed",
              
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => PaymentPage(

adressId: widget.addressId,

                  totalAmount : widget.totalAmount,
                ));

                Navigator.push(context, route);

              },
            )
: Container(),
          ],


        ),
      ),
    );
  }}




    class KeyText extends StatelessWidget {

      final String msg;

      KeyText({ Key key , this.msg }) : super( key : key );



  @override
  Widget build(BuildContext context) {




    return Text(

    msg,
    style: TextStyle ( color: Colors.black , fontWeight: FontWeight.bold),
    );
  }
}

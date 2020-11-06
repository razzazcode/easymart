import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAddress extends StatelessWidget {






  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

final cName = TextEditingController();
  final cCity = TextEditingController();

  final cPhoneNumber = TextEditingController();

  final cFlatHomeNumber = TextEditingController();

  final cState = TextEditingController();

  final cPinCode = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(


        key: scaffoldKey,

        appBar: MyAppBar(),

        floatingActionButton: FloatingActionButton.extended(onPressed: (){



    if (formKey.currentState.validate()) {


      final model = AddressModel(

        name: cName.text.trim(),

        phoneNumber: cPhoneNumber.text,
        flatNumber: cFlatHomeNumber.text,
        city: cCity.text.trim(),
        state: cState.text.trim(),
        pincode: cPinCode.text,




      ).toJson();

      // add to firestore

      EcommerceApp.firestore.collection(EcommerceApp.collectionUser).document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))

      .collection(EcommerceApp.subCollectionAddress).

          document(DateTime.now().millisecondsSinceEpoch.toString()).setData(model)

      .then((value) {

        final snack = SnackBar(content: Text (" New Address added Successfully ")) ;

        scaffoldKey.currentState.showSnackBar(snack);

        Fluttertoast.showToast(msg: " address added");
        // hiasd
        FocusScope.of(context).requestFocus(FocusNode());

        formKey.currentState.reset();

      });

    }


        },

            label: Text(" Done"),
          backgroundColor: Colors.pink,

          icon: Icon(Icons.check),



    ),


        body: SingleChildScrollView(

          child: Column(


            children: [

              Align(

                alignment: Alignment.centerLeft,

              child: Padding(

                padding: EdgeInsets.all(8.0),
                
                child: Text (
                  
                  " ADD A NEW ADDRESS" ,
                  
                  style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 20.0),
                  
                  
                  
                ),

                
              ),



              ),
              
              
              
              Form(
                key: formKey,

                child: Column (

                  children: [

MyTextField(

  hint: " Name",
  controller: cName,

),


                    MyTextField(

                      hint: " PHONE NUMBER",
                      controller: cPhoneNumber,

                    ),


                    MyTextField(

                      hint: " FLAT NUMBER OR HOUSE NOMBER",
                      controller: cFlatHomeNumber,

                    ),


                    MyTextField(

                      hint: " CITY ",
                      controller: cCity,

                    ),


                    MyTextField(

                      hint: " Stat / Country",
                      controller: cState,

                    ),

                    MyTextField(

                      hint: " PIN CODE",
                      controller: cPinCode,

                    ),





                  ],
                ),


              ),
            ],
          ),
        ),

      ),
    );
  }
}

class MyTextField extends StatelessWidget {



  final String hint ;

  final TextEditingController controller ;

  MyTextField(
  {
    Key key , this.hint , this.controller ,
}
      ) : super(key : key );



  


  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: EdgeInsets.all(8.0),
      
      child: TextFormField(
        controller: controller,
        
        decoration: InputDecoration . collapsed(hintText: hint),

        validator: (val) => val.isEmpty ?

            " Field cannot be Empty" : null
        ,

        
      ),
      

    );
  }
}

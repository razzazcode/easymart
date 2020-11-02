import 'dart:io';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{
  final TextEditingController _nameTextEditingControler = TextEditingController();

  final TextEditingController _emailTextEditingControler = TextEditingController();
  final TextEditingController _passwordTextEditingControler = TextEditingController();
  final TextEditingController _cpasswordTextEditingControler = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

String userImageUrl = "" ;

File _imageFile;







  @override
  Widget build(BuildContext context) {

    double _screenwidth = MediaQuery.of(context).size.width, _screenHeight = MediaQuery.of(context).size.height;


      return SingleChildScrollView(

        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [


              SizedBox(height: 10.0,),




              InkWell(
                onTap: ()=> print("selected"),
                child: CircleAvatar(

                  radius: _screenwidth * 0.15,

                  backgroundColor: Colors.white,
                  backgroundImage:  _imageFile==null ?  null : FileImage(_imageFile),

                  child: _imageFile == null
                    ? Icon(Icons.add_photo_alternate , size: _screenwidth * 0.15 , color: Colors.grey,)

                      : null,

                ),
              ),




              SizedBox(height: 8.0,)
              font(
                key formkey,
                child: Column(
                  Custom
                ),
              )
            ],

          ),
        ),
      )
  }
}


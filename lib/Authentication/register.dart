import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingControler = TextEditingController();

  final TextEditingController _emailTextEditingControler = TextEditingController();
  final TextEditingController _passwordTextEditingControler = TextEditingController();
  final TextEditingController _cpasswordTextEditingControler = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String userImageUrl = "";

  File _imageFile;

  PickedFile image2;
File image2camera;

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


            SizedBox(height: 10.0,),


            InkWell(
              onTap: _showMyDialog,
              child: CircleAvatar(

                radius: _screenwidth * 0.15,

                backgroundColor: Colors.white,
                backgroundImage: image2camera == null ? null : FileImage(
                    image2camera),

                child: image2camera == null
                    ? Icon(Icons.add_photo_alternate, size: _screenwidth * 0.15,
                  color: Colors.grey,)

                    : null,

              ),
            ),


            SizedBox(height: 8.0,),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(

                    controller: _nameTextEditingControler,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),


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

                  CustomTextField(

                    controller: _cpasswordTextEditingControler,
                    data: Icons.local_activity,
                    hintText: "confirm password",
                    isObsecure: true,
                  ),


                ],
              ),
            ),

            RaisedButton(
              onPressed: () {
                uploadAndSaveImage();
              },

              color: Colors.pink,
              child: Text(" Sign Up", style: TextStyle(color: Colors.white),),
            ),


            SizedBox(
              height: 30.0,

            ),

            Container(
              height: 4.0,
              width: _screenwidth * 0.8,
              color: Colors.pink,
            ),

            SizedBox(
              height: 15.0,
            ),

          ],

        ),
      ),
    );
  }


  Future<void> captureAndPickImage() async {
  //  _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    image2 =  await ImagePicker().getImage(
      source: ImageSource.camera
    );


    image2camera = File(image2.path);

  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please select a profile picture.'),
                Text('Would you like to select from gallery or to Capture a new photo ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Gallery'),
              onPressed: () {
                captureAndPickImage();
              //  Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Camera'),
              onPressed: () {
                _imageFile =  ImagePicker.pickImage(source: ImageSource.gallery) as File;              },
            ),
          ],
        );
      },
    );
  }








  Future<void> uploadAndSaveImage() async {
    if (image2camera == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: " Please select an Image",);
          }
      );
    }
      else { _passwordTextEditingControler.text ==
        _cpasswordTextEditingControler.text

        ? _emailTextEditingControler.text.isNotEmpty &&
        _passwordTextEditingControler.text.isNotEmpty

        && _cpasswordTextEditingControler.text.isNotEmpty &&
        _nameTextEditingControler.text.isNotEmpty


        ? uploadToStorage()

        :

        displayDialog("please write correct information")
        : displayDialog("Passwords do not match");

  }
}

displayDialog( String msg)
{
  
  showDialog(
      context: context,

  builder: (c)
  {
    return ErrorAlertDialog(message: msg,);
  }
  );
}






  uploadToStorage() async 
  {
    
    showDialog(context: context ,
    builder: (c) {

      return LoadingAlertDialog( message: " Registering user, Please WAIT",);
    }

    );

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();


    StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(image2camera);
    
    
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    
    await taskSnapshot.ref.getDownloadURL().then((urlImage){
      userImageUrl = urlImage ;

 _registerUser();

    
      
    } );


  }

  
  FirebaseAuth _auth = FirebaseAuth.instance;
  
  void _registerUser() async {
    FirebaseUser firebaseUser;
    
    await _auth.createUserWithEmailAndPassword
      (

      email: _emailTextEditingControler.text.trim(),

        password: _passwordTextEditingControler.text.trim(),

    )

        .then((auth) {
      firebaseUser = auth.user;
    })

        .catchError((error){

      Navigator.pop(context);

      showDialog(
        context : context,

        builder: (c)
          {

            return ErrorAlertDialog(message: error.message.toString(),);
          }
      );


});


    if(firebaseUser!= null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {

        Navigator.pop(context);

        Route route = MaterialPageRoute(builder: (c) => StoreHome());

Navigator.pushReplacement(context, route);


      });
    }
    }

    Future saveUserInfoToFireStore(FirebaseUser fUser) async
    {





      Firestore.instance.collection("users").document(fUser.uid).setData({

        "uid" : fUser.uid ,
        "email" : fUser.email,
        "name" : _nameTextEditingControler.text.trim(),
        "url" : userImageUrl,
        "password" : _passwordTextEditingControler.text.trim(),
        "userType": "client",
        EcommerceApp.userCartList: ["garbagrValue"]

      });

      
      
      await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
      await EcommerceApp.sharedPreferences.setString("email", fUser.email);
      await EcommerceApp.sharedPreferences.setString( EcommerceApp.userName, _nameTextEditingControler.text.trim());
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
      await EcommerceApp.sharedPreferences.setString( EcommerceApp.passWord, _passwordTextEditingControler.text.trim());
      await EcommerceApp.sharedPreferences.setString( EcommerceApp.userType, "client");


    }
}




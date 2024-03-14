// import 'dart:ui';

// import 'package:firebase/api/status_util.dart';
// import 'package:firebase/custom_ui/customelevatedbutton.dart';
// import 'package:firebase/custom_ui/customform.dart';
// import 'package:firebase/helper/helper.dart';
// import 'package:firebase/provider/passwordvisibility.dart';
// import 'package:firebase/util/string_const.dart';
// import 'package:firebase/view/login.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';

// class SignUp extends StatefulWidget {
//   SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final RegExp emailRegex =
//       RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//               final RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');


//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//         //  appBar: AppBar(title: Text("Login",style: TextStyle(color: Colors.orange))),
//         body: Consumer<SignUpProvider>(
//       builder: (context, passwordVisibility, child) => Stack(children: [
//         Container(
//           color: Colors.orange,
//         ),
//         SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.3,
//                 color: Colors.transparent,
//                 child: Image(image: AssetImage("asset/images/logo.png")),
//               ),
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.7,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(40),
//                       topLeft: Radius.circular(40)),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                     padding: const EdgeInsets.only(left: 15, right: 15),
//                     child: ui(passwordVisibility) //ui ya call garya xa

//                     ),
//               ),
//             ],
//           ),
//         ),
//         loader(passwordVisibility), // function5 ya call vaxa
//        // loader()  function4 loader lai ya call garya 

//         // Container(
//         //   child: spinkitcircle(context),// function3 lai call garya
//         // )
//       ]),
//     )
//     );
//   }

//   sizedBox(double value) {
//     //functon1
//     return SizedBox(
//       height: value,
//     );
//   }

//   Widget ui(Passwordvisibility passwordVisibility) {
//     //  function2
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           sizedBox(40),
//           CustomForm(
//             label: namestr,
//             prefixIcon: Icon(Icons.person, color: colorstr),
//             keyboardType: TextInputType.name,
//             onChanged: (p0) {
//               passwordVisibility.name = p0;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return nameValidationStr;
//               } else {
//                 return null;
//               }
//             },
//           ),
//           sizedBox(20),
//           CustomForm(
//             hintText: addressStr,
//             prefixIcon: Icon(Icons.location_on, color: colorstr),
//             onChanged: (p0) {
//               passwordVisibility.address = p0;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return addressValidationStr;
//               } else {
//                 return null;
//               }
//             },
//           ),
//           sizedBox(20),
//           CustomForm(
//             hintText: contactStr,
//             prefixIcon: Icon(Icons.phone, color: colorstr),
//             keyboardType: TextInputType.number,
//             onChanged: (p0) {
//               passwordVisibility.contact = p0;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return contactValidationStr;
//               } else if (value.length != 10) {
//                 return passwordlengthStr;
//               } else {
//                 return null;
//               }
//             },
//           ),
//           sizedBox(20),
//           CustomForm(
//             hintText: emailStr,
//             prefixIcon: Icon(Icons.email, color: colorstr),
//             onChanged: (p0) {
//               passwordVisibility.email = p0;
//             },
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return emailStr;
//               } else if(!emailRegex.hasMatch(value)){
//                               return 'Please enter a valid email';

//                          }
//                 return null;
              
//             },
//           ),
//           sizedBox(20),
//           CustomForm(
//               hintText: passwordStr,
//               prefixIcon: Icon(Icons.lock, color: colorstr),
//               onChanged: (p0) {
//                 passwordVisibility.password = p0;
//               },
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return passwordValidationStr;
//                 } else if(!passwordRegex.hasMatch(value)) {
//                               return 'Must have 8 char(include uppercase,lowercase & number)';

//                         }
//                   return null;
              
//               },
//               obscureText:
//                   passwordVisibility.showPassword == true ? false : true,
//               suffixIcon: passwordVisibility.showPassword == true
//                   ? IconButton(
//                       onPressed: () {
//                         passwordVisibility.Visibility(false);
//                       },
//                       icon: const Icon(Icons.visibility))
//                   : IconButton(
//                       onPressed: () {
//                         passwordVisibility.Visibility(true);
//                       },
//                       icon: const Icon(Icons.visibility_off))),
//           sizedBox(20),
//           CustomElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   passwordVisibility.saveStudentData().then((value) {
//                     if(passwordVisibility.saveStudentStatus==NetworkStatus.sucess){
//                         Helper.snackBarMessage("Successfully Registered", context);
//                         Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginUi()));
//                       }else if(passwordVisibility.saveStudentStatus==NetworkStatus.error){
//                         Helper.snackBarMessage(passwordVisibility.errormessage!, context);
//                       }
//                   });
//                 }
//               },
//               child: Text(SignupStr),
//               primary: colorstr,
//               onprimary: Colors.white)
//         ],
//       ),
//     );
//   }
//   loader(Passwordvisibility passwordVisibility){ //function 5
//     if(passwordVisibility.saveStudentStatus==NetworkStatus.loading){
//       return Helper.backdropFilter(context);
      
//     }else{
//       return SizedBox();
//     }
//   }
  
// }
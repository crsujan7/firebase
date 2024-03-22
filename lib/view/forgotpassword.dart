// import 'package:email_otp/email_otp.dart';
// import 'package:firebase_2/customui/custombutton.dart';
// import 'package:firebase_2/provider/signupprovider.dart';
// import 'package:firebase_2/view/otp_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../customui/customtextformfield.dart';
// import '../helper/helper.dart';
// import '../util/string_const.dart';
// import 'login.dart';
// import 'otp.dart';

// class ForgetPasswordPage extends StatefulWidget {
//   ForgetPasswordPage({super.key});

//   @override
//   State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
// }

// class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
//   final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

//   final _formKey = GlobalKey<FormState>();
//   EmailOTP myauth = EmailOTP();

//   final TextEditingController _emailController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   Future passwordReset() async {
//     try {
//       await FirebaseAuth.instance
//           .sendPasswordResetEmail(email: _emailController.text.trim());
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//               content: Text("Password reset link sent! Check your email"));
//         },
//       );
//     } on FirebaseAuthException catch (e) {
//       print(e);
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text(e.message.toString()),
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(children: [
//       Container(
//         color: Colors.orange,
//       ),
//       Consumer<SignUpProvider>(
//         builder: (context, signUpProvider, child) => SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.6,
//                 color: Colors.transparent,
//               ),
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.4,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(40),
//                       topLeft: Radius.circular(40)),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
//                   child: Form(
//                     key: _formKey,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 8.0, right: 8),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Forget Password?",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 20,
//                                     color: Colors.orange)),
//                             Row(
//                               children: [
//                                 Text("Already have an account?"),
//                                 SizedBox(
//                                   width: width(0.015, context),
//                                 ),
//                                 GestureDetector(
//                                   child: Text("Login Now",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14,
//                                           decoration: TextDecoration.underline,
//                                           color: Colors.orange)),
//                                   onTap: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => Login(),
//                                         ));
//                                   },
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: height(0.018, context),
//                             ),
//                             CustomForm(
//                               controller: signUpProvider.emailController,
//                               hintText: "Email Address",
//                               keyboardType: TextInputType.emailAddress,
//                               prefixIcon: Icon(
//                                 Icons.email,
//                                 color: Colors.orange,
//                               ),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return emailValidationStr;
//                                 } else if (!emailRegex.hasMatch(value)) {
//                                   return 'Please enter a valid email';
//                                 } else {
//                                   return null;
//                                 }
//                               },
//                             ),
//                             SizedBox(height: height(0.03, context)),
//                             SizedBox(
//                               width: width(0.88, context),
//                               height: width(0.14, context),
//                               child: Custombutton(
//                                 onPressed: () async {
//                                   // if (_formKey.currentState!.validate()) {
//                                   //  passwordReset();
//                                   // }
//                                   if (_formKey.currentState!.validate()) {
//                                     myauth.setConfig(
//                                       appEmail: 'sujansapkota9841@gmail.com',
//                                       appName: 'CarRental',
//                                       userEmail:
//                                           signUpProvider.emailController.text,
//                                       otpLength: 6,
//                                       otpType: OTPType.digitsOnly,
//                                     );
//                                     if (await myauth.sendOTP() == true) {
//                                       OtpDataClass otpData = OtpDataClass(
//                                           email: signUpProvider
//                                               .emailController.text,
//                                           emailOTP: myauth);
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => OtpPage(
//                                             otpDataClass: otpData,
//                                           ),
//                                         ),
//                                       );
//                                       Helper.snackBarMessage(
//                                           "Otp sent", context);
//                                     } else {
//                                       Helper.snackBarMessage(
//                                           "Otp sent failed", context);
//                                     }
//                                   }
//                                 },
//                                 child: Text("Submit"),
//                                 onPrimary: Colors.white,
//                                 primary: Colors.orange,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     ]));
//   }

//   height(value, context) {
//     return MediaQuery.of(context).size.height * value;
//   }

//   width(value, context) {
//     return MediaQuery.of(context).size.width * value;
//   }
// }

// class OtpDataClass {
//   String? email;
//   EmailOTP? emailOTP;
//   OtpDataClass({this.email, this.emailOTP});
// }

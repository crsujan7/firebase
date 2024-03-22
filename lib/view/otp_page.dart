// import 'dart:async';

// import 'package:email_otp/email_otp.dart';
// import 'package:firebase_2/customui/custombutton.dart';
// import 'package:firebase_2/provider/signupprovider.dart';
// import 'package:firebase_2/view/forgotpassword.dart';
// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:provider/provider.dart';

// import '../helper/helper.dart';

// class OtpPage extends StatefulWidget {
//   OtpDataClass? otpDataClass;

//   OtpPage({Key? key, this.otpDataClass}) : super(key: key);

//   @override
//   _OtpPageState createState() => _OtpPageState();
// }

// class _OtpPageState extends State<OtpPage> {
//   TextEditingController otpController = TextEditingController();
//   Timer? _resendTimer;
//   int _resendDelay = 15;
//   bool continueResending = true;

//   void startResendTimer() {
//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_resendDelay > 0) {
//           _resendDelay--;
//         } else {
//           _resendTimer?.cancel();
//         }
//       });
//     });
//   }

//   void repeatCenterCode() {
//     setState(() {
//       _resendDelay = 30;
//     });
//     startResendTimer();
//   }

//   void resendOTP() async {
//     widget.otpDataClass?.emailOTP?.setConfig(
//       appEmail: 'bbijay020@gmail.com',
//       appName: 'futsal',
//       userEmail: widget.otpDataClass?.email,
//       otpLength: 6,
//       otpType: OTPType.digitsOnly,
//     );

//     await widget.otpDataClass?.emailOTP?.sendOTP();

//     repeatCenterCode();
//     Helper.snackBarMessage("Otp sent", context);
//   }

//   @override
//   void initState() {
//     startResendTimer();
//     super.initState();
//     // Start the resend timer when the widget is initialized
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<SignUpProvider>(
//         builder: (context, passwordvisibility, child) => SafeArea(
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.only(left: 10),
//                       child: Icon(
//                         Icons.arrow_back_ios,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     "Otp Verification",
//                     style: const TextStyle(
//                       fontSize: 18.0,
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.1,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "   Code has been sent to \n${widget.otpDataClass?.email}",
//                     style: const TextStyle(
//                       fontSize: 16.0,
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: PinCodeTextField(
//                   appContext: context,
//                   controller: otpController,
//                   length: 6,
//                   obscureText: false,
//                   animationType: AnimationType.fade,
//                   pinTheme: PinTheme(
//                     shape: PinCodeFieldShape.underline,
//                     fieldHeight: 50,
//                     fieldWidth: 40,
//                     activeFillColor: Colors.white,
//                     activeColor: Colors.black,
//                     inactiveColor: Colors.black,
//                     selectedFillColor: Colors.white,
//                     selectedColor: Colors.black,
//                     disabledColor: Colors.grey,
//                   ),
//                   animationDuration: const Duration(milliseconds: 300),
//                   onChanged: (value) {
//                     print("Entered OTP: $value");
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: width(0.88, context),
//                 height: width(0.14, context),
//                 child: Custombutton(
//                   child: Text("Verify"),
//                   onPrimary: Colors.white,
//                   primary: Colors.orange,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   onPressed: () async {
//                     try {
//                       // Verify OTP and handle the result
//                       bool isOtpVerified = await widget.otpDataClass?.emailOTP
//                           ?.verifyOTP(otp: otpController.text);

//                       if (isOtpVerified) {
//                         Helper.snackBarMessage("verified", context);
//                       } else {
//                         Helper.snackBarMessage("wrong ootp", context);
//                       }
//                     } catch (e) {
//                       Helper.snackBarMessage("error", context);
//                     }
//                   },
//                   text: ("proceed"),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       _resendDelay > 0
//                           ? "Please wait $_resendDelay seconds to resend code."
//                           : "Resend code",
//                       style: const TextStyle(
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     if (_resendDelay == 0)
//                       GestureDetector(
//                         onTap: () {
//                           // Start the resend loop when the user taps "Resend"
//                           continueResending = true;
//                           resendOTP();
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Did not Receive Code?",
//                               style: const TextStyle(
//                                 fontSize: 16.0,
//                               ),
//                             ),
//                             Text(
//                               "Resend",
//                               style: TextStyle(
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   height(value, context) {
//     return MediaQuery.of(context).size.height * value;
//   }

//   width(value, context) {
//     return MediaQuery.of(context).size.width * value;
//   }
// }

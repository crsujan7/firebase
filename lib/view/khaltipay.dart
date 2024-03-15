import 'package:firebase_2/customui/customtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';

class PayMent extends StatefulWidget {
  const PayMent({super.key});

  @override
  State<PayMent> createState() => _PayMentState();
}

class _PayMentState extends State<PayMent> {
  TextEditingController _textEditingControllerAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Khalti Payment Gateway"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          children: [
            Container(
              child: TextFormField(
                controller: _textEditingControllerAmount,
                decoration: InputDecoration(hintText: 'Amount'),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text("Pay with Khalti")),
          ],
        ),
      ),
    );
  }

  _sendToKhalti(BuildContext context) {
    // FlutterKhalti _flutterKhalti = FlutterKhalti.configure(

    // )
  }
}

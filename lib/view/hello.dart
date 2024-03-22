import 'package:firebase_2/helper/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mapsgoogle extends StatefulWidget {
  const Mapsgoogle({super.key});

  @override
  State<Mapsgoogle> createState() => _MapsgoogleState();
}

class _MapsgoogleState extends State<Mapsgoogle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          IconButton(
              onPressed: () {
                Helper.launchMaps("Budol,Banepa");
              },
              icon: Icon(Icons.location_city_outlined))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Product {
  final String title;
  final String description;
  final String image;
  final dynamic price;
  final List<Color> colors;
  final String category;
  final double rate;
  final String vehicletype;
  final dynamic numberOfPeople;

  Product({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.colors,
    required this.category,
    required this.rate,
    required this.vehicletype,
    required this.numberOfPeople,
  });
}

final List<Product> products = [
  Product(
    title: "Volkswagen",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/golf.png",
    price: "Rs5000/Day",
    colors: [],
    category: "Golf",
    vehicletype: "automatic",
    numberOfPeople: '5 Seats',
    rate: 4.8,
  ),
  Product(
    title: "Ford",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/v-2.png",
    price: "Rs3500/Day",
    colors: [],
    vehicletype: "manual",
    numberOfPeople: '4 Seats',
    category: " Sedan ",
    rate: 4.8,
  ),
  Product(
    title: " Hyundai",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/i30n.png",
    price: "Rs4500/Day",
    colors: [],
    vehicletype: "automatic",
    numberOfPeople: '4 Seats',
    category: "HatchBack-Automatic",
    rate: 3.8,
  ),
  Product(
    title: " Toyota",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/yaris.png",
    price: "Rs4200/Day",
    colors: [],
    vehicletype: "manual",
    numberOfPeople: '5 Seats',
    category: "Hatch Back",
    rate: 4.5,
  ),
  Product(
    title: " Renault",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/v-3.png",
    price: "Rs5000/Day",
    colors: [],
    vehicletype: "manual",
    numberOfPeople: '5 Seats',
    category: "CUV",
    rate: 4.3,
  ),
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var product in products)
                Container(
                  height: 50, // Set a fixed height for each ListTile
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                  child: ListTile(
                    title: Text(product.title),
                    subtitle: Text(product.description),
                    leading: Image.asset(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

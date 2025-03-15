import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageScreen();
}

class HomePageScreen extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> passedData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;



    // Accessing individual arguments
    final String ID = passedData['id'];
    final String EMAIL = passedData['email'];

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.green, fontFamily: "Nunito"),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Dashboard",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
              "Welcome",
              style: TextStyle(fontSize: 60),
            )),
            Text(
              "$EMAIL",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loginsignupapp/signup.dart';
import 'custom_widgets/my_input_fields.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green,
          fontFamily: "Nunito"),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var time = DateTime.now();
  var datePicked;
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  String? EmailError = null, PasswordError = null;
  bool passwordToggle = true;

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width; // Gives the width
    double Screenheight =
        MediaQuery.of(context).size.height; // Gives the height
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Login",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: ScreenWidth,
          height: Screenheight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Center(
                  child: Image.asset(
                    'assets/images/usericon.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputField(
                  HintText: 'Please enter your email',
                  LabelText: 'Email',
                  callbackAction: () {},
                  InputController: EmailController,
                  Endicon: Icon(null),
                  ErrorValidation: null,
                  ErrorText: EmailError,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputField(
                  HintText: 'Please enter password',
                  LabelText: 'Password',
                  callbackAction: () {
                    passwordToggle = !passwordToggle;
                    setState(() {});
                  },
                  InputController: PasswordController,
                  Endicon: Icon(
                    passwordToggle! ? Icons.visibility : Icons.visibility_off,
                  ),
                  ErrorValidation: null,
                  ErrorText: PasswordError,
                  Secure: passwordToggle,
                ),
              ),
              Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Already have account "),
                  TextButton(
                    child: Text("Create Account",
                        style: TextStyle(color: Colors.green[900])),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    bool Password = false, ConfirPass = false;
                    bool ValidEmail = EmailValidator.validate(
                        EmailController.text.toString());
                    if (ValidEmail != true) {
                      EmailError = "Invalid Email";
                      setState(() {});
                      print("InValid Email");
                    } else if (ValidEmail == true) {
                      EmailError = null;
                      setState(() {});
                    }
                    if (PasswordController.text.toString().length < 8) {
                      PasswordError = "Enter valid password";
                      Password = false;
                      setState(() {});
                    } else if (PasswordController.text.toString().length > 8) {
                      Password = true;
                      PasswordError = null;
                      setState(() {});
                    }
                    if (ValidEmail == true && Password == true) {
                      Uri url = Uri.http(
                          "192.168.30.81", "/flutterloginsignup/api.php", {
                        'login': ''
                      }); //intead of 192.168.30.81 use your own server address
                      var response = await http.post(url, body: {
                        'email': EmailController.text,
                        'password': PasswordController.text
                      });
                      if (response.statusCode == 200) {
                        // EmailController.clear();
                        // PasswordController.clear();
                        List<dynamic> JsonResponse = jsonDecode(response.body);
                        Map<String, dynamic>? user;
                        for (var items in JsonResponse) {
                          user = items;
                          print('Id ${user!['id']}');
                          print(user!['email']);
                        }
                        print(JsonResponse);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (c) => HomePage(),
                                settings: RouteSettings(arguments: {
                                  'id': '${user!['id']}',
                                  'email': '${user!['email']}'
                                })));
                      }
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.green),
                  ),
                  child: Text("Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),

              // ElevatedButton(
              //     onPressed: () async {
              //       DateTime? datepicked = await showDatePicker(
              //         context: context,
              //         initialDate: DateTime.now(),
              //         firstDate: DateTime(2020),
              //         lastDate: DateTime(2030),
              //       );
              //       if (datepicked != null) {
              //         print(datepicked.day);
              //         datePicked = datepicked.toString();
              //       }
              //     },
              //     child: Text("Current time")),
              // ElevatedButton(
              //     onPressed: () async {
              //       TimeOfDay? timepicked = await showTimePicker(
              //           context: context, initialTime: TimeOfDay.now());
              //       if (timepicked != null) {
              //         print(timepicked.toString());
              //       }
              //     },
              //     child: Text("Time picker")),
            ],
          ),
        ),
      ),
    );
  }
}

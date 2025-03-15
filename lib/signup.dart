import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_widgets/my_input_fields.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignUpPage> {
  var time = DateTime.now();
  var datePicked;
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final ConfirmPasswordController = TextEditingController();
  String? EmailError = null, PasswordError = null, ConfirmPasswordError = null;
  bool passwordToggle = true;

  @override
  void initState() {
    InitializeState();
  }

  void InitializeState() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width; // Gives the width
    double Screenheight =
        MediaQuery.of(context).size.height; // Gives the height
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.green, fontFamily: "Nunito"),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Signup",
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
                      "Signup",
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
                    callbackAction: () {
                      print("password toggle clicked");
                    },
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
                    Endicon: Icon(passwordToggle!
                        ? Icons.visibility
                        : Icons.visibility_off),
                    ErrorText: PasswordError,
                    Secure: passwordToggle,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputField(
                      HintText: 'Please enter password again',
                      LabelText: 'Confirm Password',
                      callbackAction: () {
                        passwordToggle = !passwordToggle;
                        setState(() {});
                      },
                      InputController: ConfirmPasswordController,
                      Endicon: Icon(passwordToggle!
                          ? Icons.visibility
                          : Icons.visibility_off),
                      ErrorText: ConfirmPasswordError,
                      Secure: passwordToggle,
                    )),

                Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have account "),
                        TextButton(
                          child: Text("Login",
                              style: TextStyle(color: Colors.green[900])),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
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
                        PasswordError = "Enter valid password min 8 characters";
                        Password = false;
                        setState(() {});
                      } else if (PasswordController.text.toString().length >
                          8) {
                        Password = true;
                        PasswordError = null;
                        setState(() {});
                      }
                      if (PasswordController.text.toString() !=
                          ConfirmPasswordController.text.toString()) {
                        ConfirmPasswordError = "Password mismatch";
                        ConfirPass = false;
                        setState(() {});
                      } else if (PasswordController.text.toString() ==
                          ConfirmPasswordController.text.toString()) {
                        ConfirmPasswordError = null;
                        ConfirPass = true;
                        setState(() {});
                      }
                      if (ValidEmail == true &&
                          Password == true &&
                          ConfirPass == true) {
                        CreateUser(EmailController.text.toString(),
                            PasswordController.text.toString());
                        Uri url = Uri.http("192.168.30.81",
                            "/flutterloginsignup/api.php", {'sign': ''});
                        var response = await http.post(url, body: {
                          'email': EmailController.text,
                          'password': PasswordController.text
                        });
                        if (response.statusCode == 200) {
                          EmailController.clear();
                          PasswordController.clear();
                          ConfirmPasswordController.clear();
                        }
                        print('Response status: ${response.statusCode}');
                        print('Response body: ${response.body}');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Colors.green),
                    ),
                    child: Text("Signup",
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
      ),
    );
  }

  void CreateUser(String Email, String Pass) {}
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sfeflutter/view/components/background.dart';
import 'package:sfeflutter/view/register/register.dart';
import 'dart:convert';
import 'package:sfeflutter/view/home/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  bool _isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Background(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
                          fontSize: 36),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "Username"),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: const Text(
                      "Forgot your passwordd?",
                      style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: emailController.text == "" ||
                              passwordController.text == ""
                          ? null
                          : () {
                              setState(() {
                                _isLoading = true;
                              });
                              signIn(emailController.text,
                                  passwordController.text);
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        fixedSize: Size(size.width * 0.5, 50.0),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        side: const BorderSide(color: Colors.transparent),
                        elevation: 12,
                        shape: const StadiumBorder(),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 255, 136, 34),
                              Color.fromARGB(255, 255, 190, 78)
                            ])),
                        padding: const EdgeInsets.all(0),
                        child: const Text(
                          "LOGIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()))
                      },
                      child: const Text(
                        "Don't Have an Account? Sign up",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA)),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  signIn(String email, pass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': pass,
    };

    var jsonResponse = null;

    var response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/login"),
      body: data,
    );

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        preferences.setString("token", jsonResponse['access_token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MainPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }
}

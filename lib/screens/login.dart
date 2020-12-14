import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/auth.dart';
import 'package:weather_app/utility.dart';
import 'package:weather_icons/weather_icons.dart';

class Login extends StatefulWidget {
  const Login({
    Key key,
  }) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Builder(builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    WeatherIcons.day_sunny,
                    size: 70,
                    color: Colors.yellowAccent,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Weather Now',
                    style: GoogleFonts.raleway(fontSize: 35, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(hintText: "Email"),
                    controller: _emailController,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    obscureText: true,
                    // validator: (val) => val.length < 6 ? 'Password too short.' : null,
                    controller: _passwordController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: getWidth(context) * .8,
                    child: RaisedButton(
                      onPressed: () async {
                        final String returnVal = await authProvider.signIn(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        if (returnVal == "Success") {
                          _emailController.clear();
                          _passwordController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(returnVal),
                            duration: const Duration(seconds: 2),
                          ));
                        }
                      },
                      child: const Text("Sign In"),
                    ),
                  ),
                  SizedBox(
                    width: getWidth(context) * .8,
                    child: RaisedButton(
                      onPressed: () async {
                        final String returnVal = await authProvider.createAccount(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        if (returnVal == "Success") {
                          _emailController.clear();
                          _passwordController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(returnVal),
                            duration: const Duration(seconds: 2),
                          ));
                        }
                      },
                      child: const Text("Create Account"),
                    ),
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                      onTap: () async {
                        final String returnVal = await authProvider.signInAnonymously();
                        if (returnVal == "Success") {
                          _emailController.clear();
                          _passwordController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(returnVal),
                            duration: const Duration(seconds: 2),
                          ));
                        }
                      },
                      child: const Text("Anonymous Login"))
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

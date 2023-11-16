import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hunarmand_app/screens/sign_up_screen.dart';
import 'package:hunarmand_app/screens/worker_client_screen.dart';
import 'package:ndialog/ndialog.dart';

import 'auth.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final auth = AuthUser();

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN PLEASE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Image.asset('assets/images/ic_launcher.png'),

                  TextFormField(
                    obscureText: false,
                    validator: (value){
                      final bool emailValid =
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value!);

                      if(value!.isEmpty)
                      {
                        return "*required";
                      }
                      else if(!emailValid)
                      {
                        return "Enter correct email";
                      }
                    },
                    controller: emailController,
                    decoration:  InputDecoration(
                      hintText: 'Email',
                      suffixIcon: Icon(Icons.email_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "*required";
                      }
                      else if(value.length <= 6)
                      {
                        return 'password must be greater than 6 characters';
                      }
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                  ),
              // TextFormField(
              //   obscureText: _isObscure,
              //   decoration: InputDecoration(
              //     labelText: 'Password',
              //     suffixIcon: IconButton(
              //       icon: Icon(
              //         _isObscure ? Icons.visibility : Icons.visibility_off,
              //       ),
              //       onPressed: () {
              //         setState(() {
              //           _isObscure = !_isObscure;
              //         });
              //       },
              //     ),
              //   ),
              // ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {

                        if(_formKey.currentState!.validate())
                        {
                          auth.loginUser(emailController.text, passwordController.text, context);
                        }

                        // request to firebase auth





                        // try {
                        //   FirebaseAuth auth = FirebaseAuth.instance;
                        //
                        //   UserCredential userCredential =
                        //   await auth.signInWithEmailAndPassword(
                        //       email: email, password: password);
                        //
                        //   if (userCredential.user != null) {
                        //     progressDialog.dismiss();
                        //     // ignore: use_build_context_synchronously
                        //     Navigator.of(context).pushReplacement(
                        //         MaterialPageRoute(builder: (context) {
                        //           return const WorkerClientScreen();
                        //         }));
                        //   }
                        // } on FirebaseAuthException catch (e) {
                        //   progressDialog.dismiss();
                        //
                        //   if (e.code == 'user-not-found') {
                        //     Fluttertoast.showToast(msg: 'User not found');
                        //   } else if (e.code == 'wrong-password') {
                        //     Fluttertoast.showToast(msg: 'Wrong password');
                        //   }
                        // } catch (e) {
                        //   Fluttertoast.showToast(msg: 'Something went wrong');
                        //   progressDialog.dismiss();
                        // }

                      },
                      child: const Text('Login',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20) ,)),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not Registered Yet?'),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const SignUpScreen();
                            }));
                          },
                          child: const Text('Register Now',style:TextStyle(fontSize: 15))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


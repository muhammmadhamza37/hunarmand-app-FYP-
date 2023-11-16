
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

import 'auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController hourPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final auth = AuthUser();
  String? databaseButton;
  String? skillButton;
  File? imagePath;
  bool imageSelected = false;
  var list = [
    'Worker',
    'Client'
  ];


  var skillSet = [
    'Mechanic',
    'Plumber',
    'Electrician',
  ];


  void selectImage(int i)async
  {
    if(i == 1)
      {
        final pickedImage =await ImagePicker.platform.pickImage(source: ImageSource.gallery);
        if(pickedImage == null) return;
        setState(() {
          Navigator.pop(context);
          imagePath = File(pickedImage.path);
          imageSelected = true;
        });
      }
    else
      {
        final pickedImage =await ImagePicker.platform.pickImage(source: ImageSource.camera);
        if(pickedImage == null) return;
        setState(() {
          Navigator.pop(context);
          imagePath = File(pickedImage.path);
          imageSelected = true;
        });
      }

  }


  showDialogue()async
  {

    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
              [

                TextButton(onPressed: (){
                  selectImage(1);
                }, child: Text("Select Gallery", style: TextStyle(fontSize: size.height * 0.03),),),
                TextButton(onPressed: (){
                  selectImage(2);
                }, child: Text("Select Camera", style: TextStyle(fontSize: size.height * 0.03),),)


              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up Please'),
      ),
        body:   Padding(
          padding: const EdgeInsets.all(10),
          child:SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  GestureDetector(
                    onTap: (){
                      showDialogue();
                    },
                    child: Stack(
                      children:
                      [
                       imageSelected ? CircleAvatar(
                          radius: size.height * 0.08,
                          backgroundImage: FileImage(File(imagePath!.path)),
                        ) : CircleAvatar(
                          radius: size.height * 0.08,
                          backgroundImage: NetworkImage("https://louisville.edu/enrollmentmanagement/images/person-icon/image"),
                        ),

                        Positioned(
                          right: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: size.height * 0.03,
                                backgroundColor: Colors.blueGrey,
                                child: IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt, size: size.height * 0.035, color: Colors.white,)))),
                      ],
                    ),
                  ),

                  DropdownButton<dynamic>(
                      underline: SizedBox(),
                      hint: Padding(
                          padding: EdgeInsets.only(right: size.height * 0.28, left: size.height * 0.01),
                          child: Text("Select Role", style: TextStyle(fontSize: size.height * 0.02),)),
                      value: databaseButton,
                      items: list.map((dynamic e){
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        );
                      }).toList(),
                      onChanged: (valu){
                        setState(() {
                          databaseButton = valu;
                        });
                      }
                  ),
                  Visibility(
                    visible: databaseButton == "Client" ? false : true,
                      child: DropdownButton<dynamic>(
                      underline: SizedBox(),
                      hint: Padding(
                          padding: EdgeInsets.only(right: size.height * 0.28, left: size.height * 0.01),
                          child: Text("Select Skills", style: TextStyle(fontSize: size.height * 0.02),)),
                      value: skillButton,
                      items: skillSet.map((dynamic e){
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        );
                      }).toList(),
                      onChanged: (valu){
                        setState(() {
                          skillButton = valu;
                        });
                      }
                  ),
                  ),

                  const  SizedBox(height: 15,),
                    TextFormField(
                      validator: (value){
                        if(value!.isEmpty)
                          {
                            return "*required";
                          }
                      },
                      controller: firstNameController,
                    decoration:const InputDecoration(
                        hintText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.zero,
                        )
                    ),
                  ),
                  const  SizedBox(height: 15,),
                   TextFormField(
                     controller: lastNameController,
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "*required";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.zero,
                        )
                    ),
                  ),
                  const SizedBox(height: 15,),
                   TextFormField(
                     controller: emailController,
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
                    decoration: const InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.zero,
                        )
                    ),
                  ),
                  const SizedBox(height: 15,),
                   TextFormField(
                     controller: cnicController,
                     validator: (value){
                       if(value!.isEmpty)
                       {
                         return "*required";
                       }
                     },
                    keyboardType:TextInputType.phone,
                    decoration: const InputDecoration(
                        hintText: 'CNIC',
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.zero,
                        )
                    ),
                  ),
                  const SizedBox(height: 15,),
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
                     obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.zero,
                        )
                    ),
                  ),

                  const SizedBox(height: 15,),
                   TextFormField(
                     controller: phoneNumberController,
                     validator: (value){
                       if(value!.isEmpty)
                       {
                         return "*required";
                       }
                     },
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        hintText: 'Phone NO',
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.zero,
                        )
                    ),
                  ),
                  const SizedBox(height: 15,),
                   TextFormField(
                     controller: cityController,
                     validator: (value){
                       if(value!.isEmpty)
                       {
                         return "*required";
                       }
                     },
                    decoration:const  InputDecoration(
                        hintText: 'City',
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.zero,
                        )
                    ),
                  ),

                  // const SizedBox(height: 15,),
                  // TextFormField(
                  //   controller: hourPriceController,
                  //   validator: (value){
                  //     if(value!.isEmpty)
                  //     {
                  //       return "*required";
                  //     }
                  //   },
                  //   decoration:const  InputDecoration(
                  //       hintText: 'enter your hourly price',
                  //       border: OutlineInputBorder(
                  //         borderRadius:BorderRadius.zero,
                  //       )
                  //   ),
                  // ),


                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: bioController,
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "*required";
                      }
                    },
                    maxLines: 5,
                    decoration:const  InputDecoration(
                        hintText: 'Add profile bio',
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.zero,
                        )
                    ),
                  ),
                  ElevatedButton(onPressed: (){

                    if(databaseButton == "Client")
                      {
                        if(_formKey.currentState!.validate())
                        {
                          auth.createAccount(emailController.text, passwordController.text, firstNameController.text, cnicController.text, lastNameController.text, context, cityController.text, phoneNumberController.text, databaseButton!, "", imagePath!.absolute, "", "");
                        }
                      }
                    else
                      {
                        if(databaseButton == null)
                        {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context)
                              {
                                return AlertDialog(
                                  actions: [
                                    ElevatedButton(onPressed: (){
                                      Navigator.of(context).pop();
                                    }, child: Text("Cancel")),
                                  ],
                                  content:  Container(
                                    width: size.width * 0.8,
                                    height: size.height * 0.05,
                                    child: Text("Select role", style: TextStyle(fontSize: 20, color: Colors.black),),
                                  ),
                                );
                              }
                          );
                        }
                        else  if(skillButton == null)
                        {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context)
                              {
                                return AlertDialog(
                                  actions: [
                                    ElevatedButton(onPressed: (){
                                      Navigator.of(context).pop();
                                    }, child: Text("Cancel")),
                                  ],
                                  content: Container(
                                    width: size.width * 0.8,
                                    height: size.height * 0.05,
                                    child: Text("Select Skill", style: TextStyle(fontSize: 20, color: Colors.black),),
                                  ),
                                );
                              }
                          );
                        }
                        else if(_formKey.currentState!.validate())
                        {
                          auth.createAccount(
                              emailController.text,
                              passwordController.text,
                              firstNameController.text,
                              cnicController.text,
                              lastNameController.text,
                              context,
                              cityController.text,
                              phoneNumberController.text,
                              databaseButton!, skillButton!,
                              imagePath!.absolute,
                              bioController.text,
                              hourPriceController.text,
                          );
                        }
                      }


                  }, child: Text("Sign up")),
                ],
              ),
            ),
          ),
        ),
    );  }
}
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hunarmand_app/screens/electrician_screen.dart';
import 'package:hunarmand_app/screens/mechanic_screen.dart';
import 'package:hunarmand_app/screens/place_orders.dart';
import 'package:hunarmand_app/screens/plumber_screen.dart';

import '../NotificationServices/notification_services.dart';
import 'accepted_orders_client.dart';
import 'completed_order.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final db = FirebaseFirestore.instance;

  NotificationServices services = NotificationServices();

  saveToken()async
  {
    String? token = await messaging.getToken();
    await db.collection("client").doc(auth.currentUser!.uid).update({
      "fcmToken" : token.toString(),
    }).then((value) => print("success"));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    services.requestNotificationPermission();
    services.firebaseInit();
    saveToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
                    },
                    icon: Icon(Icons.home)),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PlaceOrders()));
                    },
                    icon: Icon(Icons.add_shopping_cart_outlined)),
                label: 'Place Orders'),
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>  AcceptedOrders()));
                    },
                    icon: Icon(Icons.receipt)),
                label: 'Accepted Orders'),
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>  CompletedOrder()));
                    },
                    icon: Icon(Icons.check_circle_sharp)),
                label: 'Complete Orders'),
          ],
        ),
        appBar: AppBar(

          title: Text(
            "Home",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {


                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure to logout?'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: Text('Yes'),
                        ),


                      ],
                    );
                  },
                );
                auth.signOut();
              },
              icon: Icon(Icons.logout_outlined,color: Colors.white),
              color: Colors.black,
            ),
          ],
          backgroundColor: Color(0xFF00796B),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 180.0,
                child: (ListView(
                  children: [
                    CarouselSlider(
                      items: [
                        //1st Image of Slider
                        Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: const DecorationImage(
                              image:
                                  AssetImage("assets/images/electricians.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        //2nd Image of Slider
                        Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/mechanics.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        //3rd Image of Slider
                        Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/plumbers.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],

                      //Slider Container properties
                      options: CarouselOptions(
                        height: 180.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 500),
                        viewportFraction: 0.8,
                      ),
                    ),
                  ],
                )),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 1,
                              offset: const Offset(1.0, 1.0),
                            ),
                          ],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/service.jpg"),
                              fit: BoxFit.cover)),
                      height: 160,
                      width: 150,
                      child: const Text(
                        'SERVICES',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const MechanicScreen();
                        }));
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(1.0, 1.0),
                              ),
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            image: const DecorationImage(
                                image: AssetImage("assets/images/mechanic.jpg"),
                                fit: BoxFit.cover)),
                        height: 160,
                        width: 150,
                        child: const Text(
                          'MECHANICS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const PlumberScreen();
                        }));
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(1.0, 1.0),
                              ),
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            image: const DecorationImage(
                                image: AssetImage("assets/images/plumber.jpg"),
                                fit: BoxFit.cover)),
                        height: 160,
                        width: 150,
                        child: const Text(
                          'PLUMBERS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const ElectricianScreen();
                        }));
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(1.0, 1.0),
                              ),
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            image: const DecorationImage(
                                image: AssetImage("assets/images/elec.jpg"),
                                fit: BoxFit.cover)),
                        height: 160,
                        width: 150,
                        child: const Text(
                          'ELECTRICIANS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

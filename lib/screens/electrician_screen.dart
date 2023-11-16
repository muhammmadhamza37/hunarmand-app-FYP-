import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hunarmand_app/screens/plumber_screen.dart';
import 'package:hunarmand_app/screens/worker_detail_screen.dart';

import 'home_screen.dart';
import 'mechanic_screen.dart';

class ElectricianScreen extends StatefulWidget {
  const ElectricianScreen({Key? key}) : super(key: key);

  @override
  State<ElectricianScreen> createState() => _ElectricianScreenState();
}

class _ElectricianScreenState extends State<ElectricianScreen> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [

          BottomNavigationBarItem(

              icon: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>  HomeScreen()));
                  },
                  icon: Icon(Icons.home,color: Colors.grey,)),
              label: 'Home'),

          BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MechanicScreen()));
                  },
                  icon: Icon(Icons.car_rental)),
              label: 'Mechanics'),
          BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PlumberScreen()));
                  },
                  icon: Icon(Icons.plumbing_rounded)),
              label: 'Plumbers'),
          BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ElectricianScreen()));
                  },
                  icon: Icon(Icons.electric_bolt_outlined),color: Colors.deepOrange,),
              label: 'Electricians'),
        ],
      ),
      appBar: AppBar(
        title: const Text('Electricians'),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('workers').where("skill", isEqualTo: 'Electrician').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

          if(snapshot.hasData)
          {

            final data = snapshot.data;
            List<DocumentSnapshot> documentSnapshot = data!.docs;

            return ListView.builder(
                itemCount: documentSnapshot.length,
                itemBuilder: (context, int index){

                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return WorkerDetailScreen(workerData: documentSnapshot[index], uid: documentSnapshot[index]['uid'],);
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: size.height * 0.15,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Image(image: NetworkImage(documentSnapshot[index]['imageUrl']),fit: BoxFit.cover,)),

                            SizedBox(
                              width: size.width * 0.07,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                              [
                                SizedBox(
                                    width: size.width * 0.5,
                                    child: Text(documentSnapshot[index]['firstName'], overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: size.width * 0.06),)),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                SizedBox(
                                    width: size.width * 0.5,
                                    child: Text(documentSnapshot[index]['skill'], overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: size.width * 0.05, color: Colors.grey),)),

                                SizedBox(
                                  height: size.height * 0.035,
                                ),
                                Row(
                                  children:
                                  [
                                    Text("Ratings",  overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: size.width * 0.05),),
                                    SizedBox(
                                      width: size.width * 0.07,
                                    ),
                                    Text("jobs",   overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: size.width * 0.05),),
                                    SizedBox(
                                      width: size.width * 0.07,
                                    ),
                                    Text("Rate",  overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: size.width * 0.05),),
                                  ],
                                ),

                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Row(
                                  children:
                                  [
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.yellow,),
                                        Text("4.5", style: TextStyle(fontSize: size.width * 0.05),),
                                      ],
                                    ),
                                    SizedBox(
                                      width: size.width * 0.1,
                                    ),
                                    Text("5", style: TextStyle(fontSize: size.width * 0.05),),
                                    SizedBox(
                                      width: size.width * 0.1,
                                    ),
                                    Text("10", style: TextStyle(fontSize: size.width * 0.05),),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                });
          }
          else
          {
            return Container();
          }
        },

      ),
    );
  }
}

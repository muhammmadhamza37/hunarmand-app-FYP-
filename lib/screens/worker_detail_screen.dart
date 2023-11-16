import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hunarmand_app/screens/place_order.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

const currency = "\$";


class WorkerDetailScreen extends StatefulWidget {
   WorkerDetailScreen({Key? key, required this.workerData, required this.uid}) : super(key: key);

   DocumentSnapshot workerData;
   String uid;

  @override
  State<WorkerDetailScreen> createState() => _WorkerDetailScreenState();
}

class _WorkerDetailScreenState extends State<WorkerDetailScreen> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    final data = widget.workerData.data() as Map<dynamic, dynamic>;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("worker screen"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Container(
                      height: size.height * 0.5,
                      width: size.width * 1,
                      child: Image(image: NetworkImage(data['imageUrl'].toString()), fit: BoxFit.cover,)),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Row(
                          children:
                          [
                            Container(
                              width: size.width * 0.3,
                                child: Text("${data['firstName'].toString()} ${data['lastName'].toString()}", overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.height * 0.03),)),

                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            IconButton(onPressed: ()async{
                              final call = Uri.parse('tel:+92 3149761371');
                              if (await canLaunchUrl(call)){
                                launchUrl(call);
                              } else {
                                throw 'Could not launch $call';
                              }
                            }, icon: Icon(Icons.call)),

                            SizedBox(
                              width: size.width * 0.09,
                            ),
                            // TextButton(
                            //     onPressed: (){
                            //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaceOrder(uid: widget.uid, fcmToken: data['fcmToken'].toString(),)));
                            //
                            //     }, child: Text("Book Now")),

                            OutlinedButton(onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlaceOrder(uid: widget.uid, fcmToken: data['fcmToken'].toString(),)));
                            }, child:Text("Book Now") ),
                          ],
                        ),
                        Container(
                          width: size.width * 1,
                          height: size.height * 0.0002,
                          color: Colors.black,
                        ),

                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Text(data['skill'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.06),),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                              [
                                // Text("Price", style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold),),
                                // Text("$currency ${data['price']}", style: TextStyle(fontSize: size.width * 0.04),),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                              [
                                Text("Rating", style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.star, size: size.width * 0.04,),
                                    Text(data['rating'], style: TextStyle(fontSize: size.width * 0.04),),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                              [
                                Text("Projects", style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold),),
                                Text(data['projects'], style: TextStyle(fontSize: size.width * 0.04),),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Text("Profile Info", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        Text(data['bio'], style: TextStyle(fontSize: 20),),



                      ],
                    ),
                  ),

                ],
              ),


              SizedBox(
                height: size.height * 0.05,
              ),


              Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),




              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [

                    StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("reviews").where('worker_uid', isEqualTo: widget.uid).snapshots(),
                        builder: (context, snapshot){

                          if(snapshot.hasData)
                          {
                            final da = snapshot.data;
                            final dat = da!.docs;



                            return ListView.builder(
                                itemCount: dat.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index){


                                  final name = dat[index]['name'];
                                  final rating = dat[index]['rating'];


                                  return Column(
                                    children: [
                                      Row(
                                        children:
                                        [
                                          CircleAvatar(
                                            radius: size.width * 0.05,
                                            child: Text(name[0].toString().toUpperCase()),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.04,
                                          ),
                                          Text(name, style: TextStyle(fontSize: size.width * 0.05),),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        children:
                                        [
                                          rating == "1.0" ? Row(
                                            children:
                                            [
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                            ],
                                          ) : rating == "2.0" ? Row(
                                            children:
                                            [
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                            ],
                                          ) : rating == "3.0" ? Row(
                                            children:
                                            [
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star),
                                              Icon(Icons.star),
                                            ],
                                          ) : rating == "4.0" ? Row(
                                            children:
                                            [
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star),
                                            ],
                                          ) : Row(
                                            children:
                                            [
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star, color: Colors.yellow,),
                                              Icon(Icons.star),
                                            ],
                                          ),

                                          SizedBox(
                                            width: size.width * 0.05,
                                          ),
                                          Text(dat[index]['time'], style: TextStyle(fontSize: size.width * 0.05),),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.015,
                                      ),
                                      Text(dat[index]['review'], style: TextStyle(fontSize: size.width * 0.05),),
                                    ],
                                  );
                                }
                            );
                          }
                          else
                          {
                            return Container();
                          }
                        }
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),

      // body: Stack(
      //   children: [

      //     Positioned(
      //       top: size.height * 0.45,
      //       child: ,
      //     ),
      //   ],
      // ),
    );

    // return Scaffold(
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.only(top: 75,left: 95),
    //         child: Container(
    //           width: 150,
    //           height: 150,
    //          alignment: Alignment.center,
    //          decoration: BoxDecoration(
    //            shape: BoxShape.circle,
    //            color: Colors.deepOrange,
    //            image: DecorationImage(image: AssetImage('assets/images/profile.jpg'))
    //          ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hunarmand_app/screens/client_registration_screen.dart';
import 'package:hunarmand_app/screens/login_screen.dart';
import 'package:hunarmand_app/screens/worker_registration_screen.dart';

class WorkerClientScreen extends StatefulWidget {
  const WorkerClientScreen({Key? key}) : super(key: key);

  @override
  State<WorkerClientScreen> createState() => _WorkerClientScreenState();
}

class _WorkerClientScreenState extends State<WorkerClientScreen> {
  CollectionReference? taskRef;

  @override
  void initState() {
    super.initState();

    String uid = FirebaseAuth.instance.currentUser!.uid;

    taskRef = FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('tasks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WorkerClient'),
        actions: [
          IconButton(
              onPressed: () async{
                return _showmy();
              },
              icon: const Icon(Icons.logout,)),

        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              color: Colors.black12,
              child: Center(
                child: InkWell(onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const WorkerRegistrationScreen();
                      }));
                },
                  child: Container(
                    height: 80,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    margin: const EdgeInsets.only(top: 150),
                    child: const Center(
                        child: Text(
                          'As a Worker',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        )),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black12,
              child: Center(
                child: InkWell(onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const ClientRegistrationScreen();
                      }));
                },

                  child: Container(
                    height: 80,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    margin: const EdgeInsets.only(bottom: 330, top: 100),
                    child: const Center(
                        child: Text(
                          'As a Client',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
    Future<void>_showmy()async{
      return showDialog(context: context, builder: (context){
        return AlertDialog(
          title:const  Text("Log out"),
          content: Row(
            children: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                  child: const Text("Cancel")),
              TextButton(onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (_) {
                  return const LoginScreen();
                }));

              }, child:const
              Text("Log out"))
            ],
          ),
        );

      }

      );

    }


}









//       StreamBuilder<QuerySnapshot>(
//            stream: taskRef!.snapshots(),
//             builder: (context, snapshot) {
//             if (snapshot.hasData) {
//     if (snapshot.data!.docs.isEmpty) {
//     return const Center(
//     child: Text('No Tasks Yet'));
//     }else{
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListView.builder(
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context,index){
//             return Card(
//               margin: EdgeInsets.only(bottom: 10),
//               child: Row(
//                 children: [
//                   Expanded(child: Container(
//                     padding: EdgeInsets.only(left: 10),
//                     height: 100,
//                     color: Colors.yellow,
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//
//                        Text('${snapshot.data!.docs[index]['taskId']}'),
//                        Text('${snapshot.data!.docs[index]['taskName']}'),
//                        Text(Helper.getHumanDate(snapshot.data!.docs[index]['dt'])),
//
//                      ],
//                    ),
//                   )),
//                   Container(
//                     color: Colors.orange,
//                     height: 100,
//                     child: Column(
//                       children: [
//                         IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
//                         IconButton(onPressed: (){
//
//                           showDialog(context: context, builder: (context){
//                             return AlertDialog(
//                              content: Row(
//                                children: const [
//                                  Icon(Icons.delete),
//                                  Text('Are you sure to delete?'),
//                                ],
//                              ),
//                               actions: [
//                                 TextButton(onPressed: (){
//                                   Navigator.of(context).pop();
//                                 }, child: const Text('No')),
//                                 TextButton(onPressed: (){
//                                   Navigator.of(context).pop();
//
//                                   taskRef!.doc(snapshot.data!.docs[index]['taskId']).delete();
//                                 }, child: const Text('Yes')),
//
//                               ],
//                             );
//                           });
//                         }, icon: const Icon(Icons.delete)),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             );
//
//       }),
//     );
//     }
//
//     }else{
//               return const Center(
//               child: CircularProgressIndicator(),
//               );
//     }
//         }
//       ));
//   }
// }

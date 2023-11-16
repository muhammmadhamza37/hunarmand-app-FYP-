import 'package:flutter/material.dart';
import 'package:hunarmand_app/screens/worker_request_screen.dart';
class WorkerRegistrationScreen extends StatelessWidget {
  const  WorkerRegistrationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Registration',style: TextStyle(color: Colors.black),),
      ),
      body:  Padding(
       padding: const EdgeInsets.all(8.0),
       child: SingleChildScrollView(
         child: Column(
           children: [
             const SizedBox(height: 15,),
             const TextField(
               decoration: InputDecoration(
                   hintText: 'Name',
                   border: OutlineInputBorder(
                       borderRadius:BorderRadius.zero,
                   )
               ),
             ),
             const SizedBox(height: 15,),
             const TextField(
               decoration: InputDecoration(
                 hintText: 'Email',
                 border: OutlineInputBorder(
                   borderRadius:BorderRadius.zero,
                 )
               ),
             ),
             const SizedBox(height: 15,),
             const TextField(
               keyboardType: TextInputType.number,

               obscureText: true,
               decoration: InputDecoration(
                   hintText: 'CNIC',
                   border: OutlineInputBorder(
                       borderRadius:BorderRadius.zero,
                   )

               ),
             ),
             const SizedBox(height: 15,),
             const TextField(
               //obscureText: true,
               keyboardType: TextInputType.number,
               decoration: InputDecoration(
                   hintText: 'Password',
                   border: OutlineInputBorder(
                       borderRadius:BorderRadius.zero,
                   )

               ),
             ),
             const SizedBox(height: 15,),
             const TextField(
               //obscureText: true,
               keyboardType: TextInputType.number,
               decoration: InputDecoration(
                   hintText: 'Confirmed Password',
                   border: OutlineInputBorder(
                     borderRadius:BorderRadius.zero,
                   )

               ),
             ),
             const SizedBox(height: 15,),
             const TextField(
               // obscureText: true,
               keyboardType: TextInputType.number,
               decoration: InputDecoration(
                   hintText: 'Phone NO',
                   border: OutlineInputBorder(
                     borderRadius:BorderRadius.zero,
                   )

               ),
             ),
              const SizedBox(height: 15,),
              const TextField(
               //obscureText: true,
               keyboardType: TextInputType.number,
               decoration: InputDecoration(
                   hintText: 'Skills',
                   border: OutlineInputBorder(
                     borderRadius:BorderRadius.zero,
                   )

               ),
             ),
             const SizedBox(height: 15,),
             const TextField(
               //obscureText: true,
               keyboardType: TextInputType.number,
               decoration: InputDecoration(
                   hintText: 'City',
                   border: OutlineInputBorder(
                     borderRadius:BorderRadius.zero,
                   )

               ),
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 OutlinedButton(onPressed: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (context){
                     return const WorkerRequestScreen();
                   }));
                 }, child: const Text('Submit')),
               ],
             )


           ],
         ),
       ),
     ),

    );
  }
}




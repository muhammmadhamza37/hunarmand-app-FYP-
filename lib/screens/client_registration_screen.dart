import 'package:flutter/material.dart';
import 'package:hunarmand_app/screens/home_screen.dart';
class ClientRegistrationScreen extends StatefulWidget {
  const ClientRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<ClientRegistrationScreen> createState() => _ClientRegistrationScreenState();
}

class _ClientRegistrationScreenState extends State<ClientRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Registration'),
      ),
      body:   Padding(
        padding: const EdgeInsets.all(10),
        child:SingleChildScrollView(
          child: Column(
            children: [
             const  SizedBox(height: 15,),
                   const  TextField(
            decoration: InputDecoration(
                hintText: 'First Name',
                border: OutlineInputBorder(
                    borderRadius:BorderRadius.zero,
                )
            ),
          ),
             const  SizedBox(height: 15,),
              const TextField(
                decoration: InputDecoration(
                    hintText: 'Last Name',
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
                keyboardType:TextInputType.phone,
                decoration: InputDecoration(
                    hintText: 'CNIC',
                    border: OutlineInputBorder(
                        borderRadius:BorderRadius.zero,
                    )
                ),
              ),
              const SizedBox(height: 15,),
              const TextField(
                decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius:BorderRadius.zero,
                    )
                ),
              ),
              const SizedBox(height: 15,),
              const TextField(
                decoration: InputDecoration(
                    hintText: 'Confirmed Password',
                    border: OutlineInputBorder(
                        borderRadius:BorderRadius.zero,
                    )
                ),
              ),
              const SizedBox(height: 15,),
              const TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: 'Phone NO',
                    border: OutlineInputBorder(
                        borderRadius:BorderRadius.zero,
                    )
                ),
              ),
              const SizedBox(height: 15,),
              const TextField(
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
                      return HomeScreen();
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

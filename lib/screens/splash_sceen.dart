import 'package:flutter/material.dart';
import 'package:hunarmand_app/screens/worker_client_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatefirst();
  }
  _navigatefirst ()async{
    await Future.delayed(const Duration(seconds: 5),(){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return const WorkerClientScreen();
    }));

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green
        ),
        child: Image(
                  image: AssetImage('assets/images/service.jpg'),
                  fit: BoxFit.fill,
                ),
      )
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: const [
      //       SizedBox (width: 10,height: 10,),
      //       SizedBox(
      //         height: 100,
      //         width: 100,
      //         child: Image(
      //           image: AssetImage('assets/images/service.jpg'),
      //           fit: BoxFit.fill,
      //         ),
      //       ),
      //       Text(
      //         "HUNARMAND",
      //         style: TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}





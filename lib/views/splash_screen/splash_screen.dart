import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:saberion_assesment/theme/light_color.dart';
import 'package:saberion_assesment/views/home_page.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    redirectHomePage();
    super.initState();
  }

  void redirectHomePage(){
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage()),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xffaec2cb),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const Text("Saberion Assessment",style: TextStyle(color: LightColor.appBlack,fontWeight: FontWeight.w600,fontSize: 28),),
            const SizedBox(height: 20,),
            Center(
              child: Image.asset(
                'assests/img/playstore.png',
                height: 300,
                width:300,
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 20,),
            const SpinKitFadingCircle(
              color: Colors.white,
              size: 50.0,
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:saberion_assesment/theme/light_color.dart';

class DetailsPage extends StatefulWidget {
  final details;
  const DetailsPage({required this.details, Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset("assests/img/image 1.png"),
          elevation: 2,
          centerTitle: false,

          actions: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    border: Border.all(color: LightColor.appBlack,)
                ),
                child: Row(
                  children: const [Icon(Icons.arrow_back_ios_outlined,size: 18,color: LightColor.appBlue,),
                  Text("Back",style: TextStyle(color:  LightColor.appBlue,),)],
                ),
              ),
            ),
            SizedBox(width: 10,)
          ],
          backgroundColor: LightColor.appBackground,
          // centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20.0),
            child: Container(),
          )),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            widget.details["name"]["first"] +
                " " +
                widget.details["name"]["last"],
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 50),
          ),
          SizedBox(
            height: 10,
          ),
          ClipOval(
            child: Image.network(
              widget.details["picture"]["large"],
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              contactDetails(imageUrl: "assests/img/email.png", text:widget.details['email']),
              contactDetails(
                  imageUrl: "assests/img/phone-call.png", text: widget.details['phone']),
              contactDetails(imageUrl: "assests/img/location.png", text: widget.details['location']['country']),
            ],
          )
        ],
      ),
    );
  }

  Widget contactDetails({required String imageUrl, required String text}) {
    return Row(
      children: [
        Image.asset(
          imageUrl,
          width: 25,
          color: LightColor.appBlue,
        ),
        SizedBox(
          width: 5,
        ),
        Text(text)
      ],
    );
  }
}

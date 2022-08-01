import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saberion_assesment/theme/light_color.dart';
import 'package:saberion_assesment/views/details_page/details_page.dart';
import 'package:saberion_assesment/widget/loading/loading_circuls.dart';
import 'package:saberion_assesment/services/api_sevices.dart' as api_service;
import 'package:saberion_assesment/config/url_config.dart' as config;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDataLoading = false; // data loading status from API
  List dataList= [];
  List genderValue = ['male', 'Female', 'all'];
  String selectedGender="all";

  @override
  void initState() {
    super.initState();
    _getPreferance();
  }

  void _getPreferance() async {
    _getPreviousData();
  }


  /// todo implement popMenu
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      backgroundColor: LightColor.appBackground,
      appBar: AppBar(
          title: Image.asset("assests/img/image 1.png"),
          elevation: 2,
          backgroundColor: LightColor.appBackground,
          // centerTitle: true,

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20.0),
            child: Container(),
          )),
      body: dataList.length > 0
          ? SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(bottom: 80),
                // height: MediaQuery.of(context).size.height*0.5,
                padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(onPressed:() {
                      _getPreferance();
                    },
                      color: LightColor.appBlue,
                      child: Text("Generate New Users"),),
                    // GestureDetector(
                    //     onTap: () {
                    //       _getPreferance();
                    //     },
                    //     child: Text("Saberion Assessment")),
                    // TextField(
                    //   onChanged: (value){
                    //     // searchData(st = value.trim().toLowerCase());
                    //     // Method For Searching
                    //   },
                    //   decoration: const InputDecoration(
                    //     hintText: "Search Data",
                    //     prefixIcon: Icon(Icons.search),
                    //     border: OutlineInputBorder(
                    //       borderRadius:
                    //       BorderRadius.all(Radius.circular(7.0)),
                    //     ),
                    //   ),
                    // ),

                    Container(
                      // width: 200,
                      height: 200,
                      child: Column(
                        children: [
                          RadioListTile(
                            title: Text("All"),
                            value: "all",
                            groupValue: selectedGender,
                            onChanged: (value){
                              setState(() {
                                selectedGender = value.toString();
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text("Male"),
                            value: "male",
                            groupValue: selectedGender,
                            onChanged: (value){
                              setState(() {
                                selectedGender = value.toString();
                              });
                            },
                          ),

                          RadioListTile(
                            title: Text("Female"),
                            value: "female",
                            groupValue: selectedGender,
                            onChanged: (value){
                              setState(() {
                                selectedGender = value.toString();
                              });
                            },
                          ),



                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: MediaQuery.of(context).size.height * 0.5,
                      // padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                      child: GridView.builder(
                          itemCount: dataList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: MediaQuery.of(context)
                                              .size
                                              .width >
                                          600
                                      ? MediaQuery.of(context).size.width >
                                              1000
                                          ? 6
                                          : 4
                                      : MediaQuery.of(context).size.width <
                                              350
                                          ? 1
                                          : 2),
                          itemBuilder: (BuildContext context, int index) {
                            return listTile(
                                data: dataList[index],
                                imageUrl: dataList[index]["picture"]["large"],
                                name: (dataList[index]["name"]["first"] +
                                    " " +
                                    dataList[index]["name"]["last"]));
                          }),
                    )
                    // : _emptyScreen(),
                  ],
                ),
              ),
            )
          : _emptyScreen(),
    );
  }

  Widget listTile({required String imageUrl, required String name,required var data}) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  DetailsPage(details: data,)),
        );
      },
      child: Container(
        color: LightColor.appBlue,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              // width: MediaQuery.of(context).size.width/2,
              // height: MediaQuery.of(context).size.width/2,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(name)
          ],
        ),
      ),
    );
  }



  _getPreviousData() async {
    try {
      setState(() {
        isDataLoading = true;
      });
      var params = config.apiPath + "results=100" +(selectedGender =="all"?"":"&gender=$selectedGender");
      var response = await api_service.fetchGet(params);
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        dataList=res['results'];
print(res['results']);
// print(dataList['results']);
print(dataList.length);
        setState(() {
          isDataLoading = false;
        });
      } else {
        setState(() {
          isDataLoading = false;
        });
        var errorObj = json.decode(response.body);
        // notification.errorMessage(errorObj['msg'], 4);
      }
    } catch (e) {
      print(e);
      setState(() {
        isDataLoading = false;
      });
      // notification.errorMessage(
      //     "Something went wrong! may be a network error", 3);
    }
  }

  Widget _emptyScreen() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              'assests/img/loading.png',
              fit: BoxFit.fitWidth,
            )),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Loading',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18.0,
                  fontFamily: "FaktPro",
                  color: LightColor.appGreyDark),
            ),
            const SizedBox(
              height: 30,
            ),
            isDataLoading
                ? Center(
                    child: Loadingcircul(color: LightColor.appBlue),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

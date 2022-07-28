import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saberion_assesment/theme/light_color.dart';
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
  List dataList = [];
  int currentPageNumber = 1; // current page holder for pagination
  int availablePageNumber = 0;
  int itemCount = 0;
  RefreshController _refreshController = RefreshController(
      initialRefresh: false); // SmartRefresher widget scroll controller
  bool isFirstTime =
      true; // check if fisrt time status for arrange the dataList array

  @override
  void initState() {
    super.initState();
    _getPreferance();
  }

  void _getPreferance() async {
    _getPreviousData(currentPageNumber);
  }

  @override
  dispose() {
    _refreshController.dispose();
    super.dispose();
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
    /// todo 1.search field and an options menu
    /// todo 2.Get Data from https://reqres.in/api/users?page=1 display the result images in a grid-layout below the search field.
    /// todo 3.The images must be shown as square views in the grid without any skewing.
    /// todo 4.The grid layout should have infinite scroll support i.e. if the user scrolls to the bottom of the page, then the app will re-contact the image search API to get more results and add them to the bottom of the grid.
    return Scaffold(
      appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Logout', 'Settings'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
            SizedBox(
              width: 15,
            )
          ],
          title: Text("Test"),
          centerTitle: true,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                  bottomRight: Radius.circular(70))),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20.0),
            child: Container(),
          )),
      body:dataList.length > 0
          ?  SingleChildScrollView(
            child: Container(
        margin: const EdgeInsets.only(bottom: 80),
        // height: MediaQuery.of(context).size.height*0.5,
        padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value){
                  // searchData(st = value.trim().toLowerCase());
                  // Method For Searching
                },
                decoration: InputDecoration(
                  hintText: "Search Data",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(7.0)),
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height*0.6,
                // padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                    child: SmartRefresher(
                      enablePullDown: false,
                      enablePullUp: true,
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus? mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = (availablePageNumber > currentPageNumber)
                                ? Text("pull up load")
                                : Text("No more data ...");
                          } else if (mode == LoadStatus.loading) {
                            body = Loadingcircul(color: LightColor.appBlue);
                          } else if (mode == LoadStatus.failed) {
                            body = Text("Load Failed!Click retry!");
                          } else if (mode == LoadStatus.canLoading) {
                            body = Text("release to load more");
                          } else {
                            body = Text("No more Data");
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onLoading: _onLoading,
                      onRefresh: null,
                      child: GridView.builder(
                          itemCount: itemCount,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return listTile(
                                imageUrl: dataList[index]["avatar"],
                                name: (dataList[index]["first_name"] +
                                    " " +
                                    dataList[index]["last_name"]));
                          }),
                    ),
                  )
                  // : _emptyScreen(),
            ],
        ),
      ),
          ): _emptyScreen(),
    );
  }

  Widget listTile({required String imageUrl, required String name}) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          width: 100,
          height: 100,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Text(name)
      ],
    );
  }

  void _onLoading() async {
    if (availablePageNumber > currentPageNumber) {
      currentPageNumber++;
      await _getPreviousData(currentPageNumber);
    }

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  _getPreviousData(int currentPageNumber) async {
    try {
      setState(() {
        isDataLoading = true;
      });
      var params = config.apiPath + currentPageNumber.toString();
      var response = await api_service.fetchGet(params);
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        if (isFirstTime) {
          dataList = res['data'];
          availablePageNumber = res['total_pages'];
          setState(() {
            itemCount = dataList.length;
          });

          isFirstTime = false;
        } else {
          for (var i = 0; i < res['data'].length; i++) {
            dataList.add(res['data'][i]);
          }
          if (res['data'].length == 0) {
            _refreshController.loadNoData();
          }
        }
        setState(() {
          isDataLoading = false;
          itemCount = dataList.length;
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
    return Container(
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
          SizedBox(
            height: 30,
          ),
          Text(
            'Loading',
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18.0,
                fontFamily: "FaktPro",
                color: LightColor.appGreyDark),
          ),
          SizedBox(
            height: 30,
          ),
          isDataLoading
              ? Center(
                  child: Loadingcircul(color: LightColor.appBlue),
                )
              : Container(),
        ],
      ),
    );
  }
}

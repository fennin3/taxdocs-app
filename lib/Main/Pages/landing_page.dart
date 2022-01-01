import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Main/Components/bottom_nav_bar.dart';
import 'package:taxdocs/Main/Components/empty_docs.dart';
import 'package:taxdocs/Main/Components/my_drawer.dart';
import 'package:taxdocs/Main/Components/recent_doc.dart';
import 'package:taxdocs/Main/Components/sort_widget.dart';
import 'package:taxdocs/Main/Pages/notifications.dart';
import 'package:taxdocs/Main/Pages/received_docs.dart';
import 'package:taxdocs/Main/Pages/sent_docs.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String? query;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);


  void _onRefresh() async{
    final app = Provider.of<appState>(context, listen: false);
    app.dataInit();
    _refreshController.refreshCompleted();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _refreshController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context, listen: true);
    // print("THE LOADER VALUE == ${app.loading}");
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Image.asset(
                    "assets/img/logo.png",
                    height: size.height * 0.1,
                  ),
                  actions: [
                    InkWell(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationPage())),
                      child: Padding(
                        padding:const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                Icons.notifications,
                                size: size.height * 0.032,
                              ),
                                
                              if(app.myNotifications.where((element) => element.status == false).toList().isNotEmpty)
                                Positioned(
                                    top: -6,
                                    right: -4,
                                    child: CircleAvatar(radius: 9, backgroundColor: orangeColor2, child: Center(child: Text("${app.myNotifications.where((element) => element.status ==false).toList().length}", style: textStyle.copyWith(fontSize: 14),)),))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        onRefresh: _onRefresh,
        controller: _refreshController,
        child: ModalProgressHUD(
          inAsyncCall: app.loading,
          progressIndicator: spinWidget,
          child: SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                
                SizedBox(
                  height: size.height * 0.024,
                ),
                SizedBox(
                  width: size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.78,
                        height: size.height < 900 ? 55 : size.height * 0.06,
                        decoration: BoxDecoration(
                            color: greyColor2, borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Image.asset(
                                    "assets/img/search.png",
                                    height: 15,
                                    width: 15,
                                  )),
                              Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: TextFormField(
                                      autofocus: app.scanSearch.isEmpty ? false:true,
                                      initialValue: app.scanSearch,
                                      onChanged: (e){
                                        app.searchScans(e);
                                      },
                                      cursorColor: blue,
                                      style: textStyle.copyWith(color: blue),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search your files",
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(179, 188, 207, 1),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(width: 20,),
                      SortWidget(
                        size: size, onTap: (filter){
                          app.filterList(filter, "scans");
                      },)
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.025,
                        ),
                        SizedBox(
                          width: size.width * 0.9,
                          child: const Text(
                            "My Documents",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textBlue),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.0175,
                        ),
                        SizedBox(
                          width: size.width * 0.9,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>const SentDocs(),),),
                                    child: Container(
                                      height: size.height * 0.14,
                                      width: size.height * 0.14,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  AssetImage('assets/img/folder.png'),
                                              fit: BoxFit.cover)),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/img/inner.png",
                                          height: size.height * 0.065,
                                          width: size.height * 0.065,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 4),
                                    child: Text(
                                      "Sent Documents",
                                      style: blue14Style,
                                    ),
                                  ),
                                   Text(
                                    "${app.sDocs} Item${app.sentDocs.length > 1 ? 's' :''}",
                                    style: grey12Style.copyWith(fontSize: 13),
                                  )
                                ],
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 60, minWidth: 20),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>const ReceivedDocs(),),),
                                    child: Container(
                                      height: size.height * 0.14,
                                      width: size.height * 0.14,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  AssetImage('assets/img/folder.png'),
                                              fit: BoxFit.cover)),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/img/inner.png",
                                          height: size.height * 0.065,
                                          width: size.height * 0.065,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10.0, bottom: 4),
                                    child: Text("Received Documents",
                                        style: blue14Style),
                                  ),
                                   Text(
                                    "${app.rDocs} Item${app.receivedDocs.length > 1 ? 's' :''}",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Color.fromRGBO(156, 165, 186, 1),
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.035,
                        ),
                        SizedBox(
                          width: size.width * 0.9,
                          child: const Text(
                            "Recent scans",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textBlue),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.0185,
                        ),
                        app.myScans.isNotEmpty ? GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 450,
                                  mainAxisExtent: 100,
                                  crossAxisSpacing: 20),
                          itemCount: app.myScans.length,
                          itemBuilder: (context2, index) {
                            return RecentDocWidget(cont: context,send: true, scan: app.myScans[index], onSend: (value, note)async{
                              app.uploadPDF(
                                  app.myScans[index].pdf, note, context);
                            },);
                          },
                        ) : Column(
                          children: [
                            // const SizedBox(height: 20,),
                            EmptyDocs(size: size)
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                          ],
                        ),
              )),
        ),
      ),
      bottomNavigationBar: BottomNavBar(size: size, home: true,cont: context,),
    );
  }
}


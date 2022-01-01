import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:taxdocs/Main/Components/bottom_nav_bar.dart';
import 'package:taxdocs/Main/Components/empty_docs.dart';
import 'package:taxdocs/Main/Components/my_appbar.dart';
import 'package:taxdocs/Main/Components/recent_doc.dart';
import 'package:taxdocs/Main/Components/sort_widget.dart';
import 'package:taxdocs/Main/Pages/scan_page.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'dart:io' show Platform;

import 'package:taxdocs/constant.dart';

class SavedDoc extends StatefulWidget {
  const SavedDoc({Key? key}) : super(key: key);

  @override
  State<SavedDoc> createState() => _SavedDocState();
}

class _SavedDocState extends State<SavedDoc> {
      final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _onRefresh()async{
    final app = Provider.of<appState>(context, listen: false);
    app.getSavedPdf();
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
    final app = Provider.of<appState>(context, listen: true);
    final size = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar("My Scans"),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.024,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
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
                        SortWidget(size: size, onTap: (filter) {
                          app.filterList(filter, 'scans');
                        },)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height < 900 ? 32 : size.height * 0.04 ,
                ),
                SizedBox(
                    width: size.width * 0.9,
                    child: Text("${app.myScans.length} Total Documents", style: textStyle.copyWith(fontSize: 16, color: blue),)),
                SizedBox(
                  height: size.height < 900 ? 12 : size.height * 0.015 ,
                ),
        
                Expanded(
                  child: app.myScans.isNotEmpty ? GridView.builder(
                    // physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 450,
                        mainAxisExtent: 100,
                        crossAxisSpacing: 20),
                    itemCount: app.myScans.length,
                    itemBuilder: (context2, index) {
                      return RecentDocWidget(cont: context,send: true,scan: app.myScans[index], onSend: (value, note)async{
                       app.uploadPDF(
                            app.myScans[index].pdf, note, context);
      
                      },
        
                      );
                    },
                  ) :
        
                  Center(
                    child: EmptyDocs(size: size),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(size: size, cont: context,),
    );
  }
}





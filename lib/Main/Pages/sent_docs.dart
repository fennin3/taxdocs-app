import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Main/Components/bottom_nav_bar.dart';
import 'package:taxdocs/Main/Components/empty_docs.dart';
import 'package:taxdocs/Main/Components/my_appbar.dart';
import 'package:taxdocs/Main/Components/send_item.dart';
import 'package:taxdocs/Main/Components/sort_widget.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:io' show Platform;


class SentDocs extends StatefulWidget {
  const SentDocs({Key? key}) : super(key: key);

  @override
  State<SentDocs> createState() => _SentDocsState();
}

class _SentDocsState extends State<SentDocs> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);



Future<void> _onRefresh()async{
    final app = Provider.of<appState>(context, listen: false);
    app.fetchSentDocs();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar("Sent Documents"),
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
                                        initialValue: app.sentSearch,
                                        onChanged: (e){
                                          app.searchSent(e);
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
                        SortWidget(size: size, onTap: (filter){
                          app.filterList(filter, 'sent');
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
                    child: Text("${app.sentDocs.length} ${app.sentDocs.length > 1 ? 'Total Documents':'Document'}", style: textStyle.copyWith(fontSize: 16, color: blue),)),
                SizedBox(
                  height: size.height < 900 ? 12 : size.height * 0.015 ,
                ),
        
                Expanded(
                  child: app.sentDocs.isNotEmpty ? GridView.builder(
                    // physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 450,
                        mainAxisExtent: 100,
                        crossAxisSpacing: 20),
                    itemCount: app.sentDocs.length,
                    itemBuilder: (context, index) {
                      return  SentItem(doc: app.sentDocs[index], context: context,);
                    },
                  ) : Center(child: EmptyDocs(size: size,),),
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

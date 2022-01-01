import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Main/Components/my_appbar.dart';
import 'package:taxdocs/Models/notification_model.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context, listen: true);



  Future<void> _onRefresh()async{
    app.fetchNotication();
  }
    // print();
    return Scaffold(appBar: myAppBar("Notifications"),
    body:  SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: app.myNotifications.isEmpty? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/img/notification.png", height: 35,color: orangeColor2,),
              const SizedBox(height: 10,),
              Text("You have no notifications", style: textStyle.copyWith(color: blue, fontSize: 14),),
            ],
          ): ListView.builder(
              itemCount: app.myNotifications.length,
              itemBuilder: (context2, index){
            return NotificationItem(size: size, notification: app.myNotifications[index],);
          }),
        ),
      ),
    );
  }
}

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;
  const NotificationItem({
    Key? key,
    required this.size,
    required this.notification
  }) : super(key: key);

  final Size size;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool? read = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read = widget.notification.status;
  }


  void markAsRead(){
    setState(() {
      read = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    final app = Provider.of<appState>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(right: widget.size.width * 0.05, left: widget.size.width * 0.05, top: 10),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: (){
              if(!widget.notification.status!){
                markAsRead();
                app.markAsRead(widget.notification.id);
              }

            },
            onLongPress: (){
              app.confirmNotificationDelete(context, widget.notification.id);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                CircleAvatar(radius: 5, backgroundColor: !read! ? orangeColor2 : Colors.grey,),
                const SizedBox(width: 15,),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.notification.message!, style: textStyle.copyWith(color: blue),),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(DateFormat('MMMM dd, yyyy').format(DateTime.fromMillisecondsSinceEpoch(widget.notification.createdOn!)) + " at " + DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.notification.createdOn!)), style: textStyle.copyWith(color: Colors.black54, fontSize: 14),)),
                    ],),
                )
              ],
            ),
          ),
        ),
        const Divider()
      ],),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http_parser/http_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:taxdocs/Auth/Pages/login_screen.dart';
import 'package:taxdocs/Data/share_pref_data.dart';
import 'package:taxdocs/Database/scan_model.dart';
import 'package:taxdocs/Main/Pages/messages.dart';
import 'package:taxdocs/Models/archive.dart';
import 'package:taxdocs/Models/doc_model.dart';
import 'package:taxdocs/Models/notification_model.dart';
import 'package:taxdocs/Models/reeceived_doc.dart';
import 'package:taxdocs/Models/setting_model.dart';
import 'package:taxdocs/Models/user_model.dart';
import 'package:taxdocs/Provider/api_requests.dart';
import 'package:taxdocs/constant.dart';
import 'package:http/http.dart' as http;
// import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:firebase_messaging/firebase_messaging.dart';


enum MyPage { done, reorder, resize, color }

class appState with ChangeNotifier {
  MyPage editPage = MyPage.done;
  bool loading = true;
  UserModel? userData = UserModel();
  List<SentDoc>? _sentDocs = [];
  List<SentDoc> sentDocs = [];
  List<ReceivedDoc>? _receivedDocs = [];
  List<ReceivedDoc> receivedDocs = [];
  Uint8List? image;
  List<String> scannedImages = [];
  String filename = "";
  List<ScanModel> _myScans = [];
  List<ScanModel> myScans = [];

  String scanSearch = "";
  String sentSearch = "";
  String receivedSearch = "";
  int filter = 1;
  List<Offset?>? points;
  String archiveYear = DateTime.now().year.toString();
  String archiveMonth = DateTime.now().month.toString();
  String archiveSearch = "";
  Map<String, dynamic>? paymentIntentData;
  List<ArchiveModel> myArchives = [];
  SettingModel settings = SettingModel();
  List<NotificationModel> myNotifications = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  int rDocs = 0;
  int sDocs = 0;
  SharedPreferences? sharedPreferences;
  String? userId = "";
  bool downloading = false;
  String downloaded = "0";

  // DocumentScannerController scanController = DocumentScannerController();

  Future<String> dataInit() {
    initializeSharedPreferences();
    loading = true;
    notifyListeners();
    getUserId();
    fetchUserDetails();
    getSavedPdf();
    fetchSentDocs();
    fetchReceivedDocs();
    fetchArchivedDocs();
    fetchNotication();
    fetchSettings();
    final a = Future.delayed(const Duration(milliseconds: 50)).then((value) {
      return "ENNIN";
    });

    return a;
  }

  initializeSharedPreferences()async{
    sharedPreferences = await SharedPreferences.getInstance();
    fetchDocsNum();
  }

  void addScannedImage(String imagePath) {
    scannedImages.add(imagePath);

    notifyListeners();
  }

  void setFilename(String name) {
    filename = name;
    // notifyListeners();
  }

  void setPoints(mypoints) {
    points = mypoints;
    // print(points);
    notifyListeners();
  }

  void setArchiveMY(DateTime date){
    archiveMonth = date.month.toString();
    archiveYear = date.year.toString();
    notifyListeners();
  }

  void setArchiveSearch(query){
    archiveSearch = query;
    notifyListeners();
  }

  void fetchSentDocs() async {
    _sentDocs = (await ApiRequests.getSentDocs())!.reversed.toList();
    sentDocs = _sentDocs!;
    sDocs = sentDocs.length;
    sharedPreferences!.setInt('sDocs',sDocs);
    notifyListeners();
  }

  void fetchNotication() async {
    myNotifications = (await ApiRequests.getNotification())!.reversed.toList();
    notifyListeners();
  }

  void fetchSettings() async {
    settings = (await ApiRequests.getSettings());
    notifyListeners();
  }

  void fetchArchivedDocs()async{
    loading = true;
    notifyListeners();
    myArchives = (await ApiRequests.getArchivedDocs(year: archiveYear, month: archiveMonth, query: archiveSearch))!.reversed.toList();

    loading =false;
    notifyListeners();
  }

  void fetchReceivedDocs() async {
    _receivedDocs = (await ApiRequests.getReceivedDocs())!.reversed.toList();
    receivedDocs = _receivedDocs!;
    rDocs = receivedDocs.length;
    sharedPreferences!.setInt('rDocs',rDocs);
    notifyListeners();
  }

  void imageToBytes(path) async {
    image = await File(path).readAsBytes();
  }

  void fetchUserDetails() async {
    userData = await ApiRequests.getUserDetails();
    getSavedPdf();
    notifyListeners();
  }

  void fetchDocsNum(){
    final res1 = sharedPreferences!.getInt('sDocs');
    final res2 = sharedPreferences!.getInt('rDocs');
    if(res1 != null){
      sDocs = res1;
    }
    if(res2 != null){
      rDocs = res2;
    }
    notifyListeners();
  }

  void getUserId()async{
    userId = sharedPreferences!.getString('uid');
    notifyListeners();
  }

  void showSnackBar(context, message, Color? color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color ?? blue,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      duration: const Duration(milliseconds: 3000),
    ));
  }

  changeEditPage(MyPage page) {
    editPage = page;

    notifyListeners();
  }

  void reorderImages({oldIndex, newIndex}) {
    final temp = scannedImages[oldIndex];
    scannedImages[oldIndex] = scannedImages[newIndex];
    scannedImages[newIndex] = temp;

    notifyListeners();
  }

  void _launchUrl(url) async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  void register(String name, email, password, context) async {
    loading = true;
    notifyListeners();

    final data = {"fullName": name, "email": email, "password": password};

    http.Response response =
        await http.post(Uri.parse(baseUrl + "register/user"), body: data);

    loading = false;
    notifyListeners();

    if (response.statusCode == 201) {
      final message = json.decode(response.body)['message'];
      showSnackBar(context, "$message", null);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
      String url = "";
      try {
        url = json.decode(response.body)['link'];
        Future.delayed(const Duration(milliseconds: 1000))
            .then((value) => _launchUrl(Uri.parse(url)));
      } catch (e) {}
    } else {
      final message = json.decode(response.body)['error'];
      showSnackBar(context, "$message", Colors.red);
    }
  }

  void iOS_Permission() async{
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  void login(String email, password, context) async {
    loading = true;
    notifyListeners();
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email.replaceAll(' ', ''), password: password);
      final token = await userCredential.user!.getIdToken(true);
      pref.setString('token', token);
      pref.setString('uid', userCredential.user!.uid);

      if (Platform.isIOS) iOS_Permission();

      _firebaseMessaging.getToken().then((token)async{
        // print("Device Token ====  $token");
        final CollectionReference users =
        _firebaseFirestore.collection("users");
        final data = {
          "registrationToken":token
        };
        users.doc(userCredential.user!.uid).update(data).then((value) => print("Token Updated"));
      });

      await dataInit().then((value){
        getSavedPdf();
        loading = false;
        notifyListeners();
      });

      showSnackBar(context, "Login successful", null);
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
    } on FirebaseException catch (e) {
      loading = false;
      notifyListeners();

      if (e.code == 'user-not-found') {
        loading = false;
        notifyListeners();
        showSnackBar(context, "User not found", Colors.red);
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "Wrong password.", Colors.red);
      }
    } on SocketException{
      showSnackBar(context, "No internet connection", Colors.red);
    }
  }

  void passwordReset(String email, context) async {
    setLoaderOn();
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final Map _data = {
        "email":email
      };
      const url = "${baseUrl}password/reset";
      final http.Response response = await http.post(Uri.parse(url), body: _data);

      setLoaderOff();
      if(response.statusCode == 200){
        showSnackBar(context, json.decode(response.body)['message'], null);
      }else{
        showSnackBar(context, json.decode(response.body)['error'], Colors.red);
      }
    } on SocketException{
      setLoaderOff();
      showSnackBar(context, "No internet connection", Colors.red);
    }
  }

  void saveImageFile(context, image,name)async{
    final status = await Permission.storage.request();

    if (status.isGranted){
      // final baseStorage = Platform.isAndroid
      //     // ? await getApplicationDocumentsDirectory() //FOR ANDROID
      //     ? await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)
      //     : await getApplicationDocumentsDirectory();
      if(Platform.isAndroid){
          
          final baseStorage = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
          bool directoryExists = await Directory('$baseStorage/360Financial').exists();
          if(!directoryExists){
            await Directory('$baseStorage/360Financial').create(recursive: true);
          }
          String fullPath = '$baseStorage/360Financial/${await getUnusedFileName(name)}';
          fullPath = '${fullPath.replaceAll('.pdf', '')}.jpeg';
          File(fullPath).writeAsBytes(image);
          showSnackBar(context, "Image file has been saved to your downloads", null);
      }else{
        final baseStorage = await getApplicationDocumentsDirectory();
          bool directoryExists = await Directory('${baseStorage.path}/360Financial').exists();
          if(!directoryExists){
            await Directory('${baseStorage.path}/360Financial').create(recursive: true);
          }
          String fullPath = '${baseStorage.path}/360Financial/${await getUnusedFileName(name)}';
          fullPath = '${fullPath.replaceAll('.pdf', '')}.jpeg';
          File(fullPath).writeAsBytes(image);
          showSnackBar(context, "Image file has been saved", null);
      }  
    }
  }


  void setDownloading(){
    downloading = true;
    notifyListeners();
  }

  void setDownloaded(int downl){
    downloaded = downl.toString();
    notifyListeners();
  }
  
  void downloadFun(String url, context, name)async{
    final status = await Permission.storage.request();
    if (status.isGranted){
      if(Platform.isAndroid){
        final baseStorage = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS); //FOR ANDROID
        bool directoryExists = await Directory('$baseStorage/360Financial').exists();
          if(!directoryExists){
            await Directory('$baseStorage/360Financial').create(recursive: true);
        }

        try {
          // showSnackBar(context, "File is downloading", null);
            await Dio().download(
                url, 
                '$baseStorage/360Financial/${name.toString().replaceAll('.pdf', '')}.pdf',
                onReceiveProgress: (received, total) {
                  if(true){
                    downloaded = "$received";
                    notifyListeners();
                  }
                  });
              setLoaderOff();
              downloading = false;
              downloaded = "0";
              notifyListeners();
              showSnackBar(context, "File has been downloaded to your downloads folder", null);
        } on DioError catch (e) {
          downloading =false;
          setLoaderOff();
          notifyListeners();
          showSnackBar(context, "Sorry something went wrong", Colors.red);
          // print(e.message);
        }on SocketException{
          downloading =false;
          setLoaderOff();
          notifyListeners();
          showSnackBar(context, "Sorry something went wrong", Colors.red);
        }
        
      }else{
        final baseStorage = await getApplicationDocumentsDirectory();

        bool directoryExists = await Directory('${baseStorage.path}/360Financial').exists();
          if(!directoryExists){
            await Directory('${baseStorage.path}/360Financial').create(recursive: true);
        }

        try {
            // showSnackBar(context, "File is downloading", null);
            await Dio().download(
                url, 
                '${baseStorage.path}/360Financial/${name.toString().replaceAll('.pdf', '')}.pdf',
                onReceiveProgress: (received, total) {
                  if(true){
                    downloaded = "$received";
                    notifyListeners();
                  }
                  });
              setLoaderOff();
              downloading = false;
              downloaded = "0";
              notifyListeners();
              showSnackBar(context, "File has been downloaded", null);
        } on DioError catch (e) {
          downloading =false;
          notifyListeners();
          setLoaderOff();
          showSnackBar(context, "Sorry something went wrong", Colors.red);
          // print(e.message);
        }

        // showSnackBar(context, "File is downloading", null);
      }
    }
  }

  void deleteScan(index)async{
    setLoaderOn();
    var box = await Hive.openBox<ScanModel>('scans');
    box.deleteAt(index);
    getSavedPdf();

    setLoaderOff();
  }

  void showMenu(String shareUrl, bool online, context, index, bool? paid, bool? signed) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: ()async{
                        Navigator.pop(context);
                        sharingPDF(path: shareUrl,online: online, context: context, paid: paid, signed: signed);
                      },
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children:  [
                              Image.asset("assets/img/share.png", color: orangeColor2, height: 20,),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Share",
                                style: textStyle.copyWith(color: orangeColor2),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if(online != true)
                    InkWell(
                      onTap: ()async{
                        Navigator.pop(context);
                
                        deleteScan(index);
                      },
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children:  [
                              Image.asset("assets/img/delete.png", color: orangeColor2, height: 20,),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Delete",
                                style: textStyle.copyWith(color: orangeColor2),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  void logout(context) async {
    loading = true;
    notifyListeners();

    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    pref.setBool('installed', true);
    await FirebaseAuth.instance.signOut();
    userData = UserModel();
    _receivedDocs = [];
    receivedDocs = [];
    _sentDocs = [];
    sentDocs = [];
    _myScans = [];
    myScans = [];
    myArchives =[];
    loading = false;
    notifyListeners();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }

  void setLoaderOff() {
    loading = false;
    downloading = false;
    notifyListeners();
  }

  void setLoaderOn() {
    loading = true;
    notifyListeners();
  }

  img.Image grayscale(img.Image src) {
    var p = src.getBytes();
    for (var i = 0, len = p.length; i < len; i += 4) {
      var l = img.getLuminanceRgb(p[i], p[i + 1], p[i + 2]);

      p[i] = l;
      p[i + 1] = l;
      p[i + 2] = l;
    }
    return src;
  }

  void markAsRead(notificationId)async{
    final token = await SharedData.getToken();
    final url = baseUrl + "notifications/$notificationId";

    http.Response response =
    await http.patch(Uri.parse(url), headers: {apiTokenKey:token});

    if(response.statusCode == 200){
      print("Successful");
      fetchNotication();
    }
    else{
      print("Failed");
      print(response.body);
    }
  }


  void confirmNotificationDelete(BuildContext context, notificationId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Notification'),
          content: const Text(
              'Proceed to delete notification?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteNotification(notificationId);
              },
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }


  void deleteNotification(notificationId)async{
    final token = await SharedData.getToken();
    final uid = await SharedData.getId();
    final url = baseUrl + "notifications/$uid/$notificationId";

    http.Response response =
    await http.patch(Uri.parse(url), headers: {apiTokenKey:token});

    if(response.statusCode == 200){
      print("Successful");
      fetchNotication();
    }
    else{
      print("Failed");
      print(response.body);
    }
  }

  void navigate(Widget widget, context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  void resetFilename(){
    filename = "";
    notifyListeners();
  }

  Future<String> getUnusedFileName(String name) async {
    String path = name;
    int counter = 1;
    while (true) {
      if (await File(path).exists()) {
        List split = path.split('/');
        filename = split.last;
        filename = filename.split('.').first;
        filename = filename + '-' + '$counter.pdf';
        split.last = filename;
        return split.join('/');
      } else {
        break;
      }
    }
    return path;
  }

  Future<String> getFilePath({String? type, name = ""}) async {
    if (type == 'image') {
      String path = await createFolder(scannedImagesFolder);
      path = [path, '${DateTime.now()}.png'].join('/');
      return path;
    } else {
      String path = await createFolder(savedDocsFolder);
      path = [path, '${name}.pdf'].join('/');

      path = await getUnusedFileName(path);
      return path;
    }
  }

  void printing({String? path, bool? online}) async {
    setLoaderOn();
    File? pdf;

    if(online!=null) {
      await http.get(Uri.parse(path!)).then((res)async{
        if(res.statusCode < 206){
          final filePath = await getFilePath(type: "pdf",name: "printing-doc");
          await File(filePath).writeAsBytes(res.bodyBytes);
          pdf = File(filePath);
        }
      });
    }else{
      pdf = File(path!);
    }
    setLoaderOff();
    await Printing.layoutPdf(onLayout: (_) => pdf!.readAsBytesSync());
  }

  void sharingPDF({String? path, bool? online,bool? paid, bool? signed, BuildContext? context}) async {
    setLoaderOn();
    File? pdf;

    if(online!=null && online) {
      if(paid == null){
        await http.get(Uri.parse(path!)).then((res)async{
        if(res.statusCode < 206){
          final filePath = await getFilePath(type: "pdf",name: "printing-doc");
          await File(filePath).writeAsBytes(res.bodyBytes);
          pdf = File(filePath);
        }
      });
      }
      else{
        if(paid){
          if(signed!){
            await http.get(Uri.parse(path!)).then((res)async{
            if(res.statusCode < 206){
              final filePath = await getFilePath(type: "pdf",name: "printing-doc");
              await File(filePath).writeAsBytes(res.bodyBytes);
              pdf = File(filePath);
            }
      });
          }else{
              showSnackBar(context, "Please you need to sign before you can share this document", Colors.red);
          }
        }else{
          showSnackBar(context, "Please you need to pay and sign before you can share this document", Colors.red);
        }
      }
    }else{
      pdf = File(path!);
    }
    setLoaderOff();
    // await Printing.layoutPdf(onLayout: (_) => );
    await Printing.sharePdf(bytes: await pdf!.readAsBytesSync(), filename: 'my-document.pdf');
  }

  Future<String> createFolder(String cow) async {
    final dir = Directory('${(Platform.isAndroid
                ? await getExternalStorageDirectory() //FOR ANDROID
                : await getApplicationSupportDirectory() //FOR IOS
            )!
            .path}/$cow');

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return dir.path;
    } else {
      dir.create(recursive: true);
      return dir.path;
    }
  }

  //  void createDownloadFolder(String cow) async {
  //   var status = await Permission.storage.status;
  //   if(!status.isGranted){
  //     await Permission.storage.request();
  //   }

  //   if(Platform.isAndroid){
  //         final baseStorage = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  //         final dir = '$baseStorage/360Financial';
  //         if ((await dir.exists())) {
  //           return dir.path;
  //         }
  //     }else{
  //       final baseStorage = await getApplicationDocumentsDirectory();
  //       final dir = '${baseStorage.path}/360Financial';
  //     }


  //   if ((await dir.exists())) {
  //     return dir.path;
  //   } else {
  //     dir.create(recursive: true);
  //     return dir.path;
  //   }
  // }

  void clearScanData() async {
    for (String img in scannedImages) {
      await File(img).delete();
    }
    scannedImages = [];
    filename = "";

    notifyListeners();
  }

  void displayUploadDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Document Upload'),
          content: const Text(
              'You are not authorized to upload documents at the moment. Talk to the admin to give you permission.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Message()));
              },
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void uploadPDF(String? path, note, context) async {
    List data = [];
    Navigator.pop(context);
    sendingPDF(path, note, context);
  }

  void sendingPDF(String? path, String note, context) async {
    loading = true;
    notifyListeners();

    try {
      final token = await SharedData.getToken();
      final uid = await SharedData.getId();

      Map<String, String> _data = {
        "userId": uid.toString(),
        if(note.isNotEmpty)
        "note": note,
      };

      final response =
          http.MultipartRequest('POST', Uri.parse("${baseUrl}document/upload"));

      response.files.add(
        await http.MultipartFile.fromPath("file", path!).timeout(
          const Duration(minutes: 2),
        ),
      );

      response.fields.addAll(_data);

      response.headers[apiTokenKey] = "$token";

      var streamedResponse = await response.send();
      var res = await http.Response.fromStream(streamedResponse);

      loading = false;
      notifyListeners();
      print("***&&&********");
      if (res.statusCode == 200) {
        print("Success");
        fetchSentDocs();
        final message = json.decode(res.body)['message'];
        showSnackBar(context, message, null);

      } else {
        final message = json.decode(res.body)['error'];
        showSnackBar(context, message, null);
      }
    } on SocketException {
      setLoaderOff();
      showSnackBar(context, "No internet", Colors.red);
    }on TimeoutException{
      setLoaderOff();
      showSnackBar(context, "Slow internet", Colors.red);
    }
  }

  bool canUploadPDF() {
    return userData!.canUpload!;
  }

  void updateProfile(
      {String? name,
      String? email,
      String? phone,
      String? dob,
      String? imagePath,
      BuildContext? context}) async {

    loading = true;
    notifyListeners();

    final token = await SharedData.getToken();
    final uid = await SharedData.getId();
    print(token);
    print(uid);

    Map<String, String> _data = {
      "userId": uid,
      "fullName": name!,
      if (dob != null) "dob": dob,
      "email": email!,
      if (phone != null) "phoneNumber": phone,
      "existingEmail": userData!.email!
    };

    final response =
        http.MultipartRequest('PATCH', Uri.parse("${baseUrl}profile"));
    if (imagePath != null) {
      response.files.add(
        await http.MultipartFile.fromPath("file", imagePath,
                contentType: MediaType("image", "jpeg"))
            .timeout(
          const Duration(minutes: 2),
        ),
      );
    }

    response.fields.addAll(_data);

    response.headers[apiTokenKey] = "$token";

    var streamedResponse = await response.send();
    var res = await http.Response.fromStream(streamedResponse);

    loading = false;
    notifyListeners();

    if (res.statusCode == 200) {
      print("Success");
      showSnackBar(context, json.decode(res.body)['message'], null);
      fetchUserDetails();
    } else {
      print("Failed");
      print(res.body);
      showSnackBar(context, json.decode(res.body)['error'], null);
    }
  }


  void sendSignDocRequest(id, filePath, context)async{
    try {
      final token = await SharedData.getToken();
      final uid = await SharedData.getId();

      Map<String, String> _data = {
        "userId": uid.toString(),
        "docId": id,
      };

      final response =
      http.MultipartRequest('PATCH', Uri.parse("${baseUrl}document/sign"));
      print("STARTING.....");

      final bytes = await File(filePath).readAsBytes();
      final filename = filePath.split("/").last;
      response.files.add(
        await http.MultipartFile.fromBytes("file",bytes, filename: filename),
      );
      print("DONE.....");
      response.fields.addAll(_data);

      response.headers[apiTokenKey] = "$token";


      var streamedResponse = await response.send();
      await http.Response.fromStream(streamedResponse).then((res){
        print("DONE...........");
        if (res.statusCode == 200) {
          loading = false;
          notifyListeners();
          showSnackBar(context, json.decode(res.body)['message'], null);
          fetchReceivedDocs();
        } else {
          setLoaderOff();
          showSnackBar(context, json.decode(res.body)['error'], Colors.red);
        }
      });

    } on SocketException {
      setLoaderOff();
      showSnackBar(context, "No internet connection", Colors.red);
    }
  }

  void signingDocuments(String pdfPath,Uint8List imageList, context, String docId)async{
    try{
      await http.get(Uri.parse(pdfPath)).then((response)async{
          if(response.statusCode < 206){
          // final filePath = await getFilePath(type: "pdf", name: "signed-doc");
          // File(filePath).writeAsBytes(response.bodyBytes);
          
          final PdfDocument document = PdfDocument(inputBytes: response.bodyBytes);
           final PdfPage page = document.pages[document.pages.count-1];
            final PdfBitmap image = PdfBitmap(imageList);
            page
                .graphics
                .drawImage(image,  Rect.fromLTWH((page.size.width * 0.42), (page.size.height * 0.45), (page.size.width * 0.15), (page.size.height * 0.1)));
            
          final filePath = await getFilePath(type: "pdf", name: "signed-doc");
            //Save the document.
          await File(filePath).writeAsBytes(await document.save()).then((value){
            sendSignDocRequest(docId, filePath, context);
            document.dispose();
          });
          
        }
      });
      
    }on SocketException{
      setLoaderOff();
      showSnackBar(context, "No internet connection", Colors.red);
    }

  }

  // Filtering Feature
  //
  // void searchRecentScans(query, sort){
  //   myScans = myScans.;
  //
  //   notifyListeners();
  // }

  void setFilter(int value){
    filter = value;
  }

  void filterList(filter, look){
    if(look == "scans"){
      if(filter == 1){
        myScans.sort((a,b)=> a.createdAt.compareTo(b.createdAt));
      }
      else if(filter ==2){
        myScans.sort((a,b)=> b.title.compareTo(a.title));
      }else{
        myScans.sort((a,b)=> a.title.compareTo(b.title));
      }
    }else if (look == "sent"){
      if(filter == 1){
        sentDocs.sort((a,b)=> a.createdOn!.compareTo(b.createdOn!));
      }
      else if(filter ==2){
        sentDocs.sort((a,b)=> a.fileName!.compareTo(b.fileName!));
      }else{
        sentDocs.sort((a,b)=> a.fileName!.compareTo(b.fileName!));
        sentDocs = sentDocs.reversed.toList();
      }
    }else if (look == "received"){
      if(filter == 1){
        receivedDocs.sort((a,b)=> a.createdOn!.compareTo(b.createdOn!));
      }
      else if(filter ==2){
        receivedDocs.sort((a,b)=> a.fileName!.compareTo(b.fileName!));
      }else{
        receivedDocs.sort((a,b)=> a.fileName!.compareTo(b.fileName!));
        receivedDocs = receivedDocs.reversed.toList();
      }
    }else if(look == "archive"){
      if(filter == 1){
        myArchives.sort((a,b)=> a.createdOn!.compareTo(b.createdOn!));
      }
      else if(filter ==2){
        myArchives.sort((a,b)=> a.fileName!.compareTo(b.fileName!));
      }else{
        myArchives.sort((a,b)=> a.fileName!.compareTo(b.fileName!));
        myArchives = myArchives.reversed.toList();
      }
    }

    notifyListeners();
  }


  //: _sentDocs!.where((element) => element!.fileName!.contains(sentSearch)).toList()
  void searchScans(String query){
    scanSearch = query;
    myScans = _myScans.where((element) => element.title.contains(scanSearch)).toList();
    notifyListeners();
  }

  void searchSent(String query){
    sentSearch = query;
    sentDocs = _sentDocs!.where((element) => element.fileName!.contains(sentSearch)).toList();
    notifyListeners();
  }

  void searchReceived(String query){
    receivedSearch = query;
    receivedDocs = _receivedDocs!.where((element) => element.fileName!.contains(scanSearch)).toList();
    // notifyListeners();
  }




  // Payment Operation - Stripe
  Future<void> makePayment(
      {required String amount, required String docId, required BuildContext context}) async {
    try {
      
      setLoaderOn();
      paymentIntentData = await createPaymentIntent(amount);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              applePay: false,
              googlePay: false,
              testEnv: true,
              customFlow: true,
              merchantCountryCode: 'US',
              merchantDisplayName: '360 Financial P.C.',
              customerId: userData!.customerId,
              paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
              customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
            )).then((value){
              setLoaderOff();
          displayPaymentSheet(context,docId);
        });
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }


  void declineDocs(String id, context)async{
    // Navigator.pop(context);
    setLoaderOn();
    final uid = await SharedData.getId();
    final token = await SharedData.getToken();
    final url = baseUrl + "document/$uid/$id";
    try{
      http.Response response = await http.delete(Uri.parse(url),
    headers: {apiTokenKey:token}
    );

    if(response.statusCode < 206){
      print("STARTING.... new 1");
      setLoaderOff();
      showSnackBar(context, "Document has been declined successfully", null);
      fetchReceivedDocs();
      Navigator.pop(context);
    }
    else{
      print("STARTING.... new 2");
      setLoaderOff();
      showSnackBar(context, "Something went wrong, try again", Colors.red);
    }
    }on SocketException{
      setLoaderOff();
      showSnackBar(context, "No internet connection", Colors.red);
    }
  }

  void updateDocument(docId, context)async{
    final uid = await SharedData.getId();
    final token = await SharedData.getToken();
    final _data = {
      "docId":docId,
      "userId":uid
    };

    const _url = baseUrl + "document/update";
    http.Response response = await http.patch(Uri.parse(_url), body: _data,
    headers: {
      apiTokenKey:token,
    }
    );
    if(response.statusCode==200){
      final data = json.decode(response.body);
      print("ALLL DONE");
      fetchReceivedDocs();
      setLoaderOff();
      showSnackBar(context, data['message'], null);
      Navigator.pop(context);
    }else{
      print("NOT ALLL DONE");
      setLoaderOff();
      final data = json.decode(response.body);
      showSnackBar(context, data['error'], null);
    }

  }

  displayPaymentSheet(context, docId) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value)async{
        try{
          setLoaderOn();
          await Stripe.instance.confirmPaymentSheetPayment().then((value){
            print("Sucessful Payment");
            updateDocument(docId,context);
            paymentIntentData = null;
          });
          
        }catch(e){
          setLoaderOff();
          print("Payment failed");
        }

      });
      
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  //  Future<Map<String, dynamic>>
  Future<Map<String, dynamic>?>? createPaymentIntent(String currency) async {
    final token = await SharedData.getToken();

    try {
      Map<String, dynamic> body = {
        'amount': settings.signatureAmount!,
        'customerId':userData!.customerId!
      };
      var response = await http.post(
          Uri.parse(baseUrl + "users/payment"),
          body: body,
          headers: {
            // HttpHeaders.authorizationHeader: 'Bearer $stripeSecretKey',
            apiTokenKey:token,
            // 'Authorization': "Bearer $"
          }).timeout(const Duration(seconds: 16), onTimeout: (){
            setLoaderOff();
            throw TimeoutException("No internet");
          },);
      return json.decode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }

  // calculateAmount(String amount) {
  //   final a = (double.parse(amount));
  //   return a.toString();
  // }



  // DATABASE OPERATIONS

  // Save Scanned Document into DB
  void savePdf(ScanModel doc) async {
    var box = await Hive.openBox<ScanModel>('scans');
    box.add(doc);
    getSavedPdf();
  }

  // Retrieve objects from DB
  void getSavedPdf() async {
    var box = await Hive.openBox<ScanModel>('scans');
    _myScans = box.values.where((element) => element.userId == userId).toList().reversed.toList();
    myScans = _myScans;
    notifyListeners();
  }

// void resetController(){
//   scanController = DocumentScannerController();
//   notifyListeners();
// }

}

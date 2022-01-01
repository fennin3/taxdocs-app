import 'dart:io';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);


  void _imageModalSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _pickImage(true),
                  child: Card(
                    color: orangeColor2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric( vertical: 10.0, horizontal: 15),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Camera",
                            style: textStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () => _pickImage(false),
                  child: Card(
                    color: orangeColor2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric( vertical: 10.0, horizontal: 15),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.photo,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Gallery",
                            style: textStyle,
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

  void _pickImage(bool cam) async {
    final XFile? image = await _picker.pickImage(
        source: cam ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      _image = image;
    });
    Navigator.pop(context);
  }

  void setInit() {
    final app = Provider.of<appState>(context, listen: false);
    setState(() {
      _name.text = app.userData!.displayName ?? '';
      _email.text = app.userData!.email ?? '';
      _phone.text = app.userData!.phoneNumber ?? '';
      _dob.text = app.userData!.dob ?? '';
    });
  }




  Future<void> _onRefresh()async{
    final app = Provider.of<appState>(context, listen: false);
    app.fetchUserDetails();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    setInit();
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _dob.dispose();
    _refreshController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context, listen: true);
    // print("ProfilePic URL = ${app.userData!.photoURL}");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: backArrowColor),
        centerTitle: false,
        title: Text(
          "Profile",
          style: textStyle.copyWith(fontSize: 18, color: blue),
        ),
      ),
      backgroundColor: Colors.white,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: size.height * 0.072,
                                  backgroundColor: orangeColor2,
                                  child: CircleAvatar(
                                    radius: size.height * 0.07,
                                    backgroundColor:
                                        const Color.fromRGBO(216, 216, 216, 1),
                                    backgroundImage:
                                        FileImage(File(_image!.path)),
                                  ))
                              : CircleAvatar(
                                  radius: size.height * 0.072,
                                  backgroundColor: orangeColor2,
                                  child: CircleAvatar(
                                    radius: size.height * 0.07,
                                    backgroundColor:
                                        const Color.fromRGBO(216, 216, 216, 1),
                                    backgroundImage: app.userData!.photoURL !=
                                            null
                                        ? NetworkImage(app.userData!.photoURL!)
                                        : null,
                                  ),
                                ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () => _imageModalSheet(),
                                child: CircleAvatar(
                                  backgroundColor: orangeColor2,
                                  radius: size.height * 0.02,
                                  child: const FittedBox(
                                      child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                                ),
                              ))
                        ],
                      )),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Container(
                          width: 327,
                          height: 56,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(46, 46, 46, 0.04)),
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Center(
                            child: TextField(
                              cursorColor: blue,
                              controller: _name,
                              style: textStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: blue),
                              decoration:
                                  const InputDecoration(border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Container(
                          width: 327,
                          height: 56,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(46, 46, 46, 0.04)),
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Center(
                            child: TextField(
                              controller: _email,
                              cursorColor: blue,
                              style: textStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: blue),
                              decoration:
                                  const InputDecoration(border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Container(
                          width: 327,
                          height: 56,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(46, 46, 46, 0.04)),
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: Center(
                            child: TextField(
                              controller: _phone,
                              cursorColor: blue,
                            
                              style: textStyle.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: blue),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(fontSize: 17, color: blue),
                                  hintText: "Phone number (+233540667788)"),
                                
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: InkWell(
                          onTap: ()=>showBirthDayPicker(),
                          child: Container(
                            width: 327,
                            height: 56,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(46, 46, 46, 0.04)),
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: Center(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextField(
                                        enabled: false,
                                    controller: _dob,
                                    cursorColor: blue,
                                    style: textStyle.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: blue),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Date of Birth"),
                                  )),
                                  InkWell(
                                    onTap: ()=>showBirthDayPicker(),
                                    child: const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 28,
                                      color: blue,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 42,
                      ),
                      InkWell(
                        onTap: () => app.updateProfile(
                            name: _name.text,
                            context: context,
                            dob: _dob.text.isEmpty ? null : _dob.text,
                            email: _email.text,
                            imagePath: _image != null ? File(_image!.path).path : null,
                            phone: _phone.text.isNotEmpty ? _phone.text : null),
                        child: Container(
                          height: 50,
                          width: 327,
                          decoration: BoxDecoration(
                              color: orangeColor2,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Center(
                            child: Text(
                              "Save Changes",
                              style: textStyle,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showBirthDayPicker()async{
    await showDatePicker(context: context, initialDate: DateTime(DateTime.now().year), firstDate: DateTime(1950), lastDate: DateTime.now()).then((value){
      setState(() {
        _dob.text = "${value!.year}-${value.month}-${value.day}";
      });
    });
  }
}

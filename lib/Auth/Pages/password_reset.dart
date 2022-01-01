import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Components/logo_widget.dart';
import 'package:taxdocs/Auth/constant.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';


class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController _email = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context, listen: true);
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: app.loading,
        progressIndicator: spinWidget,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.01,),
                Hero(tag: "logo", child: LogoWidget(size: size),),
                SizedBox(height: size.height * 0.035,),
                SizedBox(
                    width: size.width * 0.8,
                    child: const Text("Reset Password", style: welcomeStyle,)),
          
                SizedBox(height: size.height * 0.07,),
          
                SizedBox(
                    width: size.width * 0.8,
                    child: const Text("Forgot Password", style: signInStyle,)),
          
                SizedBox(height: size.height * 0.026,),
          
                SizedBox(
                  width: size.width * 0.8,
                  child: Column(
          
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Center(
                          child: TextFormField(
                            controller: _email,
                            decoration: const InputDecoration(hintText: "Email",
                                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(46, 46, 46, 0.44)),
                                border: InputBorder.none
                            ),
                            cursorColor: blue,
                          ),
                        ),
                        height: 60,
                        decoration: BoxDecoration(color: const Color.fromRGBO(46, 46, 46, 0.04), borderRadius: BorderRadius.circular(10)),
                      ),
          
                    ],),
                ),
                SizedBox(height: size.height * 0.04,),
                SizedBox(
                  width: size.width * 0.8,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: ()=> Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false),
                          child: const Text("Back to Login", style: TextStyle(color: Color.fromRGBO(5, 30, 86, 1), fontSize: 14, fontWeight: FontWeight.w500),))),
                ),
                SizedBox(height: size.height * 0.04,),
                InkWell(
                  onTap: ()=>app.passwordReset(_email.text, context),
                  child: Container(
                    height: 58,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                        color: orangeColor,
                        borderRadius: BorderRadius.circular(29)
                    ),
                    child: const Center(child: Text("Send Request", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),),),
                  ),
                ),
      
              ],
            ),
          ),
        ),
      ),
    );
  }
}

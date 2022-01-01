import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Components/logo_widget.dart';
import 'package:taxdocs/Auth/constant.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final _key = GlobalKey<FormState>();


  @override
  void dispose() {
    // TODO: implement dispose
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<appState>(context);
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: app.loading,
        progressIndicator: spinWidget,
        child: SafeArea(child:
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.01,),
              Hero(tag: "logo", child: LogoWidget(size: size),),
              SizedBox(height: size.height * 0.035,),
              SizedBox(
                  width: size.width * 0.8,
                  child: const Text("Get Started", style: welcomeStyle,)),

              SizedBox(height: size.height * 0.07,),

              SizedBox(
                  width: size.width * 0.8,
                  child: const Text("Register", style: signInStyle,)),

              SizedBox(height: size.height * 0.02,),

              SizedBox(
                width: size.width * 0.8,
                child: Form(
                  key: _key,
                  child: Column(

                    children: [

                      // Name
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Center(
                          child: TextFormField(
                            controller: _fullName,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter full name";
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: const InputDecoration(hintText: "Full Name",
                                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(46, 46, 46, 0.44)),
                                border: InputBorder.none
                            ),
                            cursorColor: blue,
                          ),
                        ),
                        height: 60,
                        decoration: BoxDecoration(color: const Color.fromRGBO(46, 46, 46, 0.04), borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(height: size.height * 0.025,),

                      // Email
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Center(
                          child: TextFormField(
                            controller: _email,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter email";
                              }
                              else if(!value.contains("@") || !value.contains(".com")){
                                return "Enter a valid email";
                              }
                              else{
                                return null;
                              }
                            },
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
                      SizedBox(height: size.height * 0.025,),

                      // Password
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Center(
                          child: TextFormField(
                            controller: _password,
                            autocorrect: false,
                            obscureText: true,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter password";
                              }
                              else if(value.length < 6){
                                return "Password length must be more than 6";
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: const InputDecoration(hintText: "Password",
                                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Color.fromRGBO(46, 46, 46, 0.44)),
                                border: InputBorder.none
                            ),
                            cursorColor: blue,
                          ),
                        ),
                        height: 60,
                        decoration: BoxDecoration(color: const Color.fromRGBO(46, 46, 46, 0.04), borderRadius: BorderRadius.circular(10)),
                      ),

                      SizedBox(height: size.height * 0.025,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Center(
                          child: TextFormField(
                            controller: _confirmPassword,
                            autocorrect: false,
                            obscureText: true,
                            validator: (value){
                              if(_confirmPassword.text != _password.text){
                                return "Passwords do not match";
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: const InputDecoration(hintText: "Confirm Password",
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
              ),

              SizedBox(height: size.height * 0.065,),
              InkWell(
                onTap: (){
                  if(_key.currentState!.validate()){
                    app.register(_fullName.text, _email.text, _password.text, context);
                  }
                },
                child: Container(
                  height: 58,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                      color: orangeColor,
                      borderRadius: BorderRadius.circular(29)
                  ),
                  child: const Center(child: Text("Register", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),),),
                ),
              ),
              SizedBox(height: size.height * 0.048,),


              RichText(text:  TextSpan(
                  text: "Already have an account? ",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                  children: [
                    TextSpan(text: " Login",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textBlue),
                      recognizer: TapGestureRecognizer()..onTap = (){
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      }
                    )
                  ]
              ))

            ],
          ),
        ),
        ),
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Auth/constant.dart';
import 'package:taxdocs/Components/logo_widget.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
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
                    child: const Text("Welcome Back!", style: welcomeStyle,)),

                SizedBox(height: size.height * 0.07,),

                SizedBox(
                    width: size.width * 0.8,
                    child: const Text("Sign In", style: signInStyle,)),

                SizedBox(height: size.height * 0.02,),

                SizedBox(
                  width: size.width * 0.8,
                  child: Form(
                    key: _key,
                    child: Column(

                      children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        height: 60,
                        decoration: BoxDecoration(color: const Color.fromRGBO(46, 46, 46, 0.04), borderRadius: BorderRadius.circular(10)),
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
                      ),
                      SizedBox(height: size.height * 0.025,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        height: 60,
                        decoration: BoxDecoration(color: const Color.fromRGBO(46, 46, 46, 0.04), borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextFormField(
                            obscureText: true,
                            controller: _password,
                            validator: (value){
                              if(value!.isEmpty){
                                return "Enter password";
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
                      ),
                    ],),
                  ),
                ),
                SizedBox(height: size.height * 0.048,),
                SizedBox(
                  width: size.width * 0.8,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: ()=> Navigator.pushNamed(context, "/passwordreset"),
                          child: const Text("Forgot Password ?", style: TextStyle(color: Color.fromRGBO(5, 30, 86, 1), fontSize: 14, fontWeight: FontWeight.w500),))),
                ),
                SizedBox(height: size.height * 0.055,),
                InkWell(
                  onTap: (){
                    if(_key.currentState!.validate()){
                      app.login(_email.text, _password.text, context);
                    }
                  },
                  child: Container(
                    height: 58,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: orangeColor,
                      borderRadius: BorderRadius.circular(29)
                    ),
                    child: const Center(child: Text("Sign In", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),),),
                  ),
                ),
                SizedBox(height: size.height * 0.048,),


                RichText(text:  TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                  children: [
                    TextSpan(text: " Register",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromRGBO(5, 30, 86, 1)),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false);
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


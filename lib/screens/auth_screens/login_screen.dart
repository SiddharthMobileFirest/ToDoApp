import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/bloc/auth_cubit/sign_in_cubit/sign_in_cubit.dart';
import 'package:to_do_app/bloc/auth_cubit/sign_in_cubit/sign_in_state.dart';
import 'package:to_do_app/screens/auth_screens/sign_up_scren.dart';

import '../home_screens/home_screen.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final box = GetStorage();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 1;
    var width = MediaQuery.of(context).size.width * 1;
    ScreenUtil.init(context, designSize: Size(width, height));
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('asset/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 0.085.sw, top: 0.16.sh),
              child: const Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 0.5.sh),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 0.085.sw, right: 0.085.sw),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 0.037.sh,
                          ),
                          TextField(
                            controller: passwordController,
                            style: const TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 0.047.sh,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              BlocConsumer<SignInCubit, SignInState>(
                                listener: (context, state) {
                                  if (state is SignInLoggedInState) {
                                    box.remove('email');
                                    box.write('email', emailController.text);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ));
                                  } else if (state is SignInErrorState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Padding(
                                          padding: const EdgeInsets.all(10.0).r,
                                          child:
                                              Center(child: Text(state.error)),
                                        ),
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        
                                        width: 0.8.sw, // Width of the SnackBar.
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              8.0, // Inner padding for SnackBar content.
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0).r,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is SignInLoadingState) {
                                    return const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Color(0xff4c505b),
                                        child: CircularProgressIndicator());
                                  } else {
                                    return CircleAvatar(
                                      radius: 30,
                                      backgroundColor: const Color(0xff4c505b),
                                      child: IconButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            BlocProvider.of<SignInCubit>(
                                                    context)
                                                .logIn(emailController.text,
                                                    passwordController.text);
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                          )),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 0.048.sh,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScareen(),
                                      ));
                                },
                                style: const ButtonStyle(),
                                child: const Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

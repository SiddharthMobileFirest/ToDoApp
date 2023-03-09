import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/bloc/auth_cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:to_do_app/bloc/auth_cubit/sign_up_cubit/sign_up_state.dart';
import 'package:to_do_app/screens/auth_screens/login_screen.dart';
import 'package:to_do_app/screens/home_screens/home_screen.dart';

import '../../widgets/my_textfield.dart';

class SignUpScareen extends StatefulWidget {
  const SignUpScareen({Key? key}) : super(key: key);

  @override
  _SignUpScareenState createState() => _SignUpScareenState();
}

class _SignUpScareenState extends State<SignUpScareen> {
  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty
        ? !regex.hasMatch(value)
            ? 'Enter a valid email address'
            : null
        : "Please enter a email address";
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 1;
    var width = MediaQuery.of(context).size.width * 1;
    ScreenUtil.init(context, designSize: Size(width, height));
    return Form(
      key: _key,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('asset/register.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 0.080.sw, top: 0.11.sw).r,
                child: Text(
                  'Create\nAccount',
                  style: TextStyle(color: Colors.white, fontSize: 33.sp),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 0.28.sh),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(left: 0.080.sw, right: 0.080.sw).r,
                        child: Column(
                          children: [
                            MyTextField(
                              validator: (value) {
                                if (value == "" || value!.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                              controller: nameController,
                              hint: "Name",
                            ),
                            SizedBox(
                              height: 0.037.sh,
                            ),
                            MyTextField(
                              validator: (value) => validateEmail(value),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              hint: "Email",
                            ),
                            SizedBox(
                              height: 0.037.sh,
                            ),
                            MyTextField(
                              validator: (value) {
                                if (value == "" || value!.isEmpty) {
                                  return 'Please enter a password ';
                                }
                                return null;
                              },
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              hint: "Password",
                            ),
                            SizedBox(
                              height: 0.050.sh,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xff4c505b),
                                  child: BlocConsumer<SignUpCubit, SignUpState>(
                                    listener: (context, state) {
                                      if (state is SignUpLoggedInState) {
                                        box.remove('email');
                                        box.write(
                                            'email', emailController.text);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen(),
                                            ));
                                      } else if (state is SignUpErrorState) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0).r,
                                              child: Center(
                                                  child: Text(state.error)),
                                            ),
                                            duration: const Duration(
                                                milliseconds: 1500),

                                            width: 0.8
                                                .sw, // Width of the SnackBar.
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
                                      if (state is SignUpLoadingState) {
                                        return const CircularProgressIndicator();
                                      }
                                      return IconButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            if (_key.currentState!.validate()) {
                                              BlocProvider.of<SignUpCubit>(
                                                      context)
                                                  .registerUser(
                                                      emailController.text,
                                                      passwordController.text);
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                          ));
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 0.03.sh,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (_key.currentState!.validate()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MyLogin(),
                                          ));
                                    }
                                  },
                                  style: const ButtonStyle(),
                                  child: const Text(
                                    'Sign In',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
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
      ),
    );
  }
}

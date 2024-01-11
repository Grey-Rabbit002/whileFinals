import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:while_app/resources/colors.dart';
import 'package:while_app/resources/components/round_button.dart';
import 'package:while_app/resources/components/text_button.dart';
import 'package:while_app/resources/components/text_container_widget.dart';
import 'package:while_app/utils/routes/routes_name.dart';
import 'package:while_app/utils/utils.dart';

import '../../repository/firebase_repository.dart';
import '../../resources/components/header_widget.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly'
]);

// final loadingStateProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late GoogleSignInAccount currentUser;
  // bool signin = false;
  @override
  void initState() {
    super.initState();
    // _googleSignIn.onCurrentUserChanged.listen((account) {
    //   setState(() {
    //     currentUser = account!;
    //   });
    // });
    // _googleSignIn.signInSilently();
  }

  Future<void> handleSignIn() async {
    try {
      await FirebaseAuthMethods(FirebaseAuth.instance)
          .signInWithGoogle(context);
    } catch (error) {
      log("Sign in error$error");
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                height: 420,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 10,
                      offset: Offset(-4, -4),
                    ),
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: w / 2,
                      height: h / 12,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/while_transparent.png"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    const SizedBox(),
                    TextContainerWidget(
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      prefixIcon: Icons.email,
                    ),
                    TextContainerWidget(
                      hintText: 'Password',
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      prefixIcon: Icons.lock,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.forgot);
                        },
                        child: Text(
                          "Forgot Password?",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: AppColors.theme1Color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ),
                    RoundButton(
                      loading: false,
                      title: 'Login',
                      onPress: () async {
                        if (_emailController.text.isEmpty) {
                          Utils.flushBarErrorMessage(
                              'Please enter email', context);
                        } else if (_passwordController.text.isEmpty) {
                          Utils.flushBarErrorMessage(
                              'Please enter password', context);
                        } else if (_passwordController.text.length < 6) {
                          Utils.flushBarErrorMessage(
                              'Please enter at least 6-digit password',
                              context);
                        } else {
                          context
                              .read<FirebaseAuthMethods>()
                              .loginInWithEmailAndPassword(
                                _emailController.text.toString(),
                                _passwordController.text.toString(),
                                context,
                              );
                          
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "OR",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      // color: AppColors.theme1Color,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 164,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 10,
                      offset: Offset(-4, -4),
                    ),
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(height: 10),
                    RoundButton(
                      loading: false,
                      title: 'Signup with Google',
                      onPress: () {
                        handleSignIn();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    // color: AppColors.theme1Color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RoutesName.signUp);
                          },
                          style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                          ),
                          child: Text(
                            "Signup",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: AppColors.theme1Color,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       Container(
    //         height: h,
    //         width: w,
    //         decoration: const BoxDecoration(
    //           gradient: LinearGradient(
    //             colors: [AppColors.theme1Color, AppColors.buttonColor],
    //           ),
    //         ),
    //       ),
    //       Container(
    //         height: h / 1.2,
    //         width: w,
    //         decoration: const BoxDecoration(
    //           color: Colors.black,
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black87,
    //               offset: Offset(0.0, 1.0),
    //               blurRadius: 6.0,
    //             ),
    //           ],
    //           borderRadius: BorderRadius.only(
    //             bottomLeft: Radius.circular(30),
    //             bottomRight: Radius.circular(30),
    //           ),
    //         ),
    //         child: SingleChildScrollView(
    //           child: Container(
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 const HeaderWidget(title: 'Login'),
    //                 Container(
    //                   height: h / 6,
    //                   width: w / 1.4,
    //                   decoration: const BoxDecoration(
    //                     image: DecorationImage(
    //                       image: AssetImage("assets/while_transparent.png"),
    //                       fit: BoxFit.fill,
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(height: 15),
    //                 TextContainerWidget(
    //                   color: Colors.white,
    //                   keyboardType: TextInputType.emailAddress,
    //                   controller: _emailController,
    //                   prefixIcon: Icons.email,
    //                   hintText: 'Email',
    //                 ),
    //                 const SizedBox(height: 10),
    //                 TextPasswordContainerWidget(
    //                   keyboardType: TextInputType.visiblePassword,
    //                   controller: _passwordController,
    //                   prefixIcon: Icons.lock,
    //                   hintText: 'Password',
    //                 ),
    //                 const SizedBox(height: 10),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     const Text(""),
    //                     InkWell(
    //                       onTap: () {
    //                         Navigator.pushNamed(context, RoutesName.forgot);
    //                       },
    //                       child: const Text(
    //                         "Forgot Password?",
    //                         style: TextStyle(
    //                           color: AppColors.theme1Color,
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.w700,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(height: 10),
    // RoundButton(
    //   loading: false,
    //   title: 'Login',
    //   onPress: () async {
    //     if (_emailController.text.isEmpty) {
    //       Utils.flushBarErrorMessage(
    //           'Please enter email', context);
    //     } else if (_passwordController.text.isEmpty) {
    //       Utils.flushBarErrorMessage(
    //           'Please enter password', context);
    //     } else if (_passwordController.text.length < 6) {
    //       Utils.flushBarErrorMessage(
    //           'Please enter at least 6-digit password',
    //           context);
    //     } else {
    //       context
    //           .read<FirebaseAuthMethods>()
    //           .loginInWithEmailAndPassword(
    //             _emailController.text.toString(),
    //             _passwordController.text.toString(),
    //             context,
    //           );
    //     }
    //   },
    // ),
    //                 SizedBox(height: h * 0.02),
    //                 Row(
    //                   children: [
    //                     const Text(
    //                       "Don't have an account? ",
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                     SizedBox(
    //                       width: h * .02,
    //                     ),
    //                     InkWell(
    //                       onTap: () {
    //                         Navigator.pushNamed(context, RoutesName.signUp);
    //                       },
    //                       child: const Text(
    //                         "Sign Up",
    //                         style: TextStyle(
    //                           color: AppColors.theme1Color,
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       width: h * .02,
    //                     ),
    //                     InkWell(
    //                       onTap: () {
    //                         handleSignIn();
    //                       },
    //                       child: const Text(
    //                         "Google Sign Up",
    //                         style: TextStyle(
    //                           color: AppColors.theme1Color,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

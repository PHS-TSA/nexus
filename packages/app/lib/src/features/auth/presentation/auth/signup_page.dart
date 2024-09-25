import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';
import '../../data/auth_repository.dart';

@RoutePage()
class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namecontroller = TextEditingController();
    final emailcontroller = TextEditingController();
    final passwordcontroller = TextEditingController();

    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pictures/login_image.png'),
            fit: BoxFit.fill, // Need to find a better image or move photo down
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: currentWidth / 4,
            right: currentWidth / 4,
            top: 35,
            bottom: 40,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                255,
                34,
                29,
                43,
              ), //TODO better color for this
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const DecoratedBox(
                    //TODO Redesign this was for testing
                    decoration: BoxDecoration(
                        // color: Colors.white,
                        // border: Border.all(color: Colors.white),
                        // borderRadius: BorderRadius.circular(5),
                        ),
                    child: Text(
                      'Welcome to Nexus!',
                      style: TextStyle(
                        fontSize: 28,
                        color: Color.fromARGB(255, 221, 168, 230),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    controller: namecontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // May need to do cool async things here
                            //login the user
                            // await ref
                            //     .read(authRepositoryProvider)
                            //     .loginUser(
                            //       emailcontroller.text,
                            //       passwordcontroller.text,
                            //     )
                            //     .then((value) {
                            //   if (value) {
                            //     context.router.push(
                            //       const WrapperRoute(),
                            //     );
                            //   } else {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(
                            //         content: Text('Invalid email password'),
                            //       ),
                            //     );

                            //   }
                            // });
                            await ref
                                .read(authRepositoryProvider)
                                .createUser(
                                  namecontroller.text,
                                  emailcontroller.text,
                                  passwordcontroller.text,
                                )
                                .then((value) {
                              if (value == 'success') {
                                //TODO Fix routing
                                context.router.push(const LoginRoute());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(value)),
                                );
                              }
                            });
                            // navigate to the homepage
                          },
                          child: const Text('Sign Up'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextButton(
                      onPressed: () {
                        context.router.push(const LoginRoute());
                      },
                      child: const Text('Back to login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Sign up'),
    //     automaticallyImplyLeading: false,
    //   ),
    //   body: Column(
    //     children: [
    //       TextFormField(
    //         controller: namecontroller,
    //         keyboardType: TextInputType.emailAddress,
    //         decoration: const InputDecoration(
    //           labelText: 'Name',
    //         ),
    //       ),
    //       TextFormField(
    //         controller: emailcontroller,
    //         keyboardType: TextInputType.emailAddress,
    //         decoration: const InputDecoration(
    //           labelText: 'Email',
    //         ),
    //       ),
    //       TextFormField(
    //         controller: passwordcontroller,
    //         obscureText: true,
    //         decoration: const InputDecoration(
    //           labelText: 'Password',
    //         ),
    //       ),
    //       Row(
    //         children: [
    //           ElevatedButton(
    //             onPressed: () {
    //               ref
    //                   .read(authRepositoryProvider)
    //                   .createUser(
    //                     namecontroller.text,
    //                     emailcontroller.text,
    //                     passwordcontroller.text,
    //                   )
    //                   .then((value) {
    //                 if (value == 'success') {
    //                   //TODO Fix routing
    //                   context.router.push(const LoginRoute());
    //                 } else {
    //                   ScaffoldMessenger.of(context)
    //                       .showSnackBar(SnackBar(content: Text(value)));
    //                 }
    //               });
    //             },
    //             child: const Text('Sign Up'),
    //           ),
    //           const SizedBox(
    //             width: 20,
    //           ),
    //           OutlinedButton(
    //             onPressed: () {
    //               context.router.push(const LoginRoute());
    //             },
    //             child: const Text('Login'),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}

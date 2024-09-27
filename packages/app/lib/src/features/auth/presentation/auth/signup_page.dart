import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';
import '../../application/auth_service.dart';

@RoutePage()
class SignupPage extends HookConsumerWidget {
  const SignupPage({void Function({bool didLogIn})? onResult, super.key})
      : _onResult = onResult;

  final void Function({bool didLogIn})? _onResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namecontroller = useTextEditingController();
    final emailcontroller = useTextEditingController();
    final passwordcontroller = useTextEditingController();

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
                          //Don't love button color
                          onPressed: () async {
                            // May need to do cool async things here
                            await ref
                                .read(authServiceProvider.notifier)
                                .createUser(
                                  namecontroller.text,
                                  emailcontroller.text,
                                  passwordcontroller.text,
                                );

                            // check that the widget still exists after the async operation
                            if (!context.mounted) return;

                            switch (ref.read(authServiceProvider)) {
                              case AsyncData():
                                // navigate to the homepage
                                await context.router
                                    .push(LoginRoute(onResult: _onResult));
                              case AsyncError(:final error):
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                  ), //Change to theme color
                                );
                            }
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
                        context.router.push(LoginRoute(onResult: _onResult));
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
  }
}

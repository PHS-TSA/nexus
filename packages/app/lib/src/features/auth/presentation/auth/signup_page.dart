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
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // TODO(lishaduck): Figure out how to remove nested scaffolds.
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pictures/login_image.png'),
            // TODO(MattsAttack): I need to find a better image or move the photo down.
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            // `MediaQuery`s shouldn't be cached, it makes them potentially less responsive.
            left: MediaQuery.sizeOf(context).width / 4,
            right: MediaQuery.sizeOf(context).width / 4,
            top: 35,
            bottom: 40,
          ),
          child: Container(
            decoration: BoxDecoration(
              // TODO(MattsAttack): Find a better color for this (use Theme.of(context).someColor).
              color: const Color.fromARGB(
                255,
                34,
                29,
                43,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              // TODO(lishaduck): This should be a `Form`, and support validation.
              child: Column(
                children: [
                  const DecoratedBox(
                    // TODO(MattsAttack): Redesign this, it was for testing.
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
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // TODO(lishaduck): Maybe add a password reverification field.
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          // TODO(MattsAttack): I don't don't love the button color, it could be improved.
                          onPressed: () async {
                            await ref
                                .read(authServiceProvider.notifier)
                                .createUser(
                                  nameController.text,
                                  emailController.text,
                                  passwordController.text,
                                );

                            // Check that the widget still exists after the async operation.
                            if (!context.mounted) return;
                            switch (ref.read(authServiceProvider)) {
                              case AsyncData(:final value) when value != null:
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
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextButton(
                      onPressed: () async {
                        await context.router
                            .push(LoginRoute(onResult: _onResult));
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

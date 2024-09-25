import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';
import '../../data/auth_repository.dart';

@RoutePage()
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailcontroller = TextEditingController();
    final passwordcontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextFormField(
              controller: emailcontroller,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 10,
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
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // May need to do cool async things here
                      //login the user
                      ref
                          .read(authRepositoryProvider)
                          .loginUser(
                            emailcontroller.text,
                            passwordcontroller.text,
                          )
                          .then((value) {
                        if (value) {
                          context.router.push(
                              const WrapperRoute()); //TODO fix to not have back button
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid email password'),
                            ),
                          );
                        }
                      });

                      //navigate to the homepage
                    },
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.router.push(const SignupRoute());
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

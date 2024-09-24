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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          TextFormField(
            controller: namecontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextFormField(
            controller: emailcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextFormField(
            controller: passwordcontroller,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  ref
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
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value)));
                    }
                  });
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(
                width: 20,
              ),
              OutlinedButton(
                onPressed: () {
                  context.router.push(const LoginRoute());
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

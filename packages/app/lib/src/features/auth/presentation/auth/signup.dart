import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  // createUser(namecontroller.text, emailcontroller.text,
                  //         passwordcontroller.text)
                  //     .then((value) {
                  //   if (value == 'success') {
                  //     Navigator.pop(context);
                  //   } else {
                  //     ScaffoldMessenger.of(context)
                  //         .showSnackBar(SnackBar(content: Text(value)));
                  //   }
                  // });
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(
                width: 20,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
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

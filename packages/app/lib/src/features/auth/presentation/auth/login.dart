import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      //login the user

                      // loginUser(emailcontroller.text, passwordcontroller.text)
                      //     .then((value) {
                      //   if (value) {
                      //     Navigator.pushReplacementNamed(context, '/home');
                      //   } else {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //         content: Text('Invalid email password'),
                      //       ),
                      //     );
                      //   }
                      // });

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
                      Navigator.pushNamed(context, '/signup');
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

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CheckUserAuth extends StatefulWidget {
  const CheckUserAuth({super.key});

  @override
  State<CheckUserAuth> createState() => _CheckUserAuthState();
}

class _CheckUserAuthState extends State<CheckUserAuth> {
  @override
  void initState() {
    checkUserAuth().then((value) {
      if (value) {
        // if user is authenticated
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // if not authenticated
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

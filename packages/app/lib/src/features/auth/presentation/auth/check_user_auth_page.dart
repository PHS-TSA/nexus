// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// @RoutePage()
// class CheckUserAuthPage extends ConsumerWidget {
//   const CheckUserAuthPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//     // return Scaffold(

//     //   // body: Center(
//     //   //   child: Column(
//     //   //     children: [
//     //   //       IconButton(
//     //   //         onPressed: () async {
//     //   //           final isLoggedIn =
//     //   //               await ref.read(authRepositoryProvider).checkUserAuth();

//     //   //           if (isLoggedIn) {
//     //   //             // if user is authenticated
//     //   //             await context.router.push(const WrapperRoute());
//     //   //           } else {
//     //   //             // if not authenticated
//     //   //             // Navigator.pushReplacementNamed(context, '/login');
//     //   //             await context.router.push(const LoginRoute());
//     //   //           }
//     //   //         },
//     //   //         icon: const Icon(Icons.abc),
//     //   //       ),
//     //   //       const CircularProgressIndicator(),
//     //   //     ],
//     //   //   ),
//     //   // ),
//     // );
//   }
// }

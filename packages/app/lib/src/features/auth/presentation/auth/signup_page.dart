import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../app/router.gr.dart';
import '../../application/auth_service.dart';

// TODO(lishaduck): Extract most of this out to a widget that can be shared with the log in page.
// TODO(lishaduck): Rename to `SignUpPage`.
@RoutePage(deferredLoading: true)
class SignupPage extends HookConsumerWidget {
  const SignupPage({
    void Function({bool didLogIn})? onResult,
    super.key,
  }) : _onResult = onResult;

  final void Function({bool didLogIn})? _onResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final name = useState('');
    final email = useState('');
    final password = useState('');

    final handleSubmit = useCallback(
      () async {
        if (formKey.currentState?.validate() ?? false) {
          formKey.currentState?.save();

          await ref
              .read(authServiceProvider.notifier)
              .createUser(name.value, email.value, password.value);

          // Check that the widget still exists after the async operation.
          if (!context.mounted) return;

          switch (ref.read(authServiceProvider)) {
            case AsyncData(:final value)
                when _onResult != null && value != null:
              // Navigate the page the user wanted to go to.

              _onResult(didLogIn: true);

            case AsyncData(): // Value is null!
              // TODO(lishaduck): Move this to the guard.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invalid username and password'),
                ),
              );

            case AsyncError(:final error):
              // TODO(lishaduck): Move this to the guard.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error.toString()),
                ),
              );

            // Do nothing if loading.
          }
        }
      },
      [formKey],
    );

    // TODO(lishaduck): Figure out how to remove nested scaffolds.
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          // `MediaQuery`s shouldn't be cached, it makes them potentially less responsive.
          left: MediaQuery.sizeOf(context).width / 4,
          right: MediaQuery.sizeOf(context).width / 4,
          top: 35,
          bottom: 40,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.pictures.loginImage.provider(),
            // TODO(MattsAttack): I need to find a better image or move the photo down.
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // TODO(MattsAttack): Find a better color for this (use `Theme.of(context).<someColor>`).
            color: const Color.fromARGB(
              255,
              34,
              29,
              43,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: formKey,
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
                      // TODO(MattsAttack): Use `Theme.of(context).<someColor>`.
                      color: Color.fromARGB(255, 221, 168, 230),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  initialValue: name.value,
                  onSaved: (value) {
                    if (value == null) return;

                    name.value = value;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: email.value,
                  onSaved: (value) {
                    if (value == null) return;

                    email.value = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 16),
                // TODO(lishaduck): Maybe add a password reverification field.
                TextFormField(
                  initialValue: password.value,
                  onSaved: (value) {
                    if (value == null) return;

                    password.value = value;
                  },
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    // Makes the button take up the full width of its parent.
                    width: double.infinity,
                    child: ElevatedButton(
                      // TODO(MattsAttack): I don't don't love the button color, it could be improved.
                      onPressed: handleSubmit,
                      child: const Text('Sign Up'),
                    ),
                  ),
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
    );
  }
}

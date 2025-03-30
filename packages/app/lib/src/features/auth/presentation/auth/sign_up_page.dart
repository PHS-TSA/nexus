/// This library provides the UI for signing users up.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/hooks.dart';
import '../../../../utils/responsive.dart';
import '../../../../utils/toast.dart';
import '../../application/auth_service.dart';
import '../../domain/auth_callback.dart';

// TODO(lishaduck): Extract most of this out to a widget that can be shared with the log in page.

/// {@template harvest_hub.features.auth.presentation.auth.sign_up_page}
/// A page that displays an interface for signing up new users.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class SignUpPage extends HookConsumerWidget {
  /// {@macro harvest_hub.features.auth.presentation.auth.sign_up_page}
  ///
  /// Construct a new [SignUpPage] widget.
  const SignUpPage({super.key, AuthCallback? onResult}) : _onResult = onResult;

  final AuthCallback? _onResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return context.sizeClass == MaterialWindowSizeClass.compact
            ? _MobileSignUpPage(onResult: _onResult)
            : _DesktopSignUpPage(onResult: _onResult);
      },
    );
  }
}

class _DesktopSignUpPage extends HookConsumerWidget {
  const _DesktopSignUpPage({super.key, AuthCallback? onResult})
    : _onResult = onResult;

  final AuthCallback? _onResult;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useGlobalKey<FormState>();

    final name = useState('');
    final email = useState('');
    final password = useState('');

    final handleSubmit = useCallback(() async {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        await ref
            .read(authServiceProvider.notifier)
            .createUser(name.value, email.value, password.value);

        // Check that the widget still exists after the async operation.
        if (!context.mounted) return;

        if (ref.read(authServiceProvider).requireValue != null) {
          if (_onResult != null) {
            // Navigate the page the user wanted to go to.
            // Runs the function passed in by the guard and brings user back to previous page.
            _onResult(didLogIn: true);
          } else {
            await context.router.replace(const LocalFeedRoute());
          }
        } else {
          // TODO(lishaduck): Move this to the guard.
          context.showSnackBar(
            content: const Text('Invalid username or password'),
          );
        }
      }
    }, [formKey]);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width / 4,
          vertical: MediaQuery.sizeOf(context).height / 6,
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
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  'Welcome to Harvest Hub!',
                  style: TextStyle(
                    fontSize: 28,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                    labelText: 'First and Last Name',
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
                      await context.router.push(
                        LogInRoute(onResult: _onResult),
                      );
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

class _MobileSignUpPage extends HookConsumerWidget {
  const _MobileSignUpPage({super.key, AuthCallback? onResult})
    : _onResult = onResult;

  final AuthCallback? _onResult;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useGlobalKey<FormState>();

    final email = useState('');
    final password = useState('');

    final handleSubmit = useCallback(() async {
      if (formKey.currentState?.validate() ?? false) {
        formKey.currentState?.save();

        // Log in the user.
        await ref
            .read(authServiceProvider.notifier)
            .logInUser(email.value, password.value);

        // Check that the widget still exists after the async operation.
        if (!context.mounted) return;

        if (ref.read(authServiceProvider).requireValue != null) {
          if (_onResult != null) {
            // Navigate the page the user wanted to go to.
            // Runs the function passed in by the guard and brings user back to previous page.
            _onResult(didLogIn: true);
          } else {
            // Replace the route so user won't come back to login.
            await context.router.replace(const LocalFeedRoute());
          }
        } else {
          // TODO(lishaduck): Move this to the guard.
          context.showSnackBar(
            content: const Text('Invalid username and password'),
          );
        }
      }
    }, [formKey]);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.pictures.loginImage.provider(),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          'Welcome to Harvest Hub!',
                          style: TextStyle(
                            fontSize: 24,
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: handleSubmit,
                            child: const Text('Log in'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: TextButton(
                            onPressed: () async {
                              await context.router.push(
                                SignUpRoute(onResult: _onResult),
                              );
                            },
                            child: const Text(
                              "Don't have an account? Sign up!",
                            ),
                          ),
                        ),
                      ],
                    ),
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

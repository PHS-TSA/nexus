/// This library provides a service to handle user authentication.
library;

import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';

part 'auth_service.g.dart';

/// Provides method a user?
@Riverpod(keepAlive: true)
base class AuthService extends _$AuthService {
  // TODO(lishaduck): Ideally, this wouldn't be async, just nullable.
  @override
  FutureOr<User?> build() async {
    final authRepo = ref.watch(authRepositoryProvider);

    return await authRepo.checkUserAuth();
  }

  // Methods on notifiers should be small wrappers around a repo that cache the current values.

  // Use this createUser method instead of the method in auth_repository as this one saves it to the provider
  // @MattsAttack> @lishaduck, does this set the current user to the user created in the createUser method? It shouldn't unless we change the implementation to have sign up auto log them in
  // @lishaduck> @MattsAttack, Appwrite does auto-login. This syncs that. However, you're not guarding the login page, so it doesn't break your setup. I'd probably get it to auto-login as well, but that's separate.
  Future<void> createUser(String name, String email, String password) async {
    // Set the state to loading.
    state = const AsyncValue.loading();

    // Try to create the user. If it fails, set the state to error.
    // Note that expected errors are already converted to null.
    state = await AsyncValue.guard(
      () async => await ref
          .read(authRepositoryProvider)
          .createUser(name, email, password),
    );
  }

  Future<void> logInUser(String email, String password) async {
    await ref.read(authRepositoryProvider).logInUser(email, password);

    // Invalidates the current state and awaits the rebuild.
    ref.invalidateSelf();
    await future;
  }

  Future<void> logOutUser() async {
    log('running log out');
    await ref.read(authRepositoryProvider).logOutUser();
    log('ran log out');
    state = const AsyncValue.data(null);
  }
}

// How to get values from service provider
// ref.watch(authServiceProvider).valueOrNull?.name;

Object a(Ref ref) {
  final authState = ref.watch(authServiceProvider);
  return switch (authState) {
    AsyncData(:final value) when value != null => value.name,
    AsyncError(:final error, :final stackTrace) => (error, stackTrace),
    // that's loading, wait for riverpod 3
    // _ is loading. return a loading indicator
    _ => const CircularProgressIndicator(),
  };
}

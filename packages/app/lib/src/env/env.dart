/// This file lists environment variables expected to be available at compile time.
library;

import 'package:envied/envied.dart';

part 'env.g.dart';

// Envied needs a class with only static members.
// ignore: avoid_classes_with_only_static_members
/// Environment variables.
@Envied(useConstantCase: true, obfuscate: true)
abstract class Env {
  /// Appwrite project ID
  @EnviedField(defaultValue: 'nexus-staging')
  static final String projectId = _Env.projectId;

  /// Appwrite API endpoint
  @EnviedField(defaultValue: 'http://localhost:80/v1')
  static final String apiEndpoint = _Env.apiEndpoint;

  /// If the Appwrite Server uses self-signed certificates.
  @EnviedField(defaultValue: false)
  static final bool selfSigned = _Env.selfSigned;

  /// Database ID
  @EnviedField(defaultValue: 'database-id')
  static final String databaseId = _Env.databaseId;

  /// Post collection ID
  @EnviedField(defaultValue: 'post-coolection-id')
  static final String postsCollectionId = _Env.postsCollectionId;
}

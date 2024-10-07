import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../env/env.dart';
import '../../../utils/api.dart';

part 'post_repository.g.dart';

/*
How to do things:
Put database and collection id in .env
Implement post code from other branch
For first implementation have post_repository read in all posts and then add queries and other filters down the line
Have flutter access user location
*/

// Post_entitys are put into list in feed_service

abstract interface class PostRepository {
  //Have funcs in heres
}

final class _AppwritePostRepository implements PostRepository {
  String databaseId = Env.databaseId;
  String collectionId = Env.postsCollectionId;

  final Databases database = Databases(client as Client);
}

@riverpod
PostRepository postRepository(PostRepositoryRef ref) {
  return _AppwritePostRepository();
}

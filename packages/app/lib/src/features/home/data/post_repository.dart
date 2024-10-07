import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_repository.g.dart';

/*
How to do things:
Put database and collection id in .env



*/

abstract interface class PostRepository {
  //Have funcs in heres
}

final class _AppwritePostRepository implements PostRepository {}

@riverpod
PostRepository postRepository(PostRepositoryRef ref) {
  return _AppwritePostRepository();
}

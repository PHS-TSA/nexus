import 'package:appwrite/appwrite.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../env/env.dart';
import '../../../utils/api.dart';
import '../domain/feed_entity.dart';
import '../domain/post_entity.dart';

part 'post_repository.g.dart';

/*
How to do things:
Put database and collection id in .env
Implement post code from other branch
For first implementation have post_repository read in all posts and then add queries and other filters down the line
Have flutter access user location
*/

// Might need to have 2 posts lists. One for local and one for world

// Post_entitys are put into list in feed_service

abstract interface class PostRepository {
  //Have funcs in heres

  // TODOadd in get funcs

  /// Read all the posts.
  Future<List<PostEntity>> readPosts();

  /// Create a new post.
  ///
  /// Returns the created post.
  Future<void> createNewPost(
    String? headline,
    String? description,
    double lat,
    double lng,
    BucketFile? image,
  );
}

final class _AppwritePostRepository implements PostRepository {
  const _AppwritePostRepository({
    required this.database,
    required this.databaseId,
    required this.collectionId,
    required this.author,
    // required this.feed,
    required this.feed,
  });

  final Databases database;

  final String databaseId;
  final String collectionId;

  final UserId? author;
  final FeedEntity? feed;

  @override
  Future<List<PostEntity>> readPosts() async {
    // Have one func or param for local and one for global
    final documentList = await database.listDocuments(
      databaseId: databaseId,
      collectionId: collectionId,
      // TODO(MattsAttack): For local vs world sorting have a conditional to determine sorting method.
      // queries: [
      //   // Only returns data with these attributes
      //   Query.equal('createdBy', email),
      // ],
    );
    // @lishaduck after some debugging, I'm pretty sure there's an issue with the json mapping to PostEntitys. Its getting the documents but it seems like its just not mapping the values correctly

    return documentList.documents.map((document) {
      return PostEntity.fromJson(document.data);
    }).toList();
  }

  @override
  Future<void> createNewPost(
    String? headline,
    String? description,
    double lat,
    double lng,
    BucketFile? image,
  ) async {
    try {
      await database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: {
          'headline': headline,
          'description': description,
          'author': author,
          'lat': lat,
          'lng': lng,
          'timestamp': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
          //TODO add images
        },
      );
    } catch (e) {
      print(e);
    }
    // return PostEntity.fromJson(document.data);
  }
}

@riverpod
PostRepository postRepository(
  PostRepositoryRef ref,
  UserId? author,
  FeedEntity? feed,
) {
  final database = ref.read(databasesProvider);

  return _AppwritePostRepository(
    author: author,
    feed: feed,
    database: database,
    databaseId: Env.databaseId,
    collectionId: Env.postsCollectionId,
  );
}

import 'package:appwrite/appwrite.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../env/env.dart';
import '../../../utils/api.dart';
import '../domain/feed_entity.dart';
import '../domain/post_entity.dart';

part 'post_repository.g.dart';

/// The number of posts to fetch at a time.
const pageSize = 10;

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
  /// Read all the posts.
  Future<List<PostEntity>> readPosts(int offset, double lat, double lng);

  /// Create a new post.
  ///
  /// Returns the created post.
  Future<void> createNewPost(
    // TODO(lishaduck): Take a PostEntity.
    String? headline,
    String? description,
    double lat,
    double lng,
    String? image,
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

  final String? author;
  final FeedEntity feed;

  @override
  Future<List<PostEntity>> readPosts(int offset, double lat, double lng) async {
    final documentList = await database.listDocuments(
      databaseId: databaseId,
      collectionId: collectionId,
      queries: [
        Query.offset(offset),
        ...switch (feed) {
          LocalFeed() => [
              Query.between('lat', lat - 2, lat + 2),
              Query.between('lng', lng - 2, lng + 2),
            ],
          WorldFeed() => [
              // No filter.
            ],
        },
        Query.limit(pageSize),
      ],
    );

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
    String? image,
  ) async {
    try {
      await database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: {
          // TODO(lishaduck): Use native JSON serialization.
          'headline': headline,
          'description': description,
          'author': author,
          'lat': lat,
          'lng': lng,
          'timestamp': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
          // TODO(MattAttack): add images
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
  String? author,
  FeedEntity feed,
) {
  final database = ref.watch(databasesProvider);

  return _AppwritePostRepository(
    author: author,
    feed: feed,
    database: database,
    databaseId: Env.databaseId,
    collectionId: Env.postsCollectionId,
  );
}

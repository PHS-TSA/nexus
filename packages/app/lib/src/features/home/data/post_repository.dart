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

/// The number of posts to fetch at a time.
const pageSize = 10;

abstract interface class PostRepository {
  /// Read all the posts.
  ///
  /// If [cursor] is null, the first page is returned.
  /// Otherwise, the next page from the cursor is returned.
  Future<List<PostEntity>> readPosts(String? cursor);

  /// Create a new post.
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

  final UserId author;
  final FeedEntity feed;

  @override
  Future<List<PostEntity>> readPosts(String? cursor) async {
    final documentList = await database.listDocuments(
      databaseId: databaseId,
      collectionId: collectionId,
      queries: [
        Query.limit(pageSize),
        if (cursor != null)
          // Only returns data with these attributes.
          Query.cursorAfter(cursor),
        ...switch (feed) {
          LocalFeed(:final location) => [
              Query.between(
                'lat',
                location.latitude - 2,
                location.latitude + 2,
              ),
              Query.between(
                'lng',
                location.longitude - 2,
                location.longitude + 2,
              ),
            ],
          WorldFeed() => [
              // No filter.
            ],
        },
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
    BucketFile? image,
  ) async {
    // TODO(lishaduck): Take a PostEntity. Use builtin JSON serialization.
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
        // TODO(MattsAttack): add images
      },
    );
  }
}

@riverpod
PostRepository postRepository(
  PostRepositoryRef ref,
  UserId author,
  FeedEntity feed,
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

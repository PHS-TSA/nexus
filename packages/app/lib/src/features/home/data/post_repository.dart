/// This library contains post fetchers.
library;

import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../env/env.dart';
import '../../../utils/api.dart';
import '../domain/feed_entity.dart';
import '../domain/post_entity.dart';

part 'post_repository.g.dart';

/// A repository for posts.
abstract interface class PostRepository {
  /// The number of posts to fetch at a time.
  static const pageSize = 10;

  /// Read all the posts.
  Future<List<PostEntity>> readPosts(FeedEntity feed, PostId? cursor);

  /// Create a new post.
  ///
  /// Returns the created post.
  Future<void> createNewPost(
    // TODO(lishaduck): Take a PostEntity.
    String? headline,
    String? description,
    double lat,
    double lng,
    List<String> likes,
    String? image,
    String author,
    String authorName,
    DateTime timestamp,
  );

  /// Toggle if a user is listed as having liked a post.
  Future<void> toggleLikePost(PostId postId, String userId, List<String> likes);
}

final class _AppwritePostRepository implements PostRepository {
  const _AppwritePostRepository({
    required this.database,
    required this.databaseId,
    required this.collectionId,
  });

  final Databases database;

  final String databaseId;
  final String collectionId;

  @override
  Future<List<PostEntity>> readPosts(FeedEntity feed, PostId? cursor) async {
    final documentList = await database.listDocuments(
      databaseId: databaseId,
      collectionId: collectionId,
      queries: [
        Query.orderDesc('timestamp'),
        ...switch (feed) {
          LocalFeed(:final lat, :final lng) => [
              Query.between('lat', lat - 2, lat + 2),
              Query.between('lng', lng - 2, lng + 2),
            ],
          WorldFeed() => [],
        },
        if (cursor != null) Query.cursorAfter(cursor.id),
        Query.limit(PostRepository.pageSize),
      ],
    );
    return documentList.documents.map((document) {
      assert(
        !document.data.containsKey('id'),
        'ID should not have been redundantly stored.',
      );

      document.data['id'] = document.$id;

      return PostEntity.fromJson(document.data);
    }).toList();
  }

  @override
  Future<void> createNewPost(
    String? headline,
    String? description,
    double lat,
    double lng,
    List<String> likes,
    String? image,
    String userId,
    String username,
    DateTime timestamp,
  ) async {
    await database.createDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: ID.unique(),
      data: {
        // TODO(lishaduck): Use native JSON serialization.
        'headline': headline,
        'description': description,
        'author': userId,
        'authorName': username,
        'lat': lat,
        'lng': lng,
        'likes': likes,
        'timestamp': DateFormat('yyyy-MM-ddTHH:mm:ss').format(timestamp),
        // TODO(MattAttack): add images
      },
    );
  }

  @override
  Future<void> toggleLikePost(
    PostId postId,
    String userId,
    List<String> likes,
  ) async {
    await database.updateDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: postId.id,
      data: {
        'likes': likes,
      },
    );
  }
}

/// Get a [PostRepository] for a specific author and feed.
@riverpod
PostRepository postRepository(Ref ref) {
  final database = ref.watch(databasesProvider);

  return _AppwritePostRepository(
    database: database,
    databaseId: Env.databaseId,
    collectionId: Env.postsCollectionId,
  );
}

import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

/// A tuple of a post entity and its db id.
typedef PostEntityIdTuple = ({PostEntity entity, String id});

/// Abstract PostRepository with readPosts and createNewPosts methods
abstract interface class PostRepository {
  /// Read all the posts.
  Future<List<PostEntityIdTuple>> readPosts(String? cursor);

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
    int numberOfLikes,
    String? image,
  );
}

final class _AppwritePostRepository implements PostRepository {
  const _AppwritePostRepository({
    required this.database,
    required this.databaseId,
    required this.collectionId,
    required this.author,
    required this.authorName,
    // required this.feed,
    required this.feed,
  });

  final Databases database;

  final String databaseId;
  final String collectionId;

  final String? author;
  final String? authorName;
  final FeedEntity feed;

  @override
  Future<List<PostEntityIdTuple>> readPosts(String? cursor) async {
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
        if (cursor != null) Query.cursorAfter(cursor),
        Query.limit(pageSize),
      ],
    );

    return documentList.documents.map((document) {
      return (
        entity: PostEntity.fromJson(document.data),
        id: document.$id,
      );
    }).toList();
  }

  @override
  Future<void> createNewPost(
    String? headline,
    String? description,
    double lat,
    double lng,
    List<String> likes,
    int numberOfLikes,
    String? image,
  ) async {
    await database.createDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: ID.unique(),
      data: {
        // TODO(lishaduck): Use native JSON serialization.
        'headline': headline,
        'description': description,
        'author': author,
        'authorName': authorName,
        'lat': lat,
        'lng': lng,
        'likes': likes,
        'numberOfLikes': numberOfLikes,
        'timestamp':
            DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.timestamp()),
        // TODO(MattAttack): add images
      },
    );
  }
}

/// Get a [PostRepository] for a specific author and feed.
@riverpod
PostRepository postRepository(
  Ref ref,
  String? author,
  String? authorName,
  FeedEntity feed,
) {
  final database = ref.watch(databasesProvider);

  return _AppwritePostRepository(
    author: author,
    authorName: authorName,
    feed: feed,
    database: database,
    databaseId: Env.databaseId,
    collectionId: Env.postsCollectionId,
  );
}

/// This library contains post fetchers.
library;

import 'package:appwrite/appwrite.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../env/env.dart';
import '../../../utils/api.dart';
import '../../auth/domain/user.dart';
import '../domain/feed_entity.dart';
import '../domain/post_entity.dart';

part 'post_repository.g.dart';

/// A repository for posts.
abstract interface class PostRepository {
  /// The number of posts to fetch at a time.
  static const pageSize = 10;

  /// Read all the posts.
  Future<IList<PostEntity>> readPosts(FeedEntity feed, PostId? cursor);

  /// Create a new post.
  ///
  /// Returns the created post.
  Future<void> createNewPost(
    PostEntity post,
    Uint8List? imageBytes,
    String? imagePath,
  );

  /// Toggle if a user is listed as having liked a post.
  Future<void> toggleLikePost(PostId postId, UserId userId, Likes likes);

  ///Uploads image to Appwrite and returns id
  Future<String> uploadImage(
    PostEntity post,
    Uint8List? imageBytes,
    String? imagePath,
  );

  Future<Uint8List> getImages(String id);
}

final class _AppwritePostRepository implements PostRepository {
  const _AppwritePostRepository({
    required this.database,
    required this.storage,
    required this.databaseId,
    required this.collectionId,
  });

  final Databases database;
  final Storage storage;

  final String databaseId;
  final String collectionId;

  @override
  Future<IList<PostEntity>> readPosts(FeedEntity feed, PostId? cursor) async {
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
    }).toIList();
  }

  @override
  Future<Uint8List> getImages(String id) async {
    return storage.getFileDownload(bucketId: 'post-media', fileId: id);
  }

  @override
  Future<void> createNewPost(
    PostEntity post,
    Uint8List? imageBytes,
    String? imagePath,
  ) async {
    print('Printing image id pre uploading image: ${post.imageID}');
    if (imageBytes != null || imagePath != null) {
      post = post.copyWith(
        imageID: await uploadImage(
          post,
          imageBytes,
          imagePath,
        ),
      );
    }
    print('Printing image id pre creating doc: ${post.imageID}');
    await database.createDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: post.id.id,
      data: post.toJson(),
    );
  }

  @override
  Future<void> toggleLikePost(
    PostId postId,
    UserId userId,
    Likes likes,
  ) async {
    await database.updateDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: postId.id,
      data: {
        'likes': likes.unlockLazy,
      },
    );
  }

  @override
  Future<String> uploadImage(
    // For multi image change to return list
    PostEntity post,
    Uint8List? imageBytes,
    String? imagePath,
  ) async {
    // might be able to remove post param here

    final imageID = ID.unique();
    print(imageID);
    if (imagePath != null) {
      // Upload via path
      final fileName = '${DateTime.now().microsecondsSinceEpoch}'
          "${imagePath.split(".").last}";

      final file = await storage.createFile(
        bucketId: 'post-media', //maybe change to env variable
        fileId: imageID,
        file: InputFile.fromPath(path: imagePath, filename: fileName),
      );
    } else if (imageBytes != null) {
      // Upload via bytes
      const fileName = 'makeMeUniqueOrSomething';
      final file = await storage.createFile(
        bucketId: 'post-media', //maybe change to env variable
        fileId: imageID,
        file: InputFile.fromBytes(bytes: imageBytes, filename: fileName),
      );
    } else {
      return 'error'; //TODO better error handeling here
    }
    return imageID;
  }
}

/// Get a [PostRepository] for a specific author and feed.
@riverpod
PostRepository postRepository(Ref ref) {
  final database = ref.watch(databasesProvider);
  final storage = ref.watch(storageProvider);

  return _AppwritePostRepository(
    database: database,
    storage: storage,
    databaseId: Env.databaseId,
    collectionId: Env.postsCollectionId,
  );
}

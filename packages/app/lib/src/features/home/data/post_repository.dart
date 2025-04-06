/// This library contains post fetchers.
library;

import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../env/env.dart';
import '../../../utils/api.dart';
import '../../auth/domain/user.dart';
import '../domain/feed_entity.dart';
import '../domain/post_entity.dart';
import '../domain/post_id.dart';
import '../domain/uploaded_image_entity.dart';

part 'post_repository.g.dart';

/// A repository for posts.
abstract interface class PostRepository {
  /// The number of posts to fetch at a time.
  static const pageSize = 10;

  /// Read all the posts.
  Future<IList<PostEntity>> readPosts(FeedEntity feed, PostId? cursor);

  /// Read a single post.
  Future<PostEntity?> readPost(PostId postId);

  /// Create a new post.
  ///
  /// Returns the created post.
  Future<void> createNewPost(
    PostEntity post,
    IList<UploadedImageEntity> images,
  );

  /// Toggle if a user is listed as having liked a post.
  Future<void> toggleLikePost(PostId postId, UserId userId, Likes likes);

  /// Upload an image to Appwrite.
  Future<void> uploadImage(UploadedImageEntity file);

  /// Fetch images from Appwrite.
  Future<Uint8List> getImage(String id);

  /// Post a comment.
  Future<void> updatePost(PostId postId, Map<String, Object?> updatedData);
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
  Future<PostEntity?> readPost(PostId postId) async {
    try {
      final document = await database.getDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: postId.id,
      );

      assert(
        !document.data.containsKey('id'),
        'ID should not have been redundantly stored.',
      );

      document.data['id'] = document.$id;

      return PostEntity.fromJson(document.data);
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        return null;
      }

      rethrow;
    }
  }

  @override
  Future<Uint8List> getImage(String id) async {
    return await storage.getFileView(bucketId: 'post-media', fileId: id);
  }

  @override
  Future<void> createNewPost(
    PostEntity post,
    IList<UploadedImageEntity> images,
  ) async {
    // Could be cool to implement a upload status bar. Posts with 10 images will take a while and that should help
    for (final image in images) {
      await uploadImage(image);
    }

    await database.createDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: post.id.id,
      data: post.toJson(),
    );
  }

  @override
  Future<void> toggleLikePost(PostId postId, UserId userId, Likes likes) async {
    await database.updateDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: postId.id,
      data: {'likes': likes.unlockLazy},
    );
  }

  @override
  Future<void> uploadImage(UploadedImageEntity file) async {
    final bytes = await file.file.readAsBytes();

    // Prevent collisions by adding a timestamp to the file name.
    final fileName =
        '${DateTime.timestamp().microsecondsSinceEpoch}-${file.file.name}';

    await storage.createFile(
      bucketId: 'post-media', //maybe change to env variable
      fileId: file.imageId,
      file: InputFile.fromBytes(bytes: bytes, filename: fileName),
    );
  }

  @override
  Future<void> updatePost(PostId id, Map<String, Object?> updatedData) async {
    await database.updateDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: id.id,
      data: updatedData,
    );
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

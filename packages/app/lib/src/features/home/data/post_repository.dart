/// This library contains post fetchers.
library;

import 'package:appwrite/appwrite.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../env/env.dart';
import '../../../utils/api.dart';
import '../../auth/domain/user.dart';
import '../application/uploaded_image_service.dart';
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
  );

  /// Toggle if a user is listed as having liked a post.
  Future<void> toggleLikePost(PostId postId, UserId userId, Likes likes);

  ///Uploads image to Appwrite and returns id
  Future<void> uploadImage(
    int index,
  );

  Future<Uint8List> getImages(String id);
}

final class _AppwritePostRepository implements PostRepository {
  const _AppwritePostRepository({
    required this.database,
    required this.storage,
    required this.databaseId,
    required this.collectionId,
    required this.ref,
  });

  final Databases database;
  final Storage storage;

  final String databaseId;
  final String collectionId;

  final Ref ref; //@lishaduck is this the correct way to access a ref here?

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
    // Update for multi image
    return await storage.getFileView(bucketId: 'post-media', fileId: id);
  }

  @override
  Future<void> createNewPost(
    PostEntity post,
  ) async {
    //Need to figure out why images aren't uploading
    final imageID =
        post.imageID; // Extracting locally reduces chance for null upon access
    if (imageID != null) {
      for (var i = 0; i < imageID.length; i++) {
        await uploadImage(
          i,
        ); // Could be cool to implement a upload status bar. Posts with 10 images will take a while and that should help
      }
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
  Future<void> uploadImage(
    int index,
  ) async {
    final uploadedImages = ref.watch(uploadedImagesServiceProvider);
    final selectedFile = uploadedImages[index].file;

    //Path is for non web
    if (!kIsWeb) {
      final path = selectedFile.path;
      if (path != null) {
        // Upload via path
        final fileName = '${DateTime.now().microsecondsSinceEpoch}'
            "${path.split(".").last}";

        final file = await storage.createFile(
          bucketId: 'post-media', //maybe change to env variable
          fileId: uploadedImages[index].imageID,
          file: InputFile.fromPath(path: path, filename: fileName),
        );
      }
    }
    //Byte upload is for web
    else if (kIsWeb) {
      final bytes = selectedFile.bytes;
      if (bytes != null) {
        // Upload via bytes
        final fileName = '${DateTime.now().microsecondsSinceEpoch}'
            '-${selectedFile.name}'; //TODOimplement time here
        final file = await storage.createFile(
          bucketId: 'post-media', //maybe change to env variable
          fileId: uploadedImages[index].imageID,
          file: InputFile.fromBytes(bytes: bytes, filename: fileName),
        );
      }
    }
    return;
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
    ref: ref,
  );
}

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../env/env.dart';
import '../../../utils/api.dart';
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

  final List<Document> _posts = [];

  //get all todos func for other classes
  List<Document> get allPosts => _posts;
}

final class _AppwritePostRepository implements PostRepository {
  String databaseId = Env.databaseId;
  String collectionId = Env.postsCollectionId;

  final Databases database = Databases(client as Client);

  @override
  List<Document> _posts = [];

  //get all todos func for other classes
  @override
  List<Document> get allPosts => _posts;

  // bool _isLoading = false;

  //check if loading

  // bool get checkLoading => _isLoading;

  // Read all the todos

  Future readPosts() async {
    // Have one func or param for local and one for global
    // var isLoading = true;
    try {
      final data = await database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        // queries: [
        //   Query.equal('createdBy', email),
        // ],
      ); // Only returns data with these attributes
      _posts = data.documents;
      // isLoading = false;
      // notifyListeners();
    } catch (e) {
      // _isLoading = false;
      // notifyListeners();
      print(e);
    }
  }

  //Create a new Todo

  Future createNewPost(
    // Call this in feeds.dart. Dont need to service things
    String? headline,
    String? description,
    UserId author,
    LatLng location,
    ImageProvider? image,
  ) async {
    // Maybe change to no author param and getting value in here. Whatever's more efficient
    //TODO get current users email or user ID (talk to eli about which one)

    //Question marks means it can be null
    final collection = await database.createDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: ID.unique(),
      data: {
        'headline': headline,
        'description': description,
        'author': author,
        'location': location,
        'timestamp': DateTime.now,
        //TODO add images
      },
    );
    print('new post created');
  }
}

@riverpod
PostRepository postRepository(PostRepositoryRef ref) {
  return _AppwritePostRepository();
}

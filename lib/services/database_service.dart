import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocation_app/model/user_profile.dart';

import 'auth_service.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;


  CollectionReference? _usersCollection;
  CollectionReference? _locationCollection;


  DatabaseService(){
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _usersCollection =
        _firebaseFireStore.collection('users').withConverter<UserProfile>(
          fromFirestore: (snapshot, _) =>
              UserProfile.fromJson(
                snapshot.data()!,
              ),
          toFirestore: (userProfile, _) => userProfile.toJson(),
        );
    _locationCollection =
    _firebaseFireStore
        .collection('users')
        .doc()
        .collection('locations')
        .withConverter<LocationProfile>(
      fromFirestore: (snapshot, _) => LocationProfile.fromJson(snapshot.data()!),
      toFirestore: (locationProfile, _) => locationProfile.toJson(),
    );
  }



  Future <void> createUserProfile({required UserProfile userProfile}) async{
      await _usersCollection?.doc(userProfile.uid).set(userProfile);

  }

  Future<void> addLocationProfile({required String uid,required LocationProfile locationProfile}) async {


    _locationCollection =
        _firebaseFireStore
            .collection('users')
            .doc(uid)
            .collection('locations')
            .withConverter<LocationProfile>(
          fromFirestore: (snapshot, _) => LocationProfile.fromJson(snapshot.data()!),
          toFirestore: (locationProfile, _) => locationProfile.toJson(),
        );

      await _locationCollection?.doc(uid).set(locationProfile);

  }

}
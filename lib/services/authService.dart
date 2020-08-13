import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  User userData;

  Stream<UserId> get userId {
    return _firebaseAuth.onAuthStateChanged.map(_userHolderFromFireBaseUser);
  }

  Future<dynamic> getCurrentUserId() async {
    dynamic userId;
    await _firebaseAuth
        .currentUser()
        .then((firebaseUser) =>
            {userId = _userHolderFromFireBaseUser(firebaseUser)})
        .catchError((e) => {userId = e});
    return userId;
  }

  UserId _userHolderFromFireBaseUser(FirebaseUser user) {
    return user != null ? UserId(uid: user.uid) : null;
  }

  Future<User> signIn(String emailAddress, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final AuthResult authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      final FirebaseUser firebaseUser = authResult.user;
      User user = await getUserFromFirestore(firebaseUser.uid);
      if (user == null) {
        return null;
      }
      prefs.setString(USERID, user.uid);
      prefs.setString(EMAIL, user.emailAddress);
      prefs.setString(FULLNAME, user.userName);
      return user;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future<dynamic> signUp(
      {String fullName,
      String businessName,
      String emailAddress,
      String phoneNumber,
      String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      User user;
      final AuthResult _authResult =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: emailAddress, password: password);
      final FirebaseUser _firebaseUser = _authResult.user;
      await _firestore
          .collection(USERS_COLLECTION)
          .document(_firebaseUser.uid)
          .setData({
        'fullName': fullName,
        'businessName': businessName,
        'emailAddress': emailAddress,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp()
      });
      prefs.setString(USERID, _firebaseUser.uid);
      prefs.setString(EMAIL, emailAddress);
      prefs.setString(FULLNAME, fullName);
      return true;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future<User> getUserFromFirestore(String uid) async {
    User user;
    await _firestore
        .collection(USERS_COLLECTION)
        .document(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists && documentSnapshot.data.length > 0) {
        Map<String, dynamic> data = documentSnapshot.data;
        user = User(
          uid: uid,
          userName: data['fullName'],
          phoneNumber: data['phoneNumber'],
          businessName: data['businessName'],
          website: data['website'],
          emailAddress: data['emailAddress'],
          address: data['address'] ?? '',
          pan: data['pan'] ?? '',
          gst: data['gst'] ?? '',
        );
      } else {
        user = User();
      }
    });
    return user;
  }

  Future<dynamic> updateUser(User user) async {
    try {
      await _firestore
          .collection(USERS_COLLECTION)
          .document(user.uid)
          .updateData({
        'businessName': user.businessName,
        'emailAddress': user.emailAddress,
        'fullName': user.userName,
        'phoneNumber': user.phoneNumber,
        'gst': user.gst,
        'pan': user.pan,
        'address': user.address,
        'website': user.website,
        'updatedAt': FieldValue.serverTimestamp()
      });

      return true;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }
}

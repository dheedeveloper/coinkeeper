import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coinkeeper/screens/homescreen/homepage.dart';
import 'package:coinkeeper/utility/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Authentication {
  static Future<User?>  signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;


    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
        print(user?.uid);
        print(user?.displayName);
        await StorageService().setUserId("uid", user?.uid ?? "");
        CollectionReference userData = FirebaseFirestore.instance.collection('users');
        userData.doc(user?.uid).set(
            {
              "userName" : user?.displayName,
              "image":"assets/images/manOne.png",
              "uid":user?.uid,

            }
        ).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
        })

            .catchError((error) => print("Failed to add user: $error"));

        // await StorageService().setUserId("uid", user?.uid ?? "");
        // await StorageService().setUserOrder("order", "$count");
        // Provider.of<CricketCardProvider>(context,listen: false).addUserData(count.toString());
        // Map<String,dynamic>userMap={
        //   "name":user?.displayName,
        //   "status" :"Active",
        //   "id" :user?.uid
        // };
        // DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("users").child("$count");

        // databaseReference.set(userMap);
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(uid: user!.uid,userOrder: "$count",)));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }
}
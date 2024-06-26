import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:virtuetracker/api/users.dart';

class Settings {
  // Instance of Firebase auth class to call Firebase methods
  final auth = FirebaseAuth.instance;

  // Instance of Users collection from database
  final usersCollectionRef = FirebaseFirestore.instance.collection('Users');
  static String verifyId = "";

  // Quadrantlist for every community we have, used when a user changes to a new community
  final quadrantLists = {
    "Legal": {
      "Legal": {
        "Honesty": 0,
        "Courage": 0,
        "Compassion": 0,
        "Generosity": 0,
        "Fidelity": 0,
        "Integrity": 0,
        "Fairness": 0,
        "Self-control": 0,
        "Prudence": 0
      }
    },
    "Alcoholics Anonymous": {
      "Alcoholics Anonymous": {
        "Honesty": 0,
        "Hope": 0,
        "Surrender": 0,
        "Courage": 0,
        "Integrity": 0,
        "Willingness": 0,
        "Humility": 0,
        "Love": 0,
        "Responsibility": 0,
        "Discipline": 0,
        "Awareness": 0,
        "Service": 0,
      }
    }
  };
  Future<dynamic> updatePassword(
      {required String newPassword, required Function authError}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }
      final response = await user.updatePassword(newPassword);
      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      if (error.code == "requires-recent-login") {
        authError();
        return {'Success': false, 'Error': error.code};
      }
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  Future<dynamic> updatePrivacy(
      bool newShareEntries, bool newShareLocation, dynamic userLocation) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      if (newShareLocation) {
        final response = await usersCollectionRef.doc(user.uid).update({
          'shareEntries': newShareEntries,
          'shareLocation': newShareLocation,
          'userLocation': userLocation
        });
      } else {
        final response = await usersCollectionRef.doc(user.uid).update({
          'shareEntries': newShareEntries,
          'shareLocation': newShareLocation,
          'userLocation': null
        });
      }
      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  Future<dynamic> updateProfile(
      String newEmail,
      String newProfileName,
      String newCareer,
      String newCommunity,
      String newCareerLength,
      Function authError,
      bool newListExist) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      if (newEmail.isNotEmpty) {
        await user.verifyBeforeUpdateEmail(newEmail);
      }
      if (newProfileName.isNotEmpty) {
        await user
            .updateDisplayName(newProfileName)
            .catchError((e) => print('error in updateProfile $e'));
      } else {
        print('profile name is empty');
      }
      // Build the update map
      final Map<String, dynamic> updateMap = {};
      if (newCommunity.isNotEmpty) {
        updateMap['currentCommunity'] = newCommunity;
        print('settings api profile $newListExist');
        if (newListExist == false) {
          final Map<String, dynamic> userObject = {};
          userObject["quadrantUsedData"] =
              quadrantLists[newCommunity] ?? 'Error';
          await usersCollectionRef
              .doc(user.uid)
              .set(userObject, SetOptions(merge: true));
        }
      }
      if (newCareer.isNotEmpty) {
        updateMap['careerInfo.currentPosition'] = newCareer;
      }
      if (newCareerLength.isNotEmpty) {
        updateMap['careerInfo.careerLength'] = newCareerLength;
      }
      if (newProfileName.isNotEmpty) {
        await user
            .updateDisplayName(newProfileName)
            .catchError((e) => print('error in updateProfile $e'));
      } else {
        print('profile name is empty');
      }
      if (updateMap.isNotEmpty) {
        await usersCollectionRef.doc(user.uid).update(updateMap);
      }

      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      if (error.code == "requires-recent-login") {
        authError();
        return {'Success': false, 'Error': error.code};
      }
      return {'Success': false, 'Error': error.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  Future<dynamic> updateNotificationPreferences(
      bool newAllowNotificationa, String newNotificationTime) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }
      final response = await usersCollectionRef.doc(user.uid).update({
        'notificationPreferences.allowNotifications': newAllowNotificationa,
        'notificationPreferences.notificationTime': newNotificationTime
      });
      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }

  // Re-authenticate the user with their email and password, sometimes when changing settings we have to reauthenticate
  Future<dynamic> reauthenticateUser(String email, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      print('re-aunthenticating the user');
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        return {"Success": true, 'response': "Done"};
      }
    } on FirebaseAuthException catch (e) {
      print('Error re-authenticating user: $e');
      return {'Success': false, 'Error': e.message};
    } catch (error) {
      return {'Success': false, 'Error': error};
    }
  }

  // Not using
  Future<dynamic> updatePhoneNumber({
    required String newPhoneNumber,
    required Function errorStep,
    required Function nextStep,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      await auth
          .verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        phoneNumber: "+1$newPhoneNumber",
        verificationCompleted: (phoneAuthCredential) async {
          return;
        },
        verificationFailed: (error) async {
          return;
        },
        codeSent: (verificationId, forceResendingToken) async {
          verifyId = verificationId;
          nextStep();
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          return;
        },
      )
          .onError((error, stackTrace) {
        errorStep();
      });

      return {"Success": true, 'response': "Done"};
    } on FirebaseAuthException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }
}

// verify otp code, Not using
Future<dynamic> confirmOtp({
  required String otp,
  required String oldPhoneNumber,
}) async {
  final auth = FirebaseAuth.instance;
  final cred = PhoneAuthProvider.credential(
      verificationId: Users.verifyId, smsCode: otp);
  User? currentUser = await auth.currentUser!;

  // unlink the old phone number
  try {
    currentUser = await currentUser.unlink(oldPhoneNumber);
  } catch (e) {
    print(e);
    currentUser = await auth.currentUser!;
  }

  // instead of signing in with credential, link credential to signed in user account
  try {
    currentUser.linkWithCredential(cred).then((value) {
      // Verfied now perform something or exit.
      print("credential linked");
      return {"Success": true, "response": "User phone number verified"};
    }).catchError((e) {
      // An error occured while linking
      return {"Success": false, "Error": "error linking credential"};
    });
  } catch (e) {
    // General error
    return {"Success": false, "Error": e};
  }
}

// Provider to use Resources class in other files
final settingsRepositoryProvider = Provider<Settings>((ref) {
  return Settings();
});

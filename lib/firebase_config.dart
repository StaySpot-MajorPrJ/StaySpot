import 'package:firebase_core/firebase_core.dart';

Future<FirebaseApp> initializeFirebase() async {
  return await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAXgu_bmYX2AFvpd50KPfo35ZBj1aORmSY",
      authDomain: "stays-2d46b.firebaseapp.com",
      projectId: "stays-2d46b",
      storageBucket: "stays-2d46b.firebasestorage.app",
      messagingSenderId: "895472709439",
      appId: "1:895472709439:web:d60ba5c10bc727fd156d8a",
      measurementId: "G-0929BZ390B"
    ),
  );
}

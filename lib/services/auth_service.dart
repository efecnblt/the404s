import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/authors.dart';

import '../models/course.dart';
import 'package:cyber_security_app/models/users.dart' as app_user;
import '../models/course_progress_model.dart';
import '../models/sections.dart';
import '../models/video.dart';
import '../screens/dashboard/dashboard.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String baseUrl = 'https://api.cbolat.com/';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'User data is null.',
        );
      }

      // Fetch the user's document from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw FirebaseAuthException(
          code: 'user-doc-not-found',
          message: 'User document not found in Firestore.',
        );
      }

      // Optionally, parse the user data if needed
      // UserModel userModel = User.fromFirestore(userDoc);

      String displayName = user.displayName ?? 'User';

      // Navigate to Dashboard with name and userId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            name: displayName,
            userId: user.uid,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle other exceptions
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An unexpected error occurred. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'User data is null after Google sign-in.',
        );
      }

      // Fetch the user's document from Firestore
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw FirebaseAuthException(
          code: 'user-doc-not-found',
          message: 'User document not found in Firestore.',
        );
      }

      // Optionally, parse the user data if needed
      // UserModel userModel = User.fromFirestore(userDoc);

      String? displayName = user.displayName;

      // Navigate to Dashboard with name and userId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            name: displayName!,
            userId: user.uid,
          ),
        ),
      );
        } on FirebaseAuthException {
      String errorMessage = 'An error occurred during Google sign-in.';

      // You can handle specific FirebaseAuthException codes here if needed

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sign-In Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle other exceptions
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content:
              const Text('An unexpected error occurred. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Yeni kullanıcı oluşturma
  static Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // E-posta kontrolü
  static Future<bool> isEmailRegistered(String email) async {
    List<String> methods = await _auth.fetchSignInMethodsForEmail(email);
    return methods.isNotEmpty;
  }

  // Firestore'a kullanıcı kaydetme
  static Future<void> saveUserToFirestore({
    required User user,
    required String username,
    required String name,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': username,
      'email': user.email,
      'name': name,
      'createdAt': DateTime.now(),
    });
  }

  static Future<void> enrollCourse(String authorId, String courseId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    await userDoc.collection('enrolledCourses').doc(courseId).set({
      'authorId': authorId,
      'progress': 0.0,
    });
  }

  static Future<void> updateCourseProgress(
      String courseId, double progress) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userCourseDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('enrolledCourses')
        .doc(courseId);

    await userCourseDoc.update({
      'progress': progress,
    });
  }

  // services/course_service.dart
  static Future<List<UserProgress>> fetchUserProgress() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final userProgressCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress');

    final snapshot = await userProgressCollection.get();

    return snapshot.docs.map((doc) {
      return UserProgress.fromFirestore(doc);
    }).toList();
  }

  static Future<void> updateUserProgress(UserProgress progress) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userProgressCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress');

    await userProgressCollection
        .doc(progress.courseId)
        .set(progress.toFirestore());
  }

  // Kursu ve bölümlerini çekme
  static Future<Course?> fetchCourseWithSections(
      String authorId, String courseId) async {
    try {
      print(
          'Fetching course with sections for author: $authorId, course: $courseId');

      // Fetch the course document from the correct nested path
      final courseDoc = FirebaseFirestore.instance
          .collection('authors') // Start from 'authors'
          .doc(authorId) // Access the specific author
          .collection('courses') // Access the 'courses' subcollection
          .doc(courseId); // Access the specific course

      final courseSnapshot = await courseDoc.get();

      // Check if the course exists
      if (courseSnapshot.exists) {
        Course course = Course.fromFirestore(courseSnapshot);

        // Fetch sections for the course
        List<Section> sections = await fetchSections(authorId, courseId);

        // Update the course's sections list
        course.sections = sections;

        return course;
      } else {
        print('Course not found');
        return null;
      }
    } catch (e) {
      print('Error fetching course with sections: $e');
      return null;
    }
  }

  // Function to fetch sections and their videos from Firestore
  static Future<List<Section>> fetchSections(
      String authorId, String courseId) async {
    // Fetch all sections for a course from Firestore
    QuerySnapshot sectionsSnapshot = await FirebaseFirestore.instance
        .collection('authors')
        .doc(authorId)
        .collection('courses')
        .doc(courseId)
        .collection('sections')
        .get();

    List<Section> sections = [];

    // Fetch videos for each section
    for (var sectionDoc in sectionsSnapshot.docs) {
      Section section =
          await Section.fromFirestoreWithVideos(authorId, courseId, sectionDoc);
      sections.add(section);
    }

    return sections;
  }

  static Future<List<Map<String, dynamic>>> fetchSectionsForCourse(
      String authorId, String courseId) async {
    try {
      QuerySnapshot sectionsSnapshot = await FirebaseFirestore.instance
          .collection('authors')
          .doc(authorId)
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .get();

      List<Map<String, dynamic>> sections = sectionsSnapshot.docs.map((doc) {
        return {
          'sectionId': doc.id, // Get the sectionId from the document ID
          ...doc.data() as Map<String, dynamic>, // Merge the section's data
        };
      }).toList();

      return sections;
    } catch (e) {
      print('Error fetching sections: $e');
      return [];
    }
  }

  // Tüm Kursları Çekme
  static Stream<List<Map<String, dynamic>>> fetchAllCourses() {
    try {
      // Authors koleksiyonunu dinlemek için stream oluşturuyoruz
      return _firestore.collection('authors').snapshots().asyncMap((authorsSnapshot) async {
        // Kursları ve yazar bilgilerini tutacak liste
        List<Map<String, dynamic>> coursesWithAuthorInfo = [];

        // Her yazar dökümanını döngüye alıyoruz
        for (var authorDoc in authorsSnapshot.docs) {
          Map<String, dynamic> authorData = authorDoc.data() as Map<String, dynamic>;
          String authorId = authorDoc.id;

          // Mevcut yazarın courses alt koleksiyonunu alıyoruz
          QuerySnapshot coursesSnapshot = await _firestore
              .collection('authors')
              .doc(authorId)
              .collection('courses')
              .get();

          // Her kursu ve yazar bilgisini ekliyoruz
          for (var courseDoc in coursesSnapshot.docs) {
            Map<String, dynamic> courseData = courseDoc.data() as Map<String, dynamic>;

            coursesWithAuthorInfo.add({
              'course': Course.fromFirestore(courseDoc), // Kurs bilgileri
              'authorId': authorId,
              'authorName': authorData['name'],
              'authorRating': authorData['rating'],
              'authorStudentCount': authorData['studentCount'],
              // İsteğe bağlı olarak diğer yazar detayları
            });
          }
        }

        return coursesWithAuthorInfo;
      });
    } catch (e) {
      print('Error fetching courses: $e');
      throw Exception('Failed to load courses');
    }
  }


  static Future<List<Course>> fetchCoursesByAuthor(String authorId) async {
    try {
      QuerySnapshot coursesSnapshot = await _firestore
          .collection('courses')
          .where('authorId', isEqualTo: authorId)
          .get();

      List<Course> courses = coursesSnapshot.docs.map((doc) {
        return Course.fromFirestore(doc);
      }).toList();

      return courses;
    } catch (e) {
      print('Error fetching courses by author: $e');
      throw Exception('Failed to load courses for the specified author');
    }
  }

  // Videoyu tamamlandı olarak işaretleme
  static Future<void> markVideoAsCompleted(
      String authorId, String courseId, String videoId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userCourseDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('enrolledCourses')
        .doc(courseId);

    await userCourseDoc.set({
      'completedVideos': FieldValue.arrayUnion([videoId]),
      'authorId': authorId, // Gerekirse authorId'yi de saklayabilirsiniz
    }, SetOptions(merge: true));
  }

  // Sonraki videonun kilidini açma
  static Future<void> unlockNextVideo(
      String authorId, String courseId, String nextVideoId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userCourseDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('enrolledCourses')
        .doc(courseId);

    await userCourseDoc.set({
      'unlockedVideos': FieldValue.arrayUnion([nextVideoId]),
      'authorId': authorId, // Gerekirse authorId'yi de saklayabilirsiniz
    }, SetOptions(merge: true));
  }

  // Kullanıcının Kayıtlı Kurslarını Çekme
  static Future<List<Map<String, dynamic>>> fetchUserCourses() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final List<dynamic> enrolledCourses = userData['enrolledCourses'] ?? [];

      List<Future<Map<String, dynamic>?>> futures =
          enrolledCourses.map((courseId) async {
        try {
          final courseDoc =
              await _firestore.collection('courses').doc(courseId).get();
          if (!courseDoc.exists) {
            print('Course $courseId not found');
            return null;
          }

          final course = Course.fromFirestore(courseDoc);
          final progress = await UserProgressService.getProgress(courseId);

          return {
            'course': course,
            'progress': progress?.progress ?? 0.0,
          };
        } catch (e) {
          print('Error fetching course $courseId: $e');
          return null;
        }
      }).toList();

      final results = await Future.wait(futures);

      return results
          .where((course) => course != null)
          .cast<Map<String, dynamic>>()
          .toList();
    } catch (e) {
      print('Error fetching user courses: $e');
      throw Exception('Failed to load user courses');
    }
  }

  // Belirli bir kursun videolarını çekme
  static Future<List<Video>> fetchVideos(
      String authorId, String courseId, String sectionId) async {
    try {
      print(
          'Fetching videos for author: $authorId, course: $courseId, section: $sectionId');

      // Fetch videos from the correct nested path in Firestore
      QuerySnapshot videosSnapshot = await _firestore
          .collection('authors') // Start from 'authors'
          .doc(authorId) // Access the specific author
          .collection('courses') // Access the 'courses' subcollection
          .doc(courseId) // Access the specific course
          .collection('sections') // Access the 'sections' subcollection
          .doc(sectionId) // Access the specific section
          .collection('videos') // Access the 'videos' subcollection
          .orderBy('order') // Order videos by the 'order' field
          .get();

      // Debug: Check if any videos were fetched
      print('Videos fetched: ${videosSnapshot.docs.length}');

      // Map the fetched documents to Video objects
      List<Video> videos = videosSnapshot.docs.map((doc) {
        return Video.fromFirestore(doc);
      }).toList();

      return videos;
    } catch (e) {
      print('Error fetching videos for section $sectionId: $e');
      throw Exception('Failed to load videos');
    }
  }

  static Future<Video?> fetchVideo(
      String courseId, String sectionId, String videoId) async {
    try {
      DocumentSnapshot videoDoc = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .doc(sectionId)
          .collection('videos')
          .doc(videoId)
          .get();

      if (videoDoc.exists) {
        return Video.fromFirestore(videoDoc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching video $videoId: $e');
      throw Exception('Failed to load video');
    }
  }

  static Future<void> rateCourse(
      String authorId, String courseId, double newRating) async {
    final courseRef = FirebaseFirestore.instance
        .collection('authors')
        .doc(authorId)
        .collection('courses')
        .doc(courseId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(courseRef);

      if (!snapshot.exists) {
        throw Exception("Kurs bulunamadı!");
      }

      double currentRating = (snapshot['rating'] ?? 0).toDouble();
      int currentRatingCount = (snapshot['ratingCount'] ?? 0).toInt();

      // Yeni ortalama rating hesaplama
      double updatedRating =
          ((currentRating * currentRatingCount) + newRating) /
              (currentRatingCount + 1);
      int updatedRatingCount = currentRatingCount + 1;

      // Firestore'da güncelleme
      transaction.update(courseRef, {
        'rating': updatedRating,
        'ratingCount': updatedRatingCount,
      });
    });
  }

  //OK
  static Future<Author?> getAuthorData(String authorId) async {
    DocumentSnapshot authorSnapshot = await FirebaseFirestore.instance
        .collection('authors')
        .doc(authorId)
        .get();

    if (authorSnapshot.exists) {
      return Author.fromFirestore(
          authorSnapshot); // Return the correct Author object
    } else {
      return null; // Handle case where author is not found
    }
  }

  //OK
  static Future<List<Map<String, dynamic>>> fetchFavoriteCourses(
      String userId) async {
    try {
      // Get the user's favorites from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found.');
      }

      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      List<dynamic> favoriteCourses = data['favorites'] ?? [];

      // List to store detailed course data
      List<Map<String, dynamic>> favoriteCoursesWithDetails = [];

      // Loop through each favorite and fetch course and author details
      for (var favorite in favoriteCourses) {
        String authorId = favorite['authorId'];
        String courseId = favorite['courseId'];

        // Fetch course details
        DocumentSnapshot courseDoc = await FirebaseFirestore.instance
            .collection('authors')
            .doc(authorId)
            .collection('courses')
            .doc(courseId)
            .get();

        if (courseDoc.exists) {
          Map<String, dynamic> courseData =
              courseDoc.data() as Map<String, dynamic>;

          // Fetch author details
          DocumentSnapshot authorDoc = await FirebaseFirestore.instance
              .collection('authors')
              .doc(authorId)
              .get();

          if (authorDoc.exists) {
            Map<String, dynamic> authorData =
                authorDoc.data() as Map<String, dynamic>;

            // Add course and author details to the list
            favoriteCoursesWithDetails.add({
              'course': courseData,
              'authorName': authorData['name'],
              'authorId': authorId,
            });
          }
        }
      }

      return favoriteCoursesWithDetails;
    } catch (e) {
      print('Error fetching favorite courses: $e');
      rethrow;
    }
  }

  //OK
  static Future<void> addFavorite(String courseId, String authorId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final userRef = _firestore.collection('users').doc(userId);

    try {
      await userRef.update({
        'favorites': FieldValue.arrayUnion([
          {
            'authorId': authorId,
            'courseId': courseId,
          }
        ]),
      });
    } catch (e) {
      print('Failed to add favorite: $e');
      rethrow;
    }
  }

  //OK
  static Future<void> removeFavoriteCourse(
      String courseId, String authorId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    DocumentReference userRef = _firestore.collection('users').doc(userId);

    await _firestore.runTransaction((transaction) async {
      // Get the current user document
      DocumentSnapshot userSnapshot = await transaction.get(userRef);

      if (!userSnapshot.exists) {
        throw Exception('User does not exist!');
      }

      Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;

      if (data['favorites'] == null) {
        throw Exception('No favorites exist for this user.');
      }

      List<dynamic> favoritesList = data['favorites'] as List<dynamic>;

      // Find the favorite with the matching courseId and authorId
      Map<String, dynamic>? favoriteToRemove;
      for (var favorite in favoritesList) {
        if (favorite['courseId'] == courseId &&
            favorite['authorId'] == authorId) {
          favoriteToRemove = favorite as Map<String, dynamic>;
          break;
        }
      }

      if (favoriteToRemove == null) {
        throw Exception('Favorite course not found.');
      }

      // Remove the matching favorite
      transaction.update(userRef, {
        'favorites': FieldValue.arrayRemove([favoriteToRemove]),
      });
    }).catchError((error) {
      print('Failed to remove favorite course: $error');
      throw error;
    });
  }

  //OK
  static Future<bool> isCourseInFavorites(
      String authorId, String courseId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final userDoc = _firestore.collection('users').doc(userId);

    try {
      DocumentSnapshot docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        Map<String, dynamic> favorites = data['favorites'] ?? {};

        // Ensure that favorites is a Map with authorId and courseId keys
        if (favorites.isNotEmpty) {
          String storedAuthorId = favorites['authorId'];
          String storedCourseId = favorites['courseId'];

          // Check if the stored authorId and courseId match the given ones
          return storedAuthorId == authorId && storedCourseId == courseId;
        }
      }

      return false;
    } catch (e) {
      print('Error checking if course is in favorites: $e');
      return false;
    }
  }

  //OK
  static Future<app_user.User> getUserData(String userId) async {
    try {
      // Reference to the user's document in Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User document does not exist.');
      }

      // Convert Firestore document to User model using the factory constructor
      app_user.User user = app_user.User.fromFirestore(userDoc);

      return user;
    } catch (e) {
      // Log the error for debugging purposes
      print('Error fetching user data: $e');
      // Rethrow the exception to be handled by the caller
      rethrow;
    }
  }

  /* static Future<void> updateUserData(
      BuildContext context, String userId, Map<String, dynamic> data) async {
    try {
      // Update user document in Firestore
      await _firestore.collection('users').doc(userId).update(data);

      // Optionally, you could show a success message or navigate somewhere
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data updated successfully!')),
      );
    } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to update user data: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }*/

  static Future<List<Author>> getAllAuthors() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('authors').get();

      return querySnapshot.docs
          .map((doc) => Author.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching all authors: $e');
      throw Exception("Failed to load authors");
    }
  }

  static Future<void> updateAuthorData(Author author) async {
    try {
      await _firestore
          .collection('authors')
          .doc(author.id)
          .update(author.toFirestore());
    } catch (e) {
      print('Error updating author data: $e');
      throw Exception("Failed to update author data");
    }
  }

  static Future<List<Map<String, dynamic>>> getCoursesAndSections(
      String authorId) async {
    List<Map<String, dynamic>> coursesWithSections = [];

    // authors -> authorId -> courses
    var coursesSnapshot = await FirebaseFirestore.instance
        .collection('authors')
        .doc(authorId)
        .collection('courses')
        .get();

    for (var course in coursesSnapshot.docs) {
      // courses -> courseId -> sections
      var sectionsSnapshot =
          await course.reference.collection('sections').get();

      List<Map<String, dynamic>> sections = [];

      for (var section in sectionsSnapshot.docs) {
        // sections -> sectionId -> videos
        var videosSnapshot = await section.reference.collection('videos').get();

        List<Map<String, dynamic>> videos = videosSnapshot.docs
            .map((video) => video.data()) // videoId'ye göre veriyi alıyoruz
            .toList();

        sections.add({
          'sectionName': section['name'], // section başlığı
          'videos': videos, // video listesi
        });
      }

      coursesWithSections.add({
        'courseName': course['name'], // kurs adı
        'sections': sections, // section listesi
      });
    }

    return coursesWithSections;
  }

  static Future<Author> fetchAuthorDetails(String authorId) async {
    try {
      DocumentSnapshot authorDoc =
          await _firestore.collection('authors').doc(authorId).get();

      if (!authorDoc.exists) {
        throw Exception('Author not found');
      }

      return Author.fromFirestore(authorDoc);
    } catch (e) {
      print('Error fetching author details: $e');
      throw Exception('Failed to load author details');
    }
  }

  static Future<List<Course>> fetchAuthorCourses(String authorId) async {
    try {
      QuerySnapshot coursesSnapshot = await _firestore
          .collection('authors')
          .doc(authorId)
          .collection('courses')
          .get();

      return coursesSnapshot.docs
          .map((doc) => Course.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching author courses: $e');
      throw Exception('Failed to load author courses');
    }
  }

  static Future<List<Video>> fetchCourseVideos(
      String authorId, String courseId) async {
    try {
      print('Fetching videos for author: $authorId, course: $courseId');

      // Fetch all sections for the course
      QuerySnapshot sectionsSnapshot = await _firestore
          .collection('authors')
          .doc(authorId)
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .orderBy('order')
          .get();

      List<Video> allVideos = [];

      // Iterate through each section and fetch its videos
      for (var sectionDoc in sectionsSnapshot.docs) {
        String sectionId = sectionDoc.id;

        QuerySnapshot videosSnapshot = await _firestore
            .collection('authors')
            .doc(authorId)
            .collection('courses')
            .doc(courseId)
            .collection('sections')
            .doc(sectionId)
            .collection('videos')
            .orderBy('order')
            .get();

        // Convert each video document to a Video object and add to the list
        List<Video> sectionVideos =
            videosSnapshot.docs.map((doc) => Video.fromFirestore(doc)).toList();
        allVideos.addAll(sectionVideos);
      }

      print('Total videos fetched: ${allVideos.length}');
      return allVideos;
    } catch (e) {
      print('Error fetching videos for course $courseId: $e');
      throw Exception('Failed to load course videos');
    }
  }
}

class UserProgressService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserProgress?> getProgress(String courseId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final progressDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(courseId)
          .get();

      if (progressDoc.exists) {
        return UserProgress.fromFirestore(progressDoc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting progress for course $courseId: $e');
      return null;
    }
  }
}

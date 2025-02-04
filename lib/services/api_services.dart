// Updated ApiService with getUserById and getUserCourses including model conversion

import 'package:cyber_security_app/models/authors.dart';
import 'package:cyber_security_app/models/sections.dart';
import 'package:cyber_security_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../models/course.dart';

const String baseUrl = 'http://165.232.76.61:5001';

class ApiService {
  // Common function to handle GET requests
  static Future<dynamic> getRequest(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data from $endpoint');
    }
  }

  // Common function to handle POST requests
  static Future<int> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.statusCode;
    } else {
      print('Error posting data to $endpoint: ${response.body}');
      throw Exception('Failed to post data to $endpoint');
    }
  }

  static Future<void> putRequest(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Debug: Put request successful to $endpoint');
    } else {
      print(
          'Debug: Failed to update data. Status code: ${response.statusCode}');
      throw Exception(
          'Failed to update data to $endpoint. Status code: ${response.statusCode}');
    }
  }

  // Common function to handle DELETE requests
  static Future<http.Response> deleteRequest(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Debug: Successfully deleted data at $endpoint');
      return response;
    } else {
      print('Error deleting data at $endpoint: ${response.body}');
      throw Exception('Error deleting data: ${response.statusCode}');
    }
  }

  // AUTH SERVICE
  static Future<dynamic> login(String email, String password) async {
    return await postRequest('/api/Auth/login', {
      'email': email,
      'password': password,
    });
  }

  static Future<dynamic> register(
      String email, String password, String name) async {
    return await postRequest('/api/Auth/register', {
      'email': email,
      'password': password,
      'name': name,
    });
  }

  // USERS SERVICE
  static Future<UserModel> getUserById(int userId) async {
    final response = await getRequest('/api/Users/$userId');
    return UserModel.fromMap(
        response); // Ensure this parses the Map into UserModel
  }

  static Future<UserModel> getUserProfile(int userId) async {
    try {
      print('Fetching user profile for userId: $userId');
      final response = await getRequest('/api/Users/profile/$userId');
      if (response.containsKey('data')) {
        return UserModel.fromMap(response['data']);
      } else {
        throw Exception('Invalid response format: missing data field');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      throw Exception('Failed to fetch user profile for userId: $userId');
    }
  }

  static Future<UserModel> getUserByFirebaseUID(String firebaseUID) async {
    try {
      final response =
          await getRequest('/api/Users/getbyfirebaseuid/$firebaseUID');
      print('Fetched user: $response');

      if (response.containsKey('data')) {
        return UserModel.fromMap(response['data']);
      } else {
        throw Exception('Invalid response format: missing "data" key.');
      }
    } catch (e) {
      print('Error fetching user by Firebase UID: $e');
      throw Exception('Failed to fetch user by Firebase UID.');
    }
  }

  static Future<Map<int, String>> matchAuthorIdAndName() async {
    try {
      final authorsData = await getRequest('/api/Authors/getall');
      if (authorsData == null || authorsData.isEmpty) {
        throw Exception('No authors data found.');
      }

      // Create a map of authorID to authorName
      final Map<int, String> authorMap = {
        for (var author in authorsData)
          author['authorID']: author['name'] ?? 'Unknown',
      };

      print('Debug: Author map created: $authorMap');
      return authorMap;
    } catch (e) {
      print('Error fetching authors: $e');
      throw Exception('Failed to fetch authors.');
    }
  }

  static Future<Map<int, String>> matchLevelIdAndName() async {
    try {
      print('Fetching levels...');
      final levelsResponse = await getRequest('/api/Levels/getall');

      if (levelsResponse is List) {
        final Map<int, String> levelMap = {
          for (var level in levelsResponse)
            level['levelId']: level['name'] ?? 'Unknown Level',
        };
        print('Level map created: $levelMap');
        return levelMap;
      } else {
        throw Exception('Invalid response format for getAllLevels');
      }
    } catch (e) {
      print('Error fetching levels: $e');
      throw Exception('Failed to fetch levels');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserCourses(int userId) async {
    try {
      print('Fetching students...');
      final studentsResponse = await getRequest('/api/Students');

      // Handle both cases: response as List or Map with "data"
      final List<Map<String, dynamic>> students = studentsResponse is List
          ? List<Map<String, dynamic>>.from(studentsResponse)
          : (studentsResponse is Map && studentsResponse.containsKey('data'))
              ? List<Map<String, dynamic>>.from(studentsResponse['data'])
              : throw Exception('Invalid students response format.');

      print('Students response: $students');

      // Find the matching student
      final matchingStudent = students.firstWhere(
        (student) => student['userId'] == userId,
        orElse: () =>
            throw Exception('No matching studentId for userId: $userId'),
      );

      final int? studentId = matchingStudent['studentId'];
      if (studentId == null) {
        throw Exception('Student ID is null for userId: $userId');
      }
      print('Matched studentId: $studentId');

      print('Fetching courses...');
      final coursesResponse = await getRequest('/api/Courses/getall');

      // Handle both cases: response as List or Map with "data"
      final List<Map<String, dynamic>> courses = coursesResponse is List
          ? List<Map<String, dynamic>>.from(coursesResponse)
          : (coursesResponse is Map && coursesResponse.containsKey('data'))
              ? List<Map<String, dynamic>>.from(coursesResponse['data'])
              : throw Exception('Invalid courses response format.');

      print('Courses response: $courses');

      List<Map<String, dynamic>> userCourses = [];

      for (var course in courses) {
        final int? courseId = course['courseID'];
        if (courseId == null) {
          print('Skipping course with null id: $course');
          continue;
        }

        print('Checking registration for courseId: $courseId');

        final studentCoursesResponse = await getRequest(
            '/api/StudentCourses/getstudentsbycourse?courseId=$courseId');

        // Handle response from /api/StudentCourses/getstudentsbycourse
        final List<
            Map<String, dynamic>> studentsInCourse = studentCoursesResponse
                is List
            ? List<Map<String, dynamic>>.from(studentCoursesResponse)
            : throw Exception(
                'Invalid response format for /api/StudentCourses/getstudentsbycourse/$courseId');

        if (studentsInCourse.any((entry) => entry['studentId'] == studentId)) {
          final courseMap = {
            'course': Course.fromMap(course),
            'authorId': course['authorId'],
            'authorName': course['authorName'] ?? 'Unknown',
          };
          userCourses.add(courseMap);
        }
      }

      print('User courses fetched successfully: $userCourses');
      return userCourses;
    } catch (e) {
      print('Error in getUserCourses: $e');
      throw Exception('Failed to fetch courses for userId: $userId');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await getRequest('/api/Users/getall');

    // Ensure the response is a list, not a map
    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    } else if (response is Map && response.containsKey('data')) {
      return List<Map<String, dynamic>>.from(response['data']);
    } else {
      throw Exception('Invalid response format.');
    }
  }

  static Future<List<Map<String, dynamic>>> recommendedCourses(
      int userId) async {
    try {
      print('Fetching students...');
      final studentsResponse = await getRequest('/api/Students');

      // Handle both cases: response as List or Map with "data"
      final List<Map<String, dynamic>> students = studentsResponse is List
          ? List<Map<String, dynamic>>.from(studentsResponse)
          : (studentsResponse is Map && studentsResponse.containsKey('data'))
              ? List<Map<String, dynamic>>.from(studentsResponse['data'])
              : throw Exception('Invalid students response format.');

      print('Students response: $students');

      // Find the matching student
      final matchingStudent = students.firstWhere(
        (student) => student['userId'] == userId,
        orElse: () =>
            throw Exception('No matching studentId for userId: $userId'),
      );

      final int? studentId = matchingStudent['studentId'];
      if (studentId == null) {
        throw Exception('Student ID is null for userId: $userId');
      }
      print('Matched studentId: $studentId');

      print('Fetching all courses...');
      final coursesResponse = await getRequest('/api/Courses/getall');

      // Handle both cases: response as List or Map with "data"
      final List<Map<String, dynamic>> allCourses = coursesResponse is List
          ? List<Map<String, dynamic>>.from(coursesResponse)
          : (coursesResponse is Map && coursesResponse.containsKey('data'))
              ? List<Map<String, dynamic>>.from(coursesResponse['data'])
              : throw Exception('Invalid courses response format.');

      print('All Courses response: $allCourses');

      List<Map<String, dynamic>> recommendedCourses = [];

      for (var course in allCourses) {
        final int? courseId = course['courseID'];
        if (courseId == null) {
          print('Skipping course with null id: $course');
          continue;
        }

        print('Checking registration for courseId: $courseId');

        final studentCoursesResponse = await getRequest(
            '/api/StudentCourses/getstudentsbycourse?courseId=$courseId');

        // Handle response from /api/StudentCourses/getstudentsbycourse
        final List<
            Map<String, dynamic>> studentsInCourse = studentCoursesResponse
                is List
            ? List<Map<String, dynamic>>.from(studentCoursesResponse)
            : throw Exception(
                'Invalid response format for /api/StudentCourses/getstudentsbycourse/$courseId');

        // If the student is NOT enrolled in the course, add it to recommendedCourses
        if (!studentsInCourse.any((entry) => entry['studentId'] == studentId)) {
          final courseMap = {
            'course': Course.fromMap(course),
            'authorId': course['authorId'],
            'authorName': course['authorName'] ?? 'Unknown',
          };
          recommendedCourses.add(courseMap);
        }
      }

      print('Recommended courses fetched successfully: $recommendedCourses');
      return recommendedCourses;
    } catch (e) {
      print('Error in recommendedCourses: $e');
      throw Exception(
          'Failed to fetch recommended courses for userId: $userId');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllLevels() async {
    final response = await getRequest('/api/Levels/getall');

    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    } else {
      throw Exception('Invalid response format for getAllLevels.');
    }
  }

  // AUTHORS SERVICE
  static Future<List<Map<String, dynamic>>> getAllAuthors() async {
    final response = await getRequest('/api/Authors/getall');

    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    } else {
      throw Exception('Invalid response format for getAllAuthors.');
    }
  }

  static Future<Author> getAuthorById(int authorId) async {
    final response = await getRequest('/api/Authors/getbyid/$authorId');
    return Author.fromMap(response);
  }

  static Future<List<dynamic>> getTopRatedAuthors() async {
    return await getRequest('/api/Authors/top-rated-authors');
  }

  // CATEGORIES SERVICE
  static Future<List<dynamic>> getAllCategories() async {
    return await getRequest('/api/Categories/getall');
  }

  static Future<Map<String, dynamic>> getCategoryById(int categoryId) async {
    final response = await getRequest('/api/Categories/getbyid/$categoryId');
    if (response == null || response.isEmpty) {
      throw Exception('Failed to load category.');
    }
    return response;
  }

  // COURSES SERVICE
  static Future<List<dynamic>> getAllCourses() async {
    final response = await getRequest('/api/Courses/getall');

    if (response is Map && response.containsKey('data')) {
      // Handle the "data" key from the response
      return List<Map<String, dynamic>>.from(response['data']);
    } else if (response is List) {
      // Handle the case where the response is already a List
      return List<Map<String, dynamic>>.from(response);
    } else {
      throw Exception('Invalid response format for getAllCourses');
    }
  }

  static Future<Map<String, dynamic>> getCourseById(int courseId) async {
    final response = await getRequest('/api/Courses/getbyid?id=$courseId');
    if (response != null && response['data'] != null) {
      return response['data'];
    } else {
      throw Exception('Failed to fetch course with ID: $courseId');
    }
  }

  static Future<List<dynamic>> getCoursesByCategoryId(int categoryId) async {
    return await getRequest(
        '/api/Courses/getallbycategoryid?categoryId=$categoryId');
  }

  static Future<List<dynamic>> getTopRatedCourses() async {
    return await getRequest('/api/Courses/top-rated-courses');
  }

  static Future<dynamic> enrollCourse(int courseId, int userId) async {
    return await postRequest('/api/Courses/enroll', {
      'courseId': courseId,
      'userId': userId,
    });
  }

  // FAVORITE COURSES SERVICE

  static Future<int> addToFavorites(int courseId, int studentId) async {
    final response = await postRequest(
      '/api/FavoriteCourses/add',
      {
        'courseID': courseId,
        'studentID': studentId,
      },
    );
    return response;
  }

  static Future<int?> getStudentIdByUserId(int userId) async {
    try {
      final response = await getRequest('/api/Students');

      if (response != null && response is List) {
        final student = response.firstWhere(
          (student) => student['userId'] == userId,
          orElse: () => null,
        );
        return student?['studentId'];
      }
      return null;
    } catch (e) {
      print('Error fetching studentId: $e');
      return null;
    }
  }

  static Future<int> removeFromFavorites(int courseId, int studentId) async {
    final response = await deleteRequest(
        '/api/FavoriteCourses/delete?studentId=$studentId&courseId=$courseId');
    return response.statusCode;
  }

  static Future<List<dynamic>> getFavoriteCourses(int studentId) async {
    return await getRequest(
        '/api/FavoriteCourses/getbystudentid?studentId=$studentId');
  }

  static Future<bool> checkFavoriteStatus(int studentId, int courseId) async {
    final response = await getRequest(
        '/api/FavoriteCourses/check?studentId=$studentId&courseId=$courseId');
    return response == true;
  }

  static Future<Map<int, String>> getDepartmentMap() async {
    final response = await getRequest('/api/Departments');
    if (response == null || response.isEmpty) {
      throw Exception('Failed to load departments.');
    }

    // Ensuring that the map has the correct types
    final Map<int, String> departmentMap = {
      for (var department in response)
        department['departmentID'] as int:
            department['departmentName'] as String,
    };

    return departmentMap;
  }

  static Future<Map<int, String>> getCategoryMap() async {
    final response = await getRequest('/api/Categories/getall');
    if (response == null || response.isEmpty) {
      throw Exception('Failed to load departments.');
    }

    // Ensuring that the map has the correct types
    final Map<int, String> categoryMap = {
      for (var category in response)
        category['cateogoryId'] as int: category['name'] as String,
    };

    return categoryMap;
  }

  static Future<List<Author>> getAllAuthorsWithDepartments() async {
    try {
      // Fetch authors
      final authorsResponse = await getRequest('/api/Authors/getall');
      if (authorsResponse == null || authorsResponse.isEmpty) {
        throw Exception('Failed to load authors.');
      }

      final List<Author> authors = (authorsResponse as List)
          .map((authorData) => Author.fromMap(authorData))
          .toList();

      // Fetch department map
      final departmentMap = await getDepartmentMap();

      // Match department names to authors
      for (var author in authors) {
        author.departmentName = departmentMap[author.departmentID] ?? 'Unknown';
      }

      return authors;
    } catch (e) {
      print('Error fetching authors with departments: $e');
      throw Exception('Failed to load authors with departments.');
    }
  }

  // VIDEOS SERVICE
  static Future<List<dynamic>> getVideosBySectionId(int sectionId) async {
    return await getRequest('/api/Videos/section/$sectionId');
  }

  static Future<List<Section>> getSectionsByCourseId(int courseId) async {
    final response = await getRequest('/api/Sections/course/$courseId');
    if (response is List) {
      return response.map((data) => Section.fromMap(data)).toList();
    } else {
      throw Exception('Invalid response format for sections.');
    }
  }

  static Future<Map<String, dynamic>> getCourseProgress(
      int courseId, int userId) async {
    try {
      final response =
          await getRequest('/api/CourseProgress/$courseId/$userId');
      if (response == null) {
        throw Exception('No progress data received');
      }
      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('Error fetching course progress: $e');
      throw Exception('Failed to fetch course progress: $e');
    }
  }

  static Future<void> updateCourseProgress(
    int userId,
    int courseId,
    int videoId,
    double progress,
    double watchedDuration,
  ) async {
    try {
      await postRequest('/api/CourseProgress/update', {
        'courseId': courseId,
        'userId': userId,
        'videoId': videoId,
        'progress': progress,
        'watchedDuration': watchedDuration,
      });
    } catch (e) {
      print('Error updating course progress: $e');
      throw Exception('Failed to update course progress');
    }
  }
}

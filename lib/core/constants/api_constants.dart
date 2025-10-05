class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://opentdb.com';
  static const String apiPath = '/api.php';

  // Quiz difficulties
  static const String easy = 'easy';
  static const String medium = 'medium';
  static const String hard = 'hard';

  // Question types
  static const String multipleChoice = 'multiple';
  static const String trueFalse = 'boolean';

  // Response codes
  static const int success = 0;
  static const int noResults = 1;
  static const int invalidParameter = 2;
  static const int tokenNotFound = 3;
  static const int tokenEmpty = 4;
}

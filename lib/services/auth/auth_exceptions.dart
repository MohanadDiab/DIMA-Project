// Login Exceptions

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Registration Exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Generic Exceptions (shared)

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}


// 
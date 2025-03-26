String? validateStrongPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }
  final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  if (!passwordRegex.hasMatch(value)) {
    return 'Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character';
  }
  return null;
}

String? validateConsumerNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a consumer number';
  }

  RegExp pattern = RegExp(r'^\d{13}$');
  if (!pattern.hasMatch(value)) {
    return 'Please enter a valid 13-digit consumer number';
  }

  return null;
}
String? validateNotNull(String? value, String fieldName) {
  if (value == null || value.isEmpty) {
    return 'Please enter $fieldName';
  }
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }

  // Allow spaces and country code, but only digits otherwise
  RegExp regex = RegExp(r'^\+?[0-9 ]{10,20}$');
  if (!regex.hasMatch(value)) {
    return 'Enter a valid phone number';
  }
  return null; // Valid phone number
}





String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

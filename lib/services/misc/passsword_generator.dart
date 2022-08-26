import 'dart:math';

String generatePassword({
  bool letter = true,
  bool isNumber = true,
}) {
  const length = 10;
  const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
  const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  const number = '0123456789';

  String chars = "";
  if (letter) chars += '$letterLowerCase$letterUpperCase';
  if (isNumber) chars += '$number';

  return List.generate(length, (index) {
    final indexRandom = Random.secure().nextInt(chars.length);
    return chars[indexRandom];
  }).join('');
}

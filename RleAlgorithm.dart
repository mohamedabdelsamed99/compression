// RleAlgorithm.dart
class RleAlgorithm {
  // RLE Encode Function in Dart
  String rleEncode(String inputString) {
    if (inputString.isEmpty) {
      return "";
    }

    String encodedString = "";
    int count = 1;
    String prevChar = inputString[0];

    for (int i = 1; i < inputString.length; i++) {
      String char = inputString[i];
      if (char == prevChar) {
        count++;
      } else {
        encodedString += prevChar + count.toString();
        prevChar = char;
        count = 1;
      }
    }
    encodedString += prevChar + count.toString(); // Append last character

    return encodedString;
  }
}

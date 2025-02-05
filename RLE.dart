import 'dart:math'; // Import dart:math for logarithm and ceil function
import 'package:flutter/material.dart';
import 'RleAlgorithm.dart'; // Import the RLE algorithm file

class Rle extends StatefulWidget {
  const Rle({super.key});

  @override
  _RleState createState() => _RleState();
}

class _RleState extends State<Rle> {
  final TextEditingController _textController = TextEditingController();
  String _encodedText = "";
  String _originalSize = "";
  String _encodedSize = "";
  String _compressionRatio = "";
  String _wordCount = ""; // To hold the word count result
  String _maxRepeatCount = ""; // To hold the maximum repeat count
  String _log = ""; // To hold the log2 of maxRepeat

  // Instance of RleAlgorithm
  final rleAlgorithm = RleAlgorithm();

  // Function to count different words or sequences in the text
  // and also find the maximum repeat count of any word/character.
  Map<String, dynamic> no_terms(String text) {
    if (text.isEmpty) {
      return {'count': 0, 'maxRepeat': 0};
    }

    int count = 1; // At least one sequence exists
    int maxRepeat = 1; // To track the maximum repeat count
    int currentRepeat = 1; // Current repeat count
    String previousChar = text[0];

    for (int i = 1; i < text.length; i++) {
      if (text[i] != previousChar) {
        count++;
        maxRepeat = max(maxRepeat, currentRepeat);
        currentRepeat = 1;
        previousChar = text[i];
      } else {
        currentRepeat++;
      }
    }

    // Final check for the last repeat
    maxRepeat = max(maxRepeat, currentRepeat);

    return {'count': count, 'maxRepeat': maxRepeat};
  }

  // Function to validate input (only alphabets and integers)
  bool isValidInput(String input) {
    RegExp alphabeticRegex = RegExp(r'^[a-zA-Z]+$');
    RegExp integerRegex = RegExp(r'^[0-9]+$');

    return alphabeticRegex.hasMatch(input) || integerRegex.hasMatch(input);
  }

  // Compress the Text
  void compressText() {
    String inputText = _textController.text;

    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter text to compress!'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!isValidInput(inputText)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid input. Please enter only alphabetic or numeric text!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Run RLE encoding using the RleAlgorithm class
      String encoded = rleAlgorithm.rleEncode(inputText);

      // Calculate the Compression Ratio (CR)
      int originalSizeInBits = inputText.length * 8; // Each character = 8 bits
      int encodedSizeInBits = encoded.length * 8; // Each character = 8 bits

      // Get the word count and max repeat count
      var termsData = no_terms(inputText);
      int maxRepeat = termsData['maxRepeat'];

      // Calculate log2(maxRepeat)
      double logValue = maxRepeat > 0
          ? log(maxRepeat) / log(2) // log2(maxRepeat)
          : 0.0;

      // Take the ceiling of the log value
      int ceilLogValue = logValue > 0 ? logValue.ceil() : 0;

      // Declare the compression ratio variable
      double cr;

      // Fix the compression ratio formula based on input type
      if (RegExp(r'^[a-zA-Z]+$').hasMatch(inputText)) {
        cr = (originalSizeInBits / (termsData['count'] * (8 + ceilLogValue)));
      } else {
        cr = ((originalSizeInBits/8) / (termsData['count'] * (1 + ceilLogValue)));
      }

      setState(() {
        _encodedText = encoded;
        _originalSize = "${inputText.length} characters ($originalSizeInBits bits)";
        _encodedSize = "${encoded.length} characters ($encodedSizeInBits bits)";
        _compressionRatio = cr.toStringAsFixed(2); // Display CR with 2 decimal places

        // Set the word count and max repeat count
        _wordCount = "Different word count: ${termsData['count']}";
        _maxRepeatCount = "Max repeat count: $maxRepeat";

        // Set the log value (ceiling of log2)
        _log = "Ceiling of Log2(maxRepeat): $ceilLogValue";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RLE Technique"),
        titleTextStyle: TextStyle(fontSize: 30, color: Colors.amber[900]),
        backgroundColor: Colors.black,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              minLines: 1,
              maxLines: 10,
              maxLength: 300,
              decoration: InputDecoration(
                hintText: "Enter the text to compress",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: compressText,
              height: 50,
              minWidth: 200,
              color: Colors.black,
              textColor: Colors.amber[900],
              child: Text("Compress the Text"),
            ),
            SizedBox(height: 20),
            if (_encodedText.isNotEmpty) ...[
              Text(
                "Encoded Text:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(_encodedText),
              SizedBox(height: 20),
              Text(
                "Original Size: $_originalSize",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Encoded Size: $_encodedSize",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Compression Ratio (CR): $_compressionRatio",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                _wordCount, // Display the different word count
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                _maxRepeatCount, // Display the max repeat count
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                _log, // Display the ceiling of log2(maxRepeat)
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

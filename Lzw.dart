import 'package:comp/Lzwcode.dart'; // Assuming this file exists and contains the LZW class
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Lzw(),
  ));
}

class Lzw extends StatefulWidget {
  @override
  _LzwState createState() => _LzwState();
}

class _LzwState extends State<Lzw> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _decompressedTextController = TextEditingController(); // New controller for decompressed data input
  String _compressedData = "";
  String _decompressedData = "";
  String _originalSize = "";
  String _compressedSize = "";
  String _compressionRatio = "";

  void compressText() {
    // Clear previous Snackbar messages
    ScaffoldMessenger.of(context).clearSnackBars();

    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Input cannot be empty."), backgroundColor: Colors.red),
      );
      return;
    }

    // Validate that the input contains only alphabetic characters
    if (!_textController.text.contains(RegExp(r'^[a-zA-Z]+$'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Input must only contain alphabetic characters."), backgroundColor: Colors.red),
      );
      return;
    }

    // Perform LZW compression
    String inputText = _textController.text;
    List<int> compressed = LZW.compress(inputText);

    // Calculate compressed size dynamically
    int compressedBits = compressed.fold(0, (sum, code) {
      int bitsForCode = code.bitLength; // Calculate bits required for each code
      return sum + bitsForCode;
    });

    int originalBits = inputText.length * 8; // Each character is 8 bits

    setState(() {
      _compressedData = compressed.toString();
      _originalSize = "$originalBits bits"; // Original size in bits
      _compressedSize = "$compressedBits bits"; // Compressed size in bits
      _compressionRatio = (originalBits / compressedBits).toStringAsFixed(2); // CR to 2 decimals
    });
  }

  void decompressText() {
    // Clear previous Snackbar messages
    ScaffoldMessenger.of(context).clearSnackBars();

    if (_decompressedTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Compressed data cannot be empty."), backgroundColor: Colors.red),
      );
      return;
    }

    // Validate that the input is a valid comma-separated list of numbers
    if (!_decompressedTextController.text.contains(RegExp(r'^[0-9,]+$'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Decompressed data must be a comma-separated list of numbers."), backgroundColor: Colors.red),
      );
      return;
    }

    // Convert the custom compressed data input (comma-separated integers) back to a list of integers
    List<int> compressedList = _decompressedTextController.text
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',')
        .map((e) => int.parse(e.trim()))
        .toList();

    // Perform LZW decompression
    String decompressed = LZW.decompress(compressedList);

    setState(() {
      _decompressedData = decompressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LZW Compression"),
        titleTextStyle: TextStyle(fontSize: 30, color: Colors.amber[900]),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the text to compress',
                ),
                minLines: 1,
                maxLines: 3,
                maxLength: 100,
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: compressText,
                height: 75,
                minWidth: 200,
                color: Colors.black,
                textColor: Colors.amber[900],
                child: Text("Compress the Data"),
              ),
              SizedBox(height: 20),
              if (_compressedData.isNotEmpty) ...[
                Text(
                  "Compressed Data:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(_compressedData),
                SizedBox(height: 20),
                Text(
                  "Original Size: $_originalSize",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Compressed Size: $_compressedSize",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Compression Ratio (CR): $_compressionRatio",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _decompressedTextController, // New TextField for custom input
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter custom compressed data (comma-separated)',
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                MaterialButton(
                  onPressed: decompressText,
                  height: 75,
                  minWidth: 200,
                  color: Colors.black,
                  textColor: Colors.amber[900],
                  child: Text("Decompress the Data"),
                ),
              ],
              if (_decompressedData.isNotEmpty) ...[
                SizedBox(height: 20),
                Text(
                  "Decompressed Data:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(_decompressedData),
              ],
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

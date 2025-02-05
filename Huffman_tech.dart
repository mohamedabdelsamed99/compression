import 'package:flutter/material.dart';
import 'huffman_coding.dart';

class Huffman_tech extends StatefulWidget {
  const Huffman_tech({super.key});

  @override
  State<Huffman_tech> createState() => _HuffmanTechState();
}

class _HuffmanTechState extends State<Huffman_tech> {
  final TextEditingController _textController = TextEditingController();
  String _compressedText = "";
  String _huffmanCodes = "";
  String _originalSize = "";
  String _encodedSize = "";
  String _compressionRatio = "";

  // Method to validate user input
  bool isValidInput(String input) {
    // Check if the input contains only valid characters (letters or spaces)
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(input);
  }

  void compressText() {
    String inputText = _textController.text;

    // Validate input text
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter text to compress.")
        ,          backgroundColor: Colors.red,

        ),
        
      );
      return;
    }

    // Check for invalid characters
    if (!isValidInput(inputText)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid input. Only alphabetic characters are allowed."),
                  backgroundColor: Colors.red,
),
      );
      return;
    }

    var huffman = HuffmanCoding();
    var result = huffman.compressWithDetails(inputText);

    // Calculate Compression Ratio (CR)
    double cr = result["originalSize"] / result["encodedSize"];
    setState(() {
      _compressedText = result["encodedText"];
      _huffmanCodes = result["codes"]
          .entries
          .map((entry) => "'${entry.key}': '${entry.value}'")
          .join(", ");
      _originalSize = "${result["originalSize"]} bits";
      _encodedSize = "${result["encodedSize"]} bits";
      _compressionRatio = cr.toStringAsFixed(2); // Display CR with 2 decimal places
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Huffman Algorithm"),
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.amber[900]),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 350),
            TextField(
              controller: _textController,
              minLines: 1,
              maxLines: 3,
              maxLength: 100,
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
              color: Colors.black,
              textColor: Colors.amber[900],
              child: Text("Compress the Data"),
            ),
            SizedBox(height: 20),
            if (_huffmanCodes.isNotEmpty) ...[
              Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Huffman Codes:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(_huffmanCodes),
                      SizedBox(height: 10),
                      Text("Encoded Text:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(_compressedText),
                      SizedBox(height: 10),
                      Text("Original Size: $_originalSize"),
                      Text("Encoded Size: $_encodedSize"),
                      SizedBox(height: 10),
                      Text("Compression Ratio (CR): $_compressionRatio", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'dart:collection';

// Node class to represent a node in the Huffman Tree
class HuffmanNode {
  String? character; // The character this node represents (null for internal nodes)
  int frequency; // Frequency of the character
  HuffmanNode? left; // Left child
  HuffmanNode? right; // Right child

  // Constructor to initialize the node
  HuffmanNode(this.character, this.frequency, [this.left, this.right]);
}

// Main Huffman Coding class
class HuffmanCoding {
  // Build the Huffman Tree from a frequency map
  HuffmanNode buildTree(Map<String, int> frequency) {
    // Create a list of Huffman nodes (priority queue simulation)
    List<HuffmanNode> heap = [];
    // Add nodes for each character in the frequency map
    heap.addAll(frequency.entries.map((entry) => HuffmanNode(entry.key, entry.value)));
    // Sort the list by frequency (ascending order)
    heap.sort((a, b) => a.frequency.compareTo(b.frequency));

    // Merge nodes until there is only one node (the root of the tree)
    while (heap.length > 1) {
      var left = heap.removeAt(0); // Remove the node with the smallest frequency
      var right = heap.removeAt(0); // Remove the next smallest node
      // Merge the two nodes into a new parent node
      var merged = HuffmanNode(null, left.frequency + right.frequency, left, right);
      // Add the merged node back into the list
      heap.add(merged);
      // Re-sort the list by frequency
      heap.sort((a, b) => a.frequency.compareTo(b.frequency));
    }

    // The remaining node is the root of the Huffman Tree
    return heap.first;
  }

  // Generate Huffman codes for each character
  void generateCodes(HuffmanNode node, Map<String, String> codes, String prefix) {
    // Base case: If the node is a leaf (has a character), assign its code
    if (node.character != null) {
      codes[node.character!] = prefix; // Map the character to its Huffman code
      return;
    }

    // Recursive case: Traverse left and right children
    // Append "0" for left and "1" for right to the prefix
    generateCodes(node.left!, codes, "${prefix}0");
    generateCodes(node.right!, codes, "${prefix}1");
  }

  // Compress a given text and provide details about the process
  Map<String, dynamic> compressWithDetails(String text) {
    // Step 1: Count the frequency of each character in the text
    var frequency = <String, int>{};
    for (var char in text.split('')) {
      frequency[char] = (frequency[char] ?? 0) + 1; // Increment the frequency count
    }
    

    // Step 2: Build the Huffman Tree from the character frequencies
    var root = buildTree(frequency);

    // Step 3: Generate Huffman codes for each character
    var huffmanCodes = <String, String>{};
    generateCodes(root, huffmanCodes, ""); // Start with an empty prefix

    // Step 4: Encode the text using the Huffman codes
    var encodedText = text.split('').map((char) => huffmanCodes[char]!).join();

    // Step 5: Calculate sizes for comparison
    var originalSize = text.length * 8; // Each character is 8 bits in standard encoding
    var encodedSize = encodedText.length; // Total bits in the compressed text

    // Return a map containing the compression details
    return {
      "codes": huffmanCodes, // Huffman codes for each character
      "encodedText": encodedText, // The compressed binary string
      "originalSize": originalSize, // Size of the original text in bits
      "encodedSize": encodedSize, // Size of the compressed text in bits
    };
  }
}

class LZW {
  // Compresses the input string using LZW algorithm
  static List<int> compress(String input) {
    // Initialize the dictionary with ASCII characters
    // Keys are characters, and values are their ASCII codes (0 to 127)
    Map<String, int> dictionary = {for (int i = 0; i < 128; i++) String.fromCharCode(i): i};
    int dictSize = 128; // Next available code for new entries in the dictionary
    String current = ""; // Tracks the current sequence being processed
    List<int> compressedData = []; // List to store the resulting compressed data

    // Iterate through each character in the input string
    for (var char in input.split('')) {
      String combined = current + char; // Combine current sequence with the next character
      if (dictionary.containsKey(combined)) {
        // If the combined sequence is already in the dictionary, update `current`
        current = combined;
      } else {
        // Add the code for `current` to the compressed data
        compressedData.add(dictionary[current]!);
        // Add the new sequence `combined` to the dictionary with the next available code
        dictionary[combined] = dictSize++;
        // Reset `current` to the current character
        current = char;
      }
    }

    // If there's any remaining sequence in `current`, add its code to the compressed data
    if (current.isNotEmpty) {
      compressedData.add(dictionary[current]!);
    }

    // Return the list of compressed data as integer codes
    return compressedData;
  }

  // Decompresses the compressed data using LZW algorithm
  static String decompress(List<int> compressedData) {
    // Initialize the dictionary with ASCII characters
    // Keys are ASCII codes (0 to 127), and values are the corresponding characters
    Map<int, String> dictionary = {for (int i = 0; i < 128; i++) i: String.fromCharCode(i)};
    int dictSize = 128; // Next available code for new entries in the dictionary

    // Remove and get the first code from the compressed data
    String current = dictionary[compressedData.removeAt(0)]!;
    // Use a StringBuffer for efficient string concatenation
    StringBuffer decompressedData = StringBuffer(current);

    // Process each code in the compressed data
    for (var code in compressedData) {
      String entry;
      if (dictionary.containsKey(code)) {
        // If the code exists in the dictionary, retrieve the corresponding string
        entry = dictionary[code]!;
      } else if (code == dictSize) {
        // Special case: If the code equals the next available dictionary size,
        // it represents `current + current[0]`
        entry = current + current[0];
      } else {
        // If the code is invalid (not in the dictionary), throw an exception
        throw Exception("Invalid compressed data.");
      }

      // Append the retrieved string to the decompressed data
      decompressedData.write(entry);

      // Add the new sequence to the dictionary
      dictionary[dictSize++] = current + entry[0];

      // Update `current` for the next iteration
      current = entry;
    }

    // Convert the StringBuffer to a String and return the decompressed data
    return decompressedData.toString();


    
  }
}

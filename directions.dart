import 'package:comp/Huffman_tech.dart';
import 'package:comp/RLE.dart';
import 'package:comp/Lzw.dart';
import 'package:flutter/material.dart';

class Directions extends StatefulWidget {
  const Directions({super.key});

  @override
  _RegesterationState createState() => _RegesterationState();
}

class _RegesterationState extends State<Directions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compression App"),
        titleTextStyle: TextStyle(fontSize: 30, color: Colors.amber[900]),
        backgroundColor: Colors.black,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Copmression Techniques",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                 Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Huffman_tech()));
              },
              height: 75,
              minWidth: 200,
              color: Colors.black,
              textColor: Colors.amber[900],
              child: Text("Huffman"),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                 Navigator.of(context)
                     .push(MaterialPageRoute(builder: (context) => Rle()));
              },
              height: 75,
              minWidth: 200,
              color: Colors.black,
              textColor: Colors.amber[900],
              child: Text("RLE"),
            ),
             SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                 Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Lzw()));
              },
              height: 75,
              minWidth: 200,
              color: Colors.black,
              textColor: Colors.amber[900],
              child: Text("LZW"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}

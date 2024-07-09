import 'package:flutter/material.dart';

class aboutScreen  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://imgur.com/zBEopAj.png'),
            ),
            SizedBox(height: 20),
            Text(
              'About Our App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Este aplicativo e totalmente criado por Raul Gonçalves, com o conceito de facilitar a mobilidade da Covilhã, mais este aplicativo server para qualquer cidade',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Master Project',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Raul Gonçalves\n\n\n\n\n',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Follow Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.linked_camera), onPressed: () {  },
                ),
                IconButton(
                  icon: Icon(Icons.facebook), onPressed: () {  },
                ),
                IconButton(
                  icon: Icon(Icons.alternate_email), onPressed: () {  },
                ),
              ],
            ),
            Spacer(),
            Text(
              '© 2024 Raul Gonçalves',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

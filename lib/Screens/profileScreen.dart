import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papproject/Screens/homeScreen.dart';
import 'package:papproject/Screens/routesScreen.dart';

import 'aboutScreen.dart';
import 'busScreen.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _imageURL;

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => homeScreen()));
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>?;
          setState(() {
            _imageURL = data != null && data.containsKey('imageUrl')
                ? data['imageUrl']
                : null;
          });
        } else {
          print('Documento do usuário não encontrado');
        }
      } catch (e) {
        print('Erro ao carregar perfil do usuário: $e');
      }
    }
  }

  Future<String> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          return data['name'];
        } else {
          throw Exception('Documento do usuário não encontrado');
        }
      } catch (e) {
        throw Exception('Erro ao buscar nome do usuário: $e');
      }
    } else {
      throw Exception('Usuário não está logado');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    User? user = _auth.currentUser;
    if (user != null && _imageFile != null) {
      Reference storageReference =
      FirebaseStorage.instance.ref().child('user_profiles/${user.uid}');
      try {
        UploadTask uploadTask = storageReference.putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        String fileURL = await snapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .update({
          'imageUrl': fileURL,
        });
        setState(() {
          _imageURL = fileURL;
        });
      } on FirebaseException catch (e) {
        print("Erro no upload da imagem: ${e.message}");
      } catch (e) {
        print("Erro inesperado: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/back_ground.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder<String>(
                  future: _fetchUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return Stack(
                        children: [
                          Container(
                            width: 375,
                            height: 350,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                        radius: 115,
                                        backgroundImage: _imageURL != null
                                            ? NetworkImage(_imageURL!)
                                            : NetworkImage(
                                                "https://cdn-icons-png.flaticon.com/512/4646/4646084.png")),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    snapshot.data ?? '',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            width: 50,
                            height: 50,
                            top: 0,
                            left: 0,
                            child: IconButton(
                              icon: Icon(Icons.exit_to_app, color: Colors.red),
                              onPressed: () => _confirmSignOut(context),
                            ),
                          ),
                          Positioned(
                            width: 50,
                            height: 50,
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.green),
                              onPressed: _pickImage,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text('Nenhum dado encontrado');
                    }
                  },
                ),
                SizedBox(height: 10),
                Container(
                  width: 375,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: <Widget>[
                      _buildGridItem(
                        context,
                        icon: Icons.map,
                        label: "Mapa",
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => homeScreen()),
                        ),
                      ),
                      _buildGridItem(
                        context,
                        icon: Icons.location_on,
                        label: "Rota",
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => routeScreen()),
                        ),
                      ),
                      _buildGridItem(
                        context,
                        icon: Icons.directions_bus,
                        label: "Ônibus",
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => busScreen()),
                        ),
                      ),
                      _buildGridItem(
                        context,
                        icon: Icons.question_mark,
                        label: "Duvida",
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => aboutScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(icon, color: Colors.indigo.shade900, size: 50),
            onPressed: onPressed,
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.indigo.shade900,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja sair da conta?'),
          actions: [
            TextButton(
              onPressed: () {
                _logout();
                Navigator.of(context).pop();
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Não'),
            ),
          ],
        );
      },
    );
  }
}


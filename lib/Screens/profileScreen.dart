import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:papproject/Screens/homeScreen.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => homeScreen()));
  }

  Future<String> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
      return userDoc['name'];
    } else {
      throw Exception('NÃO ESTÁ LOGADO');
    }
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
                                  CircleAvatar(
                                    radius: 115,
                                    backgroundImage: NetworkImage(
                                        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                                  ),
                                  SizedBox(height: 10),
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
                          const Positioned(
                            width: 50,
                            height: 50,
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.green),
                              onPressed: null,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text('Nenhum dado encontrado');
                    }
                  },
                ),
                SizedBox(height: 1),
                Container(
                  width: 375,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.access_time,
                                  color: Colors.indigo.shade900, size: 50),
                              onPressed: null,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Hórario",
                              style: TextStyle(
                                color: Colors.indigo.shade900,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.location_on,
                                  color: Colors.indigo.shade900, size: 50),
                              onPressed: null,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Paragens",
                              style: TextStyle(
                                color: Colors.indigo.shade900,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.directions_bus,
                                  color: Colors.indigo.shade900, size: 50),
                              onPressed: null,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Ônibus",
                              style: TextStyle(
                                color: Colors.indigo.shade900,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.question_mark,
                                  color: Colors.indigo.shade900, size: 50),
                              onPressed: null,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Duvida",
                              style: TextStyle(
                                color: Colors.indigo.shade900,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
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

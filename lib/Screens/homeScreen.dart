import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papproject/Screens/profileScreen.dart';
import '../FireBase/direction_service.dart';
import 'loginScreen.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final LatLng _center = const LatLng(40.2826, -7.50326);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _imageURL;
  GoogleMapController? _mapController;
  Polyline? _routePolyline;
  final DirectionService _directionService = DirectionService(apiKey: 'MY KEY'); // Substitua pela sua chave de API

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _getRoute();
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
      Reference storageReference = FirebaseStorage.instance.ref().child('user_profiles/${user.uid}');
      try {
        UploadTask uploadTask = storageReference.putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        String fileURL = await snapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('user').doc(user.uid).update({
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

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
      final data = userDoc.data() as Map<String, dynamic>?;
      setState(() {
        _imageURL = data != null && data.containsKey('imageUrl') ? data['imageUrl'] : null;
      });
    }
  }

  void _onClickWithButton() {
    User? user = _auth.currentUser;
    if (user == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const loginScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const profileScreen()));
    }
  }

  Future<void> _getRoute() async {
    LatLng _startLocation = LatLng(40.2826, -7.50326); // Defina a localização inicial
    LatLng _endLocation = LatLng(40.2918, -7.5073); // Defina a localização final

    try {
      final List<LatLng> routeCoords = await _directionService.getRouteCoordinates(_startLocation, _endLocation);
      setState(() {
        _routePolyline = Polyline(
          polylineId: PolylineId('route'),
          points: routeCoords,
          color: Colors.blue,
          width: 5,
        );
      });
    } catch (e) {
      print("Erro ao obter a rota: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Pesquise Aqui.",
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.location_city, color: Colors.grey),
              suffixIcon: GestureDetector(
                onTap: _onClickWithButton,
                child: CircleAvatar(
                  radius: 10,
                  backgroundImage: _imageURL != null
                      ? NetworkImage(_imageURL!)
                      : const NetworkImage("https://cdn-icons-png.flaticon.com/512/4646/4646084.png"),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            polylines: _routePolyline != null ? {_routePolyline!} : {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Paragens"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Horários"),
          BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: "Ônibus"),
        ],
      ),
    );
  }
}

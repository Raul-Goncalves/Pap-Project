import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papproject/Screens/busScreen.dart';
import 'package:papproject/Screens/profileScreen.dart';
import 'package:papproject/Screens/routesScreen.dart';
import 'package:papproject/widgets/show_popup.dart';
import '../FireBase/direction_service.dart';
import '../widgets/toast.dart';
import 'authection/loginScreen.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  dynamic selectedStop;
  bool showPopup = false;

  Set<Marker> markers =  {};
  BitmapDescriptor? _customIcon;

  final LatLng _center = const LatLng(40.2826, -7.50326); // Covilhã
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  String? _imageURL;
  GoogleMapController? _mapController;
  LatLng? _tagetLocation;

  int _selectButton = 0;
  bool _MarkersVisile = false;

  final DirectionService _directionService = DirectionService(apiKey: 'MY KEY');

  Future<void> _loadMapStyle() async {
    String style = await rootBundle.loadString('assets/map_style.json');
    _mapController?.setMapStyle(style);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _loadMapStyle();
    _moveCamToLocation();
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

  void _onItemTapped(int index){
    setState(() {
      if (index == 0) {
        _MarkersVisile = !_MarkersVisile;
        if (_MarkersVisile) {
          _loadStops();
          showToast(message: "Paragens Ativada no Mapa");
        } else {
          markers.clear();
          showToast(message: "Paragens Desativadas no Mapa");
        }
      } else {
        _selectButton = index;
        if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => routeScreen()));
        } else if (index == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => busScreen()));
        }
      }
    });
  }

  Future<void> _loadCustomIcon() async {
    final ImageConfiguration imageConfiguration = ImageConfiguration(size: Size(48, 48));
    try {
      _customIcon = await BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/icone100x100.png');
    } catch (e) {
      print('Erro ao carregar ícone personalizado: $e');
      _customIcon = BitmapDescriptor.defaultMarker; // Use um marcador padrão em caso de erro
    }
  }

  Future<void> _loadStops() async {
    try {
      String data = await rootBundle.loadString('assets/rotas/all_stops_bus.json');
      final jsonResult = json.decode(data);

      if (jsonResult.containsKey('rota') && jsonResult['rota'] is List) {
        List<dynamic> routes = jsonResult['rota'];

        var line11Route = routes.firstWhere((route) => route['line'] == 11, orElse: () => null);
        if (line11Route != null && line11Route.containsKey('stops') && line11Route['stops'] is List) {
          List<dynamic> stops = line11Route['stops'];

          setState(() {
            markers.clear();
            for (var stop in stops) {
              double lat = stop['latitude'];
              double lng = stop['longitude'];
              String name = stop['name'];

              BitmapDescriptor? markerIcon = _customIcon;
              markerIcon ??= BitmapDescriptor.defaultMarker;

              markers.add(
                Marker(
                  markerId: MarkerId(name),
                  position: LatLng(lat, lng),
                  infoWindow: InfoWindow(title: name),
                  icon: markerIcon,
                  onTap: () {
                    setState(() {
                      selectedStop = stop; // Atualiza a paragem selecionada
                      showPopup = true; // Exibe o popup
                    });
                  },
                ),
              );
            }
          });
        } else {
          print('Nenhuma lista de paradas encontrada na rota com line.');
        }
      } else {
        print('Nenhuma rota encontrada no JSON.');
      }
    } catch (e) {
      print('Erro ao carregar paragens: $e');
    }
  }

  void _moveCamToLocation(){
    if(_tagetLocation != null){
      setState(() {
        markers.clear();
        markers.add(
          Marker(
              markerId: MarkerId('target'),
              position: _tagetLocation!,
              icon: _customIcon ?? BitmapDescriptor.defaultMarker,
          ),
        );
      });
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_tagetLocation!, 17),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if(args != null){
      final double latitude = args['latitude'] as double;
      final double longitude = args['longitude'] as double;
      _tagetLocation = LatLng(latitude, longitude);
      _moveCamToLocation();

    }
  }

  void updateSelectedStop(dynamic stop) {
    setState(() {
      selectedStop = stop;
    });
  }

  void _togglePopup() {
    setState(() {
      showPopup = !showPopup;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _loadUserProfile();
    _loadCustomIcon();
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
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            ),
          ),
        ),
      ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14,
              ),
              markers: Set<Marker>.from(markers),
              onTap: (LatLng latLng) {
                setState(() {
                  showPopup = false;
                });
              },
            ),
            // Popup
            if (showPopup && selectedStop != null)
              ShowPopup(
                selectedStop: selectedStop,
                onClose: _togglePopup,
              ),
          ],
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Paragens"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Rotas"),
          BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: "Ônibus"),
        ],
        currentIndex:  _selectButton,
        onTap:  _onItemTapped,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class editClockScreen extends StatefulWidget {
  final String rotaId;

  const editClockScreen({required this.rotaId, Key? key}) : super(key: key);

  @override
  _editClockScreen createState() => _editClockScreen();
}

class _editClockScreen extends State<editClockScreen> {
  
  Future<List<Map<String, dynamic>>> _fetchHorarios() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('horarios')
        .doc(widget.rotaId)
        .get();

    if (doc.exists) {
      List stops = (doc.data() as Map<String, dynamic>)['stops'];
      return stops.map((stop) => stop as Map<String, dynamic>).toList();
    } else {
      return [];
    }
  }

  Future<void> _loadDataFromFirestore() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('horarios').doc(widget.rotaId).get();
      if (doc.exists) {
        setState(() {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          List<Map<String, dynamic>> stops = List<Map<String, dynamic>>.from(data['stops']);
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do Firestore: $e');
    }
  }

  void _editClock(BuildContext context, Map<String, dynamic> stop) async {
    TextEditingController newHorarioController = TextEditingController();
    List<String> horarios = List<String>.from(stop['horario'] ?? []);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Horários - ${stop['name']}'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int index = 0; index < horarios.length; index++)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: horarios[index]),
                              onChanged: (value) {
                                horarios[index] = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                horarios.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    TextField(
                      controller: newHorarioController,
                      decoration: const InputDecoration(hintText: 'Adicionar novo horário'),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (newHorarioController.text.isNotEmpty) {
                  horarios.add(newHorarioController.text);
                  newHorarioController.clear();
                }
                await _updateHorarios(stop['id'], horarios);
                await _loadDataFromFirestore();

                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateHorarios(int stopId, List<String> horarios) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('horarios').doc(widget.rotaId);

      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> stops = List<Map<String, dynamic>>.from(data['stops']);

        for (var stop in stops) {
          if (stop['id'] == stopId) {
            stop['horario'] = List<String>.from(horarios);
            break;
          }
        }

        await docRef.update({'stops': stops});

      }
    } catch (e) {
      print('Erro ao atualizar horários: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
        centerTitle: true,
        title: Text('Editar ${widget.rotaId}',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchHorarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum dado encontrado.'));
          } else {
            List<Map<String, dynamic>> stops = snapshot.data!;
            return ListView.builder(
              itemCount: stops.length,
              itemBuilder: (context, index) {
                var stop = stops[index];
                var horarios = List<String>.from(stop['horario'] ?? []);
                return ListTile(
                  title: Text(stop['name']),
                  subtitle: Text(horarios.join(', ')),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editClock(context, stop);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
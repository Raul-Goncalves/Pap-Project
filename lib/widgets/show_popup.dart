import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowPopup extends StatefulWidget {
  final Map<String, dynamic> selectedStop;
  final Function onClose;

  ShowPopup({required this.selectedStop, required this.onClose});

  @override
  _ShowPopupState createState() => _ShowPopupState();
}

class _ShowPopupState extends State<ShowPopup> {
  List<Map<String, dynamic>> filteredHorarios = [];
  String? selectedDocumentName;
  List<dynamic> selectedHorarios = [];

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    List<Map<String, dynamic>> tempFilteredHorarios = await getFilteredHorarios(widget.selectedStop['id']);
    setState(() {
      filteredHorarios = tempFilteredHorarios;
    });
  }

  void sortHorarios(List<dynamic> horarios) {
    horarios.sort((a, b) {
      var timeA = a.split(':');
      var timeB = b.split(':');

      var hourA = int.parse(timeA[0]);
      var minA = int.parse(timeA[1]);
      var hourB = int.parse(timeB[0]);
      var minB = int.parse(timeB[1]);

      if (hourA != hourB) {
        return hourA.compareTo(hourB);
      } else {
        return minA.compareTo(minB);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getFilteredHorarios(int id) async {
    CollectionReference horarios = FirebaseFirestore.instance.collection('horarios');

    QuerySnapshot querySnapshot = await horarios.get();

    List<Map<String, dynamic>> filteredHorarios = [];

    for (var doc in querySnapshot.docs) {
      var stops = doc['stops'] as List<dynamic>;
      List<dynamic> compiledHorarios = [];

      for (var stop in stops) {
        if (stop['id'] == id) {
          compiledHorarios.addAll(stop['horario'] as List<dynamic>);
        }
      }

      if (compiledHorarios.isNotEmpty) {
        sortHorarios(compiledHorarios);
        print(compiledHorarios.toString());

        filteredHorarios.add({
          'documentName': doc.id,
          'horarios': compiledHorarios
        });
      }
    }

    return filteredHorarios;
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        height: 550,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.selectedStop['name'],
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      widget.onClose();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0),
            if (filteredHorarios.isEmpty)
              CircularProgressIndicator()
            else
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 50.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredHorarios.length,
                        itemBuilder: (context, index) {
                          var schedule = filteredHorarios[index];
                          var documentName = schedule['documentName'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedDocumentName = documentName;
                                  selectedHorarios = schedule['horarios'];
                                });
                              },
                              child: Text(documentName),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 50.0),
                    if (selectedDocumentName != null)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListView.builder(
                            itemCount: selectedHorarios.length,
                            itemBuilder: (context, index) {
                              return Text('Horario: ${selectedHorarios[index]}');
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

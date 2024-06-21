import 'package:flutter/material.dart';

class ShowPopup extends StatelessWidget {
  final dynamic selectedStop;
  final Function onClose;

  ShowPopup({required this.selectedStop, required this.onClose});


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
        child:Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedStop['name'],
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      onClose();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 350,
              width: 550,
              child: ListView.builder(
                itemCount: 10,  // Número de itens na lista
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item ${index + 1}'),  // Títulos dos itens da lista
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton.icon(
                onPressed: null,
                label: Icon(Icons.ac_unit)
            )
          ],
        )
      ),
    );
  }
}
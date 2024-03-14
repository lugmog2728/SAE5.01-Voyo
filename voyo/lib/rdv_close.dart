import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

class RdvClosePage extends StatefulWidget {
  const RdvClosePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RdvClosePage> createState() => _RdvClosePageState();
}

class _RdvClosePageState extends State<RdvClosePage> {
  List<bool> _isOpen = [false, false, false]; // State for whether each point is open

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Placeholder pour les rectangles de points
              _buildPointRectangle('Point 1', 0),
              _buildPointRectangle('Point 2', 1),
              _buildPointRectangle('Point 3', 2),
              // Bouton Valider
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Action lorsque le bouton de validation est pressé
                  },
                  child: Text('Valider'),
                ),
              ),
            ],
          ),
        ),
      ),
      widget,
      context,
    );
  }

  Widget _buildPointRectangle(String pointName, int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                _isOpen[index] = !_isOpen[index]; // Invert the state
              });
            },
            child: Container(
              height: 50,
              color: Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(pointName),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isOpen[index] = !_isOpen[index]; // Invert the state
                      });
                    },
                    icon: Icon(_isOpen[index] ? Icons.expand_less : Icons.expand_more),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Contenu du point
        if (_isOpen[index]) _buildPointContent(),
      ],
    );
  }

  Widget _buildPointContent() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Column(
        children: [
          Text('Contenu du point'),
          // Ajoutez ici le contenu spécifique du point
        ],
      ),
    );
  }
}

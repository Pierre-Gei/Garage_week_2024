import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/userModel.dart';
import '../facture_screen/facture_screen.dart';
import '../planning_screen/planning_screen.dart';

//main
void main() {
  runApp(Veolia_screen(user: User(id: '1', login: '', password: '', nom: '', ville: '', role: '', entrepriseId: '',)));
}

class Veolia_screen extends StatelessWidget {
  const Veolia_screen({Key? key, required User user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veolia Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    _requestPermissions(); // Demande les permissions lors de l'ouverture de l'application
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veolia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Action pour le profil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlanningPage()),
                );
              },
              child: const Text('Planning'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FacturesPage()),
                );
              },
              child: const Text('Factures'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const FacturesPreview(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatistiquesPage()),
                );
              },
              child: const Text('Statistiques'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacturesPreview extends StatelessWidget {
  const FacturesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> factures = [
      {'title': 'Carrefour', 'amount': '800€'},
      {'title': 'Leclerc', 'amount': '1260€'},
      {'title': 'Déchèterie', 'amount': '1230€'},
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Factures', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: factures.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(factures[index]['title']!),
                subtitle: Text(factures[index]['amount']!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FactureDetailPage(facture: factures[index]),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class FacturesPage extends StatelessWidget {
  const FacturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> factures = [
      {
        'title': 'Carrefour',
        'amount': 800,
        'details': [
          {'item': 'Produit A', 'quantity': 10, 'unitPrice': 20.0, 'total': 200.0},
          {'item': 'Produit B', 'quantity': 20, 'unitPrice': 30.0, 'total': 600.0},
        ],
      },
      {
        'title': 'Leclerc',
        'amount': 1260,
        'details': [
          {'item': 'Produit C', 'quantity': 5, 'unitPrice': 50.0, 'total': 250.0},
          {'item': 'Produit D', 'quantity': 10, 'unitPrice': 101.0, 'total': 1010.0},
        ],
      },
      {
        'title': 'Déchèterie',
        'amount': 1230,
        'details': [
          {'item': 'Produit E', 'quantity': 15, 'unitPrice': 50.0, 'total': 750.0},
          {'item': 'Produit F', 'quantity': 20, 'unitPrice': 24.0, 'total': 480.0},
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Factures'),
      ),
      body: ListView.builder(
        itemCount: factures.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(factures[index]['title']),
            subtitle: Text('Montant: ${factures[index]['amount']} €'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FactureDetailPage(facture: factures[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



class InvoiceDataSource extends DataGridSource {
  InvoiceDataSource(this.details, this.updateCell, this.removeRow) {
    buildDataGridRows();
  }

  List<Map<String, dynamic>> details;
  List<DataGridRow> dataGridRows = [];
  final Function(DataGridCell<dynamic>, dynamic) updateCell;
  final Function(int) removeRow;

  void buildDataGridRows() {
    dataGridRows = details.map<DataGridRow>((item) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'item', value: item['item']),
        DataGridCell<int>(columnName: 'quantity', value: item['quantity']),
        DataGridCell<double>(columnName: 'unitPrice', value: item['unitPrice']),
        DataGridCell<double>(columnName: 'total', value: item['total']),
        const DataGridCell<Icon>(columnName: 'delete', value: Icon(Icons.delete)),
      ]);
    }).toList();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == 'delete') {
        final index = dataGridRows.indexOf(row);
        return IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            removeRow(index);
          },
        );
      }
      return Container(
        alignment: (dataGridCell.columnName == 'quantity' || dataGridCell.columnName == 'unitPrice' || dataGridCell.columnName == 'total')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(dataGridCell.value.toString(), overflow: TextOverflow.ellipsis),
      );
    }).toList());
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    final cell = dataGridRow.getCells().firstWhere((DataGridCell cell) => cell.columnName == column.columnName);
    updateCell(cell, rowColumnIndex);
  }
}

class StatistiquesPage extends StatelessWidget {
  const StatistiquesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Statistiques', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 7,
                  minY: 0,
                  maxY: 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 5),
                        FlSpot(2, 4),
                        FlSpot(3, 7),
                        FlSpot(4, 8),
                        FlSpot(5, 6),
                        FlSpot(6, 9),
                      ],
                      isCurved: true,
                      colors: [Colors.blue],
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 2),
                        FlSpot(1, 4),
                        FlSpot(2, 5),
                        FlSpot(3, 6),
                        FlSpot(4, 7),
                        FlSpot(5, 5),
                        FlSpot(6, 8),
                      ],
                      isCurved: true,
                      colors: [Colors.red],
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 3),
                        FlSpot(2, 2),
                        FlSpot(3, 4),
                        FlSpot(4, 5),
                        FlSpot(5, 4),
                        FlSpot(6, 6),
                      ],
                      isCurved: true,
                      colors: [Colors.green],
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


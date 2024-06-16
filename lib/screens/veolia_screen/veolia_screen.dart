import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/userModel.dart';
import '../../widgets/_confirmLogout.dart';
import '../facture_screen/facture_screen.dart';
import '../planning_screen/planning_screen.dart';
import '../stats_screen/stats_screen.dart';


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
      home: const Veolia_info(),
    );
  }
}

class Veolia_info extends StatelessWidget {
  const Veolia_info({super.key});

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    _requestPermissions(); // Demande les permissions lors de l'ouverture de l'application
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 198, 222, 226),
        leading: const ConfirmLogout(),
        title: Center(
          child: Image.asset('lib/assets/icons/BinTech_Logo.jpg',
              height: 50, width: 50, fit: BoxFit.cover),
        ),
          actions: const [
            SizedBox(width: 57),
          ]
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
                      builder: (context) => FactureDetailPage(facture: {'details': [factures[index]]}),
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

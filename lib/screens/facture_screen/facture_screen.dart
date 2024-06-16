import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/factureModel.dart';
import '../../services/factureService.dart';
import '../veolia_screen/veolia_screen.dart';

class FactureDetailPage extends StatefulWidget {
  final Map<String, dynamic> facture;

  const FactureDetailPage({super.key, required this.facture});

  @override
  _FactureDetailPageState createState() => _FactureDetailPageState();
}

class _FactureDetailPageState extends State<FactureDetailPage> {
  late InvoiceDataSource _invoiceDataSource;
  List<Map<String, dynamic>> get details => widget.facture['details'];

  @override
  void initState() {
    super.initState();
    _invoiceDataSource = InvoiceDataSource(
      details,
      _updateCell,
      _removeRow,
    );
  }

  void _updateCell(DataGridCell<dynamic> cell, dynamic newValue) {
    final rowIndex = _invoiceDataSource.dataGridRows.indexWhere((row) => row.getCells().contains(cell));
    final columnIndex = _invoiceDataSource.dataGridRows[rowIndex].getCells().indexOf(cell);
    final String columnName = cell.columnName;

    setState(() {
      _invoiceDataSource.dataGridRows[rowIndex].getCells()[columnIndex] = DataGridCell<dynamic>(columnName: columnName, value: newValue);
      _invoiceDataSource.details[rowIndex][columnName] = newValue;
      if (columnName == 'quantity' || columnName == 'unitPrice') {
        final int quantity = _invoiceDataSource.details[rowIndex]['quantity'];
        final double unitPrice = _invoiceDataSource.details[rowIndex]['unitPrice'];
        _invoiceDataSource.details[rowIndex]['total'] = quantity * unitPrice;
        _invoiceDataSource.buildDataGridRows();
      }
    });
  }

  void _removeRow(int index) {
    setState(() {
      _invoiceDataSource.details.removeAt(index);
      _invoiceDataSource.buildDataGridRows();
    });
  }

  void _addRow() {
    setState(() {
      _invoiceDataSource.details.add({
        'item': '',
        'quantity': 0,
        'unitPrice': 0.0,
        'total': 0.0,
      });
      _invoiceDataSource.buildDataGridRows();
    });
  }

  Future<void> _exportToCSV() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      List<List<dynamic>> rows = [];
      rows.add(["Item", "Quantité", "Prix Unitaire", "Total"]);

      for (var detail in details) {
        List<dynamic> row = [];
        row.add(detail["item"]);
        row.add(detail["quantity"]);
        row.add(detail["unitPrice"]);
        row.add(detail["total"]);
        rows.add(row);
      }

      String csvData = const ListToCsvConverter().convert(rows);
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/facture.csv";
      final File file = File(path);
      await file.writeAsString(csvData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fichier CSV exporté: $path')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permission refusée')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Facture ${widget.facture['title']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Montant: ${widget.facture['amount']} €', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text('Détails:', style: TextStyle(fontSize: 20)),
            Expanded(
              child: SfDataGrid(
                source: _invoiceDataSource,
                allowEditing: true,
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'item',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Item', overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  GridColumn(
                    columnName: 'quantity',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Quantité', overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  GridColumn(
                    columnName: 'unitPrice',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Prix Unitaire', overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  GridColumn(
                    columnName: 'total',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Total', overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  GridColumn(
                    columnName: 'delete',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Supprimer', overflow: TextOverflow.ellipsis),
                    ),
                    allowEditing: false,
                    width: 100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addRow,
              child: const Text('Ajouter une ligne'),
            ),
            ElevatedButton(
              onPressed: _exportToCSV,
              child: const Text('Exporter en CSV'),
            ),
          ],
        ),
      ),
    );
  }
}


class FacturesPage extends StatelessWidget {
  const FacturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final factureServices = FactureServices();
    return FutureBuilder<List<Facture>>(
      future: factureServices.getAllFactures(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final factures = snapshot.data;
          return ListView.builder(
            itemCount: factures?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(factures?[index].title ?? ''),
                subtitle: Text('Montant: ${factures?[index].amount} €'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FactureDetailPage(facture: factures?[index].toMap() ?? {}),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
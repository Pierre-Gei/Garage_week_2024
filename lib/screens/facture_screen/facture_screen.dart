import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../models/factureModel.dart';
import '../../services/factureService.dart';

//classe de l'écran de détail de la facture
class FactureDetailPage extends StatefulWidget {
  final Map<String, dynamic> facture;

  const FactureDetailPage({super.key, required this.facture});

  @override
  _FactureDetailPageState createState() => _FactureDetailPageState();
}

class _FactureDetailPageState extends State<FactureDetailPage> {
  //source de données de la facture
  late InvoiceDataSource _invoiceDataSource;
  //détails de la facture
  List<Map<String, dynamic>> get details => widget.facture['details'];

  //initialisation de la source de données
  @override
  void initState() {
    super.initState();
    _invoiceDataSource = InvoiceDataSource(
      details,
      _updateCell,
      _removeRow,
    );
  }

  //mise à jour d'une cellule
  void _updateCell(DataGridCell<dynamic> cell, dynamic newValue) {
    final rowIndex = _invoiceDataSource.dataGridRows
        .indexWhere((row) => row.getCells().contains(cell));
    final columnIndex =
        _invoiceDataSource.dataGridRows[rowIndex].getCells().indexOf(cell);
    final String columnName = cell.columnName;

    setState(() {
      _invoiceDataSource.dataGridRows[rowIndex].getCells()[columnIndex] =
          DataGridCell<dynamic>(columnName: columnName, value: newValue);
      _invoiceDataSource.details[rowIndex][columnName] = newValue;
      if (columnName == 'quantity' || columnName == 'unitPrice') {
        final double quantity = _invoiceDataSource.details[rowIndex]['quantity'].toDouble();
        final double unitPrice =
            _invoiceDataSource.details[rowIndex]['unitPrice'].toDouble();
        _invoiceDataSource.details[rowIndex]['total'] = quantity * unitPrice;
        _invoiceDataSource.buildDataGridRows();
      }
    });
  }

  //suppression d'une ligne
  void _removeRow(int index) {
    setState(() {
      _invoiceDataSource.details.removeAt(index);
      _invoiceDataSource.buildDataGridRows();
    });
  }

  //ajout d'une ligne
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

  //exportation de la facture au format CSV INUTILISÉ
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

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fichier CSV exporté: $path')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Permission refusée')));
    }
  }

  //affichage de l'écran
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
            Text('Montant: ${widget.facture['amount']} €',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text('Détails:', style: TextStyle(fontSize: 20)),
            Expanded(
              child: SfDataGrid(
                navigationMode: GridNavigationMode.cell,
                source: _invoiceDataSource,
                allowEditing: true,
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'item',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child:
                          const Text('Item', overflow: TextOverflow.ellipsis),
                    ),
                    allowEditing: true,
                  ),
                  GridColumn(
                    columnName: 'quantity',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Quantité',
                          overflow: TextOverflow.ellipsis),
                    ),
                    allowEditing: true,
                  ),
                  GridColumn(
                    columnName: 'unitPrice',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Prix Unitaire',
                          overflow: TextOverflow.ellipsis),
                    ),
                    allowEditing: true,
                  ),
                  GridColumn(
                    columnName: 'total',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child:
                          const Text('Total', overflow: TextOverflow.ellipsis),
                    ),
                    allowEditing: true,
                  ),
                  GridColumn(
                    columnName: 'delete',
                    label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Supprimer',
                          overflow: TextOverflow.ellipsis),
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
          ],
        ),
      ),
    );
  }
}

//classe de l'écran des factures
class FacturesPage extends StatelessWidget {
  const FacturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final factureServices = FactureServices();
    return FutureBuilder<List<Facture>>(
      future: factureServices.getAllFactures(),
      builder: (context, snapshot) {
        AppBar appBar = AppBar(
          title: const Text('Factures'),
          backgroundColor: const Color.fromARGB(255, 198, 222, 226),
        );
        Widget body;
        if (snapshot.connectionState == ConnectionState.waiting) {
          body = const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          body = Text('Error: ${snapshot.error}');
        } else {
          final factures = snapshot.data;
          if (factures == null || factures.isEmpty) {
            body = const Text('Aucune facture trouvée');
          } else {
            body = ListView.builder(
              itemCount: factures.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(factures[index].title ?? ''),
                  subtitle: Text('Montant: ${factures[index].amount} €'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FactureDetailPage(
                            facture: factures[index].toMap() ?? {}),
                      ),
                    );
                  },
                );
              },
            );
          }
        }

        Scaffold scaffold = Scaffold(
          appBar: appBar,
          body: body,
        );
        return scaffold;
      },
    );
  }
}

//source de données de la facture
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
    //Notifie le DataGrid de la mise à jour des lignes
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
    final newValue = cell.value;
    handleCellSubmit(dataGridRow, column.columnName, newValue);
  }

  void handleCellSubmit(DataGridRow row, String columnName, dynamic newValue) {
    updateCell(row.getCells().firstWhere((cell) => cell.columnName == columnName), newValue);
  }
}

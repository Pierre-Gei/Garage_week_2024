import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:time_planner/time_planner.dart';

import '../../models/userModel.dart';

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

class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  _PlanningPageState createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  List<TimePlannerTask> tasks = [
    TimePlannerTask(
      color: Colors.purple,
      dateTime: TimePlannerDateTime(day: 0, hour: 14, minutes: 30),
      minutesDuration: 90,
      daysDuration: 1,
      onTap: () {},
      child: Text(
        'this is a task',
        style: TextStyle(color: Colors.grey[350], fontSize: 12),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Planning', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Expanded(
              child: TimePlanner(
                startHour: 0,
                endHour: 23,
                headers: [
                  TimePlannerTitle(
                    title: "Lundi",
                    date: "10/06/2024",
                  ),
                  TimePlannerTitle(
                    title: "Mardi",
                    date: "11/06/2024",
                  ),
                  TimePlannerTitle(
                    title: "Mercredi",
                    date: "12/06/2024",
                  ),
                  TimePlannerTitle(
                    title: "Jeudi",
                    date: "13/06/2024",
                  ),
                  TimePlannerTitle(
                      title: "Vendredi",
                      date: "14/06/2024"),
                  TimePlannerTitle(
                    title: "Samedi",
                    date: "15/06/2024",
                  ),
                  TimePlannerTitle(
                    title: "Dimanche",
                    date: "16/06/2024",
                  ),
                ],
                tasks: tasks,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../globals.dart';
import '../../models/benneModel.dart';
import '../../models/entrepriseModel.dart';
import '../../models/userModel.dart';
import '../../services/entrepriseServices.dart';
import '../../widgets/_confirmLogout.dart';
import '../BT_device_connect_screen/bt_device_connect_screen.dart';

class ClientScreen extends StatelessWidget {
  final User user;
  static const routeName = '/clientScreen';
  ClientScreen({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Select Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: ClientInfo(user),
    );
  }
}

class ClientInfo extends StatefulWidget {
  final User user;
  ClientInfo(this.user, {Key? key}) : super(key: key);

  @override
  _ClientInfoState createState() => _ClientInfoState();
}

class _ClientInfoState extends State<ClientInfo> {
  ValueNotifier<Future<Entreprise>>? entrepriseFutureNotifier;

  @override
  void initState() {
    super.initState();
    binUpdateNotifier.addListener(_updateBinData);
    entrepriseFutureNotifier = ValueNotifier(
        EntrepriseServices().getEntrepriseById(widget.user.entrepriseId));
    binUpdateNotifier.addListener(_updateBinData);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    binUpdateNotifier.removeListener(_updateBinData);
    super.dispose();
  }

  Future<void> _updateBinData() async {
    // Get the updated bin
    Benne? updatedBin = binUpdateNotifier.value;
    if (updatedBin != null) {
      // Find the index of the bin in the list
      Entreprise entreprise = await EntrepriseServices()
          .getEntrepriseById(widget.user.entrepriseId);
      int index =
          entreprise.listBenne.indexWhere((bin) => bin.id == updatedBin.id);
      if (index != -1) {
        // Update the bin in the list
        setState(() {
          entreprise.listBenne[index] = updatedBin;
        });
      }
    }
  }

  DateTime nextSelectableDate() {
    DateTime now = DateTime.now();
    if (now.weekday == 6) {
      // If it's Saturday, return Monday's date
      return now.add(Duration(days: 2));
    } else if (now.weekday == 7) {
      // If it's Sunday, return Monday's date
      return now.add(Duration(days: 1));
    } else {
      // If it's a weekday, return the current date
      return now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Benne?>(
        valueListenable: binUpdateNotifier,
        builder: (context, value, child) {
          return FutureBuilder<Entreprise>(
            future: EntrepriseServices().getEntrepriseById(widget.user.entrepriseId),
            builder: (BuildContext context, AsyncSnapshot<Entreprise> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final Entreprise entreprise = snapshot.data!;
                final List<Benne> Bennes = entreprise.listBenne;
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 198, 222, 226),
                    leading: const ConfirmLogout(),
                    title: Center(
                      child: Image.asset('lib/assets/icons/BinTech_Logo.jpg',
                          height: 50, width: 50, fit: BoxFit.cover),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.bluetooth),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BtDeviceConnectScreen(entreprise: entreprise),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue ${entreprise.nom} !',
                          style: TextStyle(fontSize: 25),
                        ),
                        const Text('Mes bennes : ',
                            style: TextStyle(fontSize: 25)),
                        Expanded(
                          child: Bennes.isEmpty
                              ? const Center(
                                  child: Text('Aucune benne',
                                      style: TextStyle(fontSize: 20)),
                                )
                              : ListView(
                                  children: Bennes.map((benne) {
                                    return InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          showDragHandle: true,
                                          builder: (context) {
                                            return LayoutBuilder(
                                              builder: (BuildContext context,
                                                  BoxConstraints constraints) {
                                                return Container(
                                                  width: constraints.maxWidth,
                                                  padding: EdgeInsets.all(16),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                          'Benne ID: ${benne.id}'),
                                                      Text(
                                                          'Type: ${benne.type}'),
                                                      Text(
                                                          'Emplacement: ${benne.location}'),
                                                      Text(
                                                          'Taux de remplssage: ${(benne.fullness * 100).toStringAsFixed(1)}%'),
                                                      Text(
                                                          'Client: ${benne.client}'),
                                                      Text(
                                                          'Vidage prévu: ${benne.emptying ? 'Oui' : 'Non'}'),
                                                      ElevatedButton(
                                                        child: Text(
                                                            'Demander le vidage'),
                                                        onPressed:
                                                            benne.emptying
                                                                ? null
                                                                : () async {
                                                                    // Display the date picker dialog
                                                                    final DateTime?
                                                                        pickedDate =
                                                                        await showDatePicker(
                                                                      context:
                                                                          context,
                                                                      initialDate:
                                                                          nextSelectableDate(),
                                                                      firstDate: DateTime
                                                                              .now()
                                                                          .add(const Duration(
                                                                              days: 1)),
                                                                      lastDate:
                                                                          DateTime(
                                                                              2100),
                                                                      selectableDayPredicate: (DateTime val) => val.weekday == 6 ||
                                                                              val.weekday == 7
                                                                          ? false
                                                                          : true,
                                                                    );

                                                                    if (pickedDate !=
                                                                        null) {
                                                                      // Update the state with the new date
                                                                      setState(
                                                                          () {
                                                                        benne.emptyingDate =
                                                                            pickedDate;
                                                                        benne.emptying =
                                                                            true;
                                                                      });

                                                                      // Call a function to update the database
                                                                      await EntrepriseServices()
                                                                          .updateBenneFromEntreprise(
                                                                        entreprise
                                                                            .id,
                                                                        benne,
                                                                      );
                                                                      entrepriseFutureNotifier!
                                                                              .value =
                                                                          EntrepriseServices().getEntrepriseById(widget
                                                                              .user
                                                                              .entrepriseId);
                                                                    }
                                                                  },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                  'Benne n°${benne.id}, ${benne.type} à ${benne.location}'),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  LinearProgressIndicator(
                                                    value: benne.fullness,
                                                    minHeight: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    backgroundColor:
                                                        Colors.grey,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.green),
                                                  ),
                                                  Text(
                                                    '${(benne.fullness * 100).toStringAsFixed(1)}%',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              if (benne.emptying)
                                                Text(
                                                    'Vidage prévu le ${benne.emptyingDate!.day}/${benne.emptyingDate!.month}/${benne.emptyingDate!.year}'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        });
  }
}

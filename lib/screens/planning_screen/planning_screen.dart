import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_planner/time_planner.dart';

import '../../models/benneModel.dart';
import '../../services/entrepriseServices.dart';

//classe de l'écran de la planification
class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  //liste des tâches
  List<TimePlannerTask> tasks = [];

  //chargement des données
  @override
  void initState() {
    super.initState();
    LoadData().fetchData().then((bins) {
      //création des tâches pour chaque benne
      for (var bin in bins) {
        var newTask = TimePlannerTask(
          color: Colors.blue,
          minutesDuration: 60,
          daysDuration: 1,
          dateTime: TimePlannerDateTime(
            //calcul de la date de la tâche en fonction de la date de vidage de la benne
            day: bin.emptyingDate!.difference(DateTime.now()).inDays + 1,
            hour: bin.emptyingDate!.hour.toInt(),
            minutes: 0,
          ),
          child: Text('benne-${bin.id} à ${bin.location}'),
        );
        //Evite les tâches qui commencent avant 8h
        if (newTask.dateTime.hour < 8) {
          newTask.dateTime.hour = 8;
        }
        if (newTask.dateTime.hour > 20) {
          newTask.dateTime.day += 1;
          newTask.dateTime.hour = 8;
        }
        //Evite les tâches qui se chevauchent
        if (!doesTaskOverlap(newTask)) {
          tasks.add(newTask);
        } else {
          while (doesTaskOverlap(newTask)) {
            newTask.dateTime.hour += 1;
            if (newTask.dateTime.hour > 20) {
              newTask.dateTime.day += 1;
              newTask.dateTime.hour = 8;
            }
          }
          tasks.add(newTask);
        }
      }
      //rafraîchissement de l'écran
      setState(() {});
    });
  }

  //vérifie si une tâche se chevauche
  bool doesTaskOverlap(TimePlannerTask newTask) {
    for (var task in tasks) {
      if (task.dateTime.day == newTask.dateTime.day) {
        var taskEndHour = task.dateTime.hour + task.minutesDuration ~/ 60;
        var newTaskEndHour = newTask.dateTime.hour + newTask.minutesDuration ~/ 60;

        if ((newTask.dateTime.hour >= task.dateTime.hour && newTask.dateTime.hour < taskEndHour) ||
            (newTaskEndHour > task.dateTime.hour && newTaskEndHour <= taskEndHour)) {
          return true;
        }
      }
    }
    return false;
  }

  //affichage de l'écran
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
        backgroundColor: const Color.fromARGB(255, 198, 222, 226),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: TimePlanner(
                startHour: 6,
                endHour: 20,
                use24HourFormat: true,
                setTimeOnAxis: false,
                headers: [
                  TimePlannerTitle(
                    title: DateFormat('dd-MM-yy').format(DateTime.now()),
                  ),
                  TimePlannerTitle(
                    title: DateFormat('dd-MM-yy')
                        .format(DateTime.now().add(const Duration(days: 1))),
                  ),
                  TimePlannerTitle(
                    title: DateFormat('dd-MM-yy')
                        .format(DateTime.now().add(const Duration(days: 2))),
                  ),
                  TimePlannerTitle(
                    title: DateFormat('dd-MM-yy')
                        .format(DateTime.now().add(const Duration(days: 3))),
                  ),
                  TimePlannerTitle(
                    title: DateFormat('dd-MM-yy')
                        .format(DateTime.now().add(const Duration(days: 4))),
                  ),
                  TimePlannerTitle(
                    title: DateFormat('dd-MM-yy')
                        .format(DateTime.now().add(const Duration(days: 5))),
                  ),
                  TimePlannerTitle(
                    title: DateFormat('dd-MM-yy')
                        .format(DateTime.now().add(const Duration(days: 6))),
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

class LoadData {
  Future<List<Benne>> fetchData() async {
    List<Benne>? fetchedBins = await EntrepriseServices().getAllBenne();
    return fetchedBins.where((bin) => bin.emptyingDate != null).toList();
  }
}
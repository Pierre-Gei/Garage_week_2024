import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_planner/time_planner.dart';

import '../../models/benneModel.dart';
import '../../services/entrepriseServices.dart';

class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  List<TimePlannerTask> tasks = [];

  @override
  void initState() {
    super.initState();
    LoadData().fetchData().then((bins) {
      for (var bin in bins) {
        var newTask = TimePlannerTask(
          color: Colors.blue,
          minutesDuration: 60,
          daysDuration: 1,
          dateTime: TimePlannerDateTime(
            day: bin.emptyingDate!.difference(DateTime.now()).inDays,
            hour: bin.emptyingDate!.hour.toInt(),
            minutes: 0,
          ),
          child: Text('benne-${bin.id} à ${bin.location}'),
        );

        if (newTask.dateTime.hour < 8) {
          newTask.dateTime.hour = 8;
        }

        if (!doesTaskOverlap(newTask)) {
          tasks.add(newTask);
        }
      }
      setState(() {}); // Notify the framework that the internal state of this object has changed.
    });
  }

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
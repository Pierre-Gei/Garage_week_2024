import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

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
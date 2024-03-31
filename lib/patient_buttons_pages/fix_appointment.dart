import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:doc_patient/server_firebase_operations/appointment_operation.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class FixAppointment extends StatefulWidget {
  const FixAppointment({super.key, required this.json});

  final Map<String, dynamic> json;

  @override
  State<FixAppointment> createState() => _FixAppointmentState();
}
class _FixAppointmentState extends State<FixAppointment> {
  List<DateTime?> _date = [
    DateTime.now(),
  ];
  Time _time = Time(hour: 10, minute: 30, second: 20);
  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                headerComponent(context),
                space(20),
                titleRegistration("Client Support"),
                space(40),
                Text(
                  "${widget.json['data']['name']}",
                  style: TextStyle(fontSize: 25),
                ),
                // Text(
                //   "${widget.json['department']}",
                //   style: TextStyle(fontSize: 18, color: Colors.grey),
                // ),
                // Text(
                //   "${widget.json['hospitalName']}",
                //   style: TextStyle(fontSize: 18, color: Colors.grey),
                // ),
                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(),
                  value: _date,
                  onValueChanged: (date) {
                    setState(() {
                      _date = date;
                    });

                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      showPicker(
                        context: context,
                        value: _time,
                        sunrise: TimeOfDay(hour: 6, minute: 0),
                        elevation: 1,
                        minHour: 8,
                        maxHour: 17,
                        // optional
                        sunset: TimeOfDay(hour: 18, minute: 0),
                        duskSpanInMinutes: 120,
                        // optional
                        onChange: onTimeChanged,
                      ),
                    );
                  },
                  child: Text(
                    "Select Time",
                    // style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("date: ${dateRender2(_date[0].toString())}"),
                      Text("Time: ${timeRender2(DateTime(2022, 2, 2, _time.hour, _time.minute).toString())} "),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: ElevatedButton(
                    child: Text("Confirm Request"),
                    onPressed: () {
                      var date = DateTime(_date[0]!.year, _date[0]!.month,
                          _date[0]!.day, _time.hour, _time.minute);
                      createAppointment(widget.json['data']['userID'], widget.json['data']['name'],date.toString()).then((value) {
                        Dialogs.bottomMaterialDialog(
                            msg: '${value['message']}',
                            title: '',
                            context: context,
                            color: Colors.deepPurple,
                            actions: [

                              IconsButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                text: 'Okay',
                                iconData: Icons.check,
                                color: Colors.blue,
                                textStyle: TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                            ]);
                      });

                    },
                  ),
                ),
                space(20)
              ],
            )
          ],
        ),
      ),
    );
  }
}

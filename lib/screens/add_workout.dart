import 'package:fitness_firestore/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fitness_firestore/components/common/save_button.dart';
import 'package:fitness_firestore/components/common/toast.dart';
import 'package:fitness_firestore/core/constants.dart';
import 'package:fitness_firestore/domain/workout.dart';
import 'package:fitness_firestore/screens/add_workout_week.dart';

class AddWorkout extends StatefulWidget {
  final WorkoutSchedule? workoutSchedule;

  AddWorkout({Key? key, this.workoutSchedule}) : super(key: key);

  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final _fbKey = GlobalKey<FormBuilderState>();

  WorkoutSchedule workout = WorkoutSchedule(weeks: []);

  @override
  void initState() {
    if (widget.workoutSchedule != null)
      workout = widget.workoutSchedule!.copy();
   // workout.level ??= 'Beginner';

    super.initState();
  }

  void _saveWorkout() async {
    if (_fbKey.currentState!.saveAndValidate()) {
      if (workout.weeks == null || workout.weeks!.length == 0) {
        buildToast('Please add at least one training week');
        return;
      }

      await DatabaseService().addOrUpdateWorkout(workout);
      Navigator.of(context).pop(/*workout*/);
      // print('=======================================================');
      // print('uid : ${workout.uid}, title : ${workout.title}, weeks: ${workout.weeks!.length}'  );
    } else {
      buildToast('Ooops! Something is not right');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MaxFit // Create Workout'),
          actions: <Widget>[SaveButton(onPressed: _saveWorkout)],
        ),
        body: Container(                          //TODO add scrollView
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: bgColorWhite),
          child: Column(
            children: <Widget>[
              FormBuilder(
                // context,
                key: _fbKey,
                autovalidateMode: AutovalidateMode.disabled,
                initialValue: {},
                enabled: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      name: "title",
                      // enabled: false,
                      decoration: InputDecoration(
                        labelText: "Title*",
                      ),
                      onChanged: (dynamic val) {
                        setState(() {
                          workout.title = val;
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.maxLength(context, 100),
                      ]),
                    ),
                    FormBuilderDropdown(
                      onChanged: (dynamic val) {
                        setState(() {
                          workout.level = val;
                        });
                      },
                      name: "level",
                      decoration: InputDecoration(
                        labelText: "Level*",
                      ),
                      initialValue: 'Beginner',
                      allowClear: false,
                      hint: Text('Select Level'),
                      validator: FormBuilderValidators.required(context),
                      // was [FormBuilderValidators.required()],
                      items: <String>['Beginner', 'Intermediate', 'Advanced']
                          .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text('$level'),
                              ))
                          .toList(),
                    ),
                    FormBuilderTextField(
                      name: "description",
                      decoration: InputDecoration(
                        labelText: "Description*",
                      ),
                      onChanged: (dynamic val) {
                        setState(() {
                          workout.description = val;
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.maxLength(context, 500),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Weeks',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  FlatButton(
                    child: Icon(Icons.add),
                    onPressed: () async {
                      var week = await Navigator.push<WorkoutWeek>(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => AddWorkoutWeek()));
                      if (week != null)
                        setState(() {
                          workout.weeks!.add(week);
                        });
                    },
                  )
                ],
              ),
              workout.weeks!.length <= 0
                  ? Text(
                      'Please add at least one training week',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )
                  : _buildWeeks()
            ],
          ),
        ));
  }

  Widget _buildWeeks() {
    return Expanded(
        //padding: EdgeInsets.all(5),
        child: Column(
            children: workout.weeks!
                .map((week) => Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: InkWell(
                        onTap: () async {
                          var ind = workout.weeks!.indexOf(week);

                          var modifiedWeek = await Navigator.push<WorkoutWeek>(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      AddWorkoutWeek(week: week)));
                          if (modifiedWeek != null) {
                            setState(() {
                              workout.weeks![ind] = modifiedWeek;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(50, 65, 85, 0.9)),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 1, color: Colors.white24))),
                            ),
                            title: Text(
                                'Week ${workout.weeks!.indexOf(week) + 1} - ${week.daysWithDrills} Training Days',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .title!
                                        .color,
                                    fontWeight: FontWeight.bold)),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color:
                                    Theme.of(context).textTheme.title!.color),
                          ),
                        ),
                      ),
                    ))
                .toList()));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fitness_firestore/domain/workout.dart';

class Drill extends StatelessWidget {
  final bool isSingleDrill;
  final int? drillBlockIndex;
  final int? index;
  final WorkoutDrill? drill;

  Drill(
      {Key? key,
      this.drillBlockIndex,
      this.index,
      required this.isSingleDrill,
      this.drill})
      : super(key: key);

  isNumeric(string) =>
      string != null && int.tryParse(string.toString().trim()) != null;

  cleanInt(string) => int.parse(string.toString().trim());

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 4, right: 4),
        decoration: BoxDecoration(color: Colors.white54),
        child: Column(
          children: <Widget>[
            FormBuilderTextField(
              initialValue: drill!.title,
              name: "title_${drillBlockIndex}_$index",//was 'attribute'
              decoration: InputDecoration(
                labelText: isSingleDrill ? "Drill *" : "Drill #${index! + 1} *",
              ),
              onChanged: (dynamic val) {
                drill!.title = val;
              },
              validator: FormBuilderValidators.compose(//was simply [], without  'FormBuilderValidators.compose'
                [
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.maxLength(context, 100),
                ],
              ),
            ),
            FormBuilderTextField(
              initialValue: drill!.sets == null ? '' : drill!.sets.toString(),
              name: "sets_${drillBlockIndex}_$index",
              decoration: InputDecoration(
                labelText: isSingleDrill ? "Sets *" : "Sets #${index! + 1} *",
              ),
              onChanged: (dynamic val) {
                if (isNumeric(val)) drill!.sets = cleanInt(val);
              },
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.max(context, 100),
                FormBuilderValidators.numeric(context),
              ]),
              keyboardType: TextInputType.number,
            ),
            FormBuilderTextField(
              initialValue: drill!.reps == null ? '' : drill!.reps.toString(),
              name: "reps_${drillBlockIndex}_$index",
              decoration: InputDecoration(
                labelText: isSingleDrill ? "Reps *" : "Reps #${index! + 1} *",
              ),
              onChanged: (dynamic val) {
                if (isNumeric(val)) drill!.reps = cleanInt(val);
              },
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.max(context, 500),
                FormBuilderValidators.numeric(context),
              ]),
              keyboardType: TextInputType.number,
            ),
            FormBuilderTextField(
              initialValue: drill!.weight,
              name: "weight_${drillBlockIndex}_$index",
              decoration: InputDecoration(
                labelText: isSingleDrill ? "Weight" : "Weight #${index! + 1}",
              ),
              onChanged: (dynamic val) {
                drill!.weight = val;
              },
              validator: FormBuilderValidators.maxLength(context,100),
            ),
          ],
        ),
      ),
    );
  }
}

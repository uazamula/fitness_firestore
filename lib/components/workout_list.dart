import 'package:fitness_firestore/domain/workout.dart';
import 'package:flutter/material.dart';

class WorkoutsList extends StatefulWidget {
  @override
  _WorkoutsListState createState() => _WorkoutsListState();
}

class _WorkoutsListState extends State<WorkoutsList> {
  final List workouts = <Workout>[
    Workout(
        title: 'test1', author: 'Max', level: 'beginner', description: 'cool'),
    Workout(title: 'test2', author: 'Bob'),
  ];

  var filterOnlyMyWorkouts = false;

  var filterTitle = '';

  var filterTitleController = TextEditingController();

  var filterLevel = 'Any level';

  var filterText = '';

  var filterHeight = 0.0;

  List filter(){
    setState(() {
      filterText = filterOnlyMyWorkouts?'My Workouts' : 'All workouts';
      filterText+='/' + filterLevel;
      print(filterTitle);
      if(filterTitle.isNotEmpty) filterText+='/'+filterTitle;
      filterHeight=0;
    });

    var list = workouts;
    return list;
  }

  List clearFilter(){
    setState(() {
      filterText = 'All Workouts/ Any levels';
      filterOnlyMyWorkouts = false;
      filterTitle+='';
      filterLevel = 'Any level';
      filterTitleController.clear();
      filterHeight=0;
    });

    var list = workouts;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var filterInfo = Expanded(
      child: Container(
        //FilterInfo(workouts: workouts),
        margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
        height: 40,
        child: TextButton(
          child: Row(
            children: [
              Icon(Icons.filter_list),
              Text(
                filterText,
                style: TextStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          onPressed: () {
            setState(() {
              filterHeight = (filterHeight == 0.0 ? 280.0 : 0.0);
            });
          },
        ),
      ),
    );

    var levelMenuItems = ['Any Level', 'Beginner', 'Intermediate', 'Advanced']
        .map((String value) {
      return new DropdownMenuItem<String>(value: value, child: new Text(value));
    }).toList();

    var filterForm = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Only my Workouts'),
                value: filterOnlyMyWorkouts,
                onChanged: (bool val) {
                  setState(() {
                    filterOnlyMyWorkouts = val;
                  });
                },
              ),
             /* DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Level'),
                items: levelMenuItems,
                value: filterLevel,
                onChanged: (String? val) => setState(() => filterLevel = val!),
              ),*/
              TextFormField(
                controller: filterTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (String? val) => setState(() => filterTitle = val!),
              ),
              Row(children: [
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    onPressed: () {
                      filter();
                    },
                    child: Text('Apply', style: TextStyle(color: Colors.white)),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(flex: 1, child: RaisedButton(
                  onPressed: (){
                    clearFilter();
                  },
                  child: Text('Clear', style: TextStyle(color:Colors.white)),
                  color: Colors.red,
                ))
              ])
            ],
          ),
        ),
      ),
      duration: Duration(milliseconds: 500),
    );

    return Column(
      children: [
        filterInfo,
        /*Expanded(
          child: FilterForm(workouts: workouts),
        ),*/
        filterForm,
        Expanded(
          child: MyWorkoutsList(workouts: workouts),
        ),
      ],
    );
  }
}

class MyWorkoutsList extends StatefulWidget {
  const MyWorkoutsList({
    Key? key,
    required this.workouts,
  }) : super(key: key);

  final List workouts;

  @override
  _MyWorkoutsListState createState() => _MyWorkoutsListState();
}

class _MyWorkoutsListState extends State<MyWorkoutsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: widget.workouts.length,
        itemBuilder: (context, i) {
          //if (workouts[i].level==null)
          widget.workouts[i].title ??= "unknown";
          widget.workouts[i].title ??= "unknown";

          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              decoration: BoxDecoration(color: Colors.black45),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                leading: Container(
                  padding: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 1, color: Colors.white24),
                    ),
                  ),
                  child: Icon(Icons.fitness_center,
                      color: Theme.of(context).textTheme.headline6!.color),
                ),
                title: Text(widget.workouts[i].title,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline6!.color,
                        fontWeight: FontWeight.bold)),
                trailing: Icon(Icons.arrow_forward_ios,
                    color: Theme.of(context).textTheme.headline6!.color),
                subtitle: subtitle(context, widget.workouts[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}

//TODO move it to class or even build method?
Widget subtitle(BuildContext context, Workout workout) {
  var color = Colors.grey;
  double indicatorlevel = 0;
  String? description = workout.description;
  String? level = workout.level;
  description ??= '';
  level ??= 'unknown';
  switch (workout.level) {
    case 'beginner':
      color = Colors.green;
      indicatorlevel = 0.33;
      break;
    case 'intermediate':
      color = Colors.yellow;
      indicatorlevel = 0.67;
      break;
    case 'advanced':
      color = Colors.red;
      indicatorlevel = 1.0;
      break;
  }
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: LinearProgressIndicator(
          backgroundColor: Theme.of(context).textTheme.headline6!.color,
          value: indicatorlevel,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        flex: 3,
        child: Text(level,
            style:
                TextStyle(color: Theme.of(context).textTheme.headline6!.color)),
      )
    ],
  );
}

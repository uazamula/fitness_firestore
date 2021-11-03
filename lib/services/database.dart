import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_firestore/domain/workout.dart';
//https://stackoverflow.com/questions/67570502/flutter-type-documentsnapshotmyobject-myobject-is-not-a-subtype-of-typ

class DatabaseService{
  final CollectionReference _workoutCollection = FirebaseFirestore.instance.collection('myWorkouts');
  final CollectionReference _workoutSchedulesCollection = FirebaseFirestore.instance.collection('myWorkoutSchedules');

  Future addOrUpdateWorkout(WorkoutSchedule schedule) async{
    DocumentReference workoutRef = _workoutCollection.doc(schedule.uid);
    return workoutRef.set(schedule.toWorkoutMap()).then((_) async{
      var docId = workoutRef.id;
      await _workoutSchedulesCollection.doc(schedule.uid).set(schedule.toMap());
    });
   // return await
  }

  Stream<List<Workout>> getWorkouts({String? level, String? author})
  {
    Query query;
    if(author != null)
      query = _workoutCollection.where('author', isEqualTo: author);
    else
      query = _workoutCollection.where('isOnline', isEqualTo: true);

    if(level != null)
      query = query.where('level', isEqualTo: level);

    return query.snapshots().map((QuerySnapshot data) =>
        data.docs.map((DocumentSnapshot doc) => Workout.fromJson(doc.id, doc.data() as Map<String,dynamic>)).toList());//TODO was doc.data
  }

  Future<WorkoutSchedule> getWorkout(String? id) async{
    var doc = await _workoutSchedulesCollection.doc(id).get();
    return WorkoutSchedule.fromJson(doc.id, _workoutSchedulesCollection.parameters);
  }
}
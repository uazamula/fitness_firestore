class Workout {
  String? uid;
  String? title;
  String? author;
  String? description;
  String? level;
  bool? isOnline;

  Workout({
    this.uid,
    this.title,
    this.author,
    this.description,
    this.level,
  });
  Workout.fromJson(String uid, Map<String,dynamic> data){
    this.uid = uid;
    title = data['title'];
    author = data['author'];
    description = data['description'];
    level = data['level'];


  }
}

class WorkoutSchedule {
  String? uid;
  late String title;
  String? author;
  late String description;
  String? level;
  List<WorkoutWeek>? weeks;

  WorkoutSchedule({this.weeks});

  WorkoutSchedule copy() {
    List<WorkoutWeek>? copiedWeeks =
        weeks!.map((w) => w.copy()).cast<WorkoutWeek>().toList();
    return WorkoutSchedule(weeks: copiedWeeks);
  }
  Map<String,dynamic> toMap(){
    return {
      'title': title,
      'description': description,
      'level': level,
      'author': author,
      'weeks': weeks!.map((w)=>w.toMap()).toList()
    };
  }

  Map<String,dynamic> toWorkoutMap(){
    return {
      'title': title,
      'description': description,
      'level': level,
      'author': author,
      'isOnline': true,
      'createdOn': DateTime.now().millisecondsSinceEpoch
    };
  }

  WorkoutSchedule.fromJson(String uid, Map<String, dynamic> data) {
    this.uid = uid;
    title = data['title'];
    author = data['author'];
    description = data['description'];
    level = data['level'];

    weeks = (data['weeks'] as List).map((w) => WorkoutWeek.fromJson(w)).cast<WorkoutWeek>().toList();
  }
}

class WorkoutWeek {
  late String notes;
  List<WorkoutWeekDay>? days;

  WorkoutWeek({this.days, required this.notes});

  WorkoutWeek copy() {
    var copiedDays = days!.map((w) => w.copy()).cast<WorkoutWeekDay>().toList();
    return WorkoutWeek(days: copiedDays, notes: notes);
  }

  int get daysWithDrills =>
      days != null ? days!.where((d) => d.isSet).length : 0;

  Map<String, dynamic> toMap() {
    return {
      'notes': notes,
      'days': days!.map((w)=>w.toMap()).toList()
      //TODO #6  9:50
    };
  }

  WorkoutWeek.fromJson(Map<String, dynamic> value) {
    notes = value['notes'];
    days =
        (value['days'] as List).map((w) => WorkoutWeekDay.fromJson(w)).cast<WorkoutWeekDay>().toList();
  }
}
class WorkoutWeekDay {
  late String notes;
  late List<WorkoutDrillsBlock> drillBlocks;

  bool get isSet => drillBlocks != null && drillBlocks.length > 0;
  int get notRestDrillBlocksCount => isSet? drillBlocks.where((b) => !(b is WorkoutRestDrillBlock)).length:0;
  int getNotRestDrillBlockIndex(WorkoutDrillsBlock block) => isSet
      ?  (drillBlocks.where((b) => !(b is WorkoutRestDrillBlock)).toList().indexOf(block))
      : -1;

  WorkoutWeekDay({required this.notes, required this.drillBlocks});

  WorkoutWeekDay copy() {
    var copiedBlocks = drillBlocks.map((w) => w.copy()).cast<WorkoutDrillsBlock>().toList();
    return WorkoutWeekDay(drillBlocks: copiedBlocks, notes: notes);
  }

  Map<String,dynamic> toMap() {
    return{
      'notes': notes,
      'drillBlocks': drillBlocks.map((w) => w.toMap()).toList()
    };
  }

  WorkoutWeekDay.fromJson(Map<String, dynamic> value) {
    notes = value['notes'];
    drillBlocks = (value['drillBlocks'] as List).map((w) => WorkoutDrillsBlock.fromJson(w)).cast<WorkoutDrillsBlock>().toList();
  }
}
class WorkoutDrill {
  String? title;
  String? weight;
  int? sets;
  int? reps;

  WorkoutDrill({this.title, this.weight, this.sets, this.reps});

  WorkoutDrill copy(){
    return WorkoutDrill(title: title, weight: weight, sets: sets, reps: reps);
  }

  WorkoutDrill.fromJson(Map<String, dynamic> value) {
    title = value['title'];
    weight = value['weight'];
    sets = value['sets'];
    reps = value['reps'];
  }

  Map<String,dynamic> toMap() {
    return{
      'title': title,
      'weight': weight,
      'sets': sets,
      'reps': reps
    };
  }
}

enum WorkoutDrillType{
  SINGLE,
  MULTISET,
  AMRAP,
  ForTime,
  EMOM,
  REST
  //TABATA
}

abstract class WorkoutDrillsBlock{
  WorkoutDrillType? type;
  List<WorkoutDrill>? drills;

  WorkoutDrillsBlock({this.type, this.drills});

  void changeDrillsCount(int count) {
    var diff = count - drills!.length;

    if(diff == 0) return;

    if(diff > 0){
      for(int i = 0; i<diff; i++){
        drills!.add(WorkoutDrill());
      }
    }else{
      drills = drills!.sublist(0, drills!.length+diff);
    }
  }

  WorkoutDrillsBlock copy();

  factory WorkoutDrillsBlock.fromJson(Map<String, dynamic> value) {
    var type = value['type'];
    var drills = ((value['drills'] ?? List) as List)
        .map((d) => WorkoutDrill.fromJson(d))
        .toList();

    WorkoutDrillsBlock block;
    WorkoutDrillType drillType =
    WorkoutDrillType.values.firstWhere((e) => e.toString() == type);
    switch (drillType) {
      case WorkoutDrillType.AMRAP:
        block =
            WorkoutAmrapDrillBlock(drills: drills, minutes: value['minutes']);
        break;
      case WorkoutDrillType.SINGLE:
        block = WorkoutSingleDrillBlock(drill: drills[0]);
        break;
      case WorkoutDrillType.MULTISET:
        block = WorkoutMultisetDrillBlock(drills: drills);
        break;
      case WorkoutDrillType.ForTime:
        block = WorkoutForTimeDrillBlock(
            drills: drills,
            timeCapMin: value['timeCapMin'],
            rounds: value['rounds'],
            restBetweenRoundsMin: value['restBetweenRoundsMin']);
        break;
      case WorkoutDrillType.EMOM:
        block = WorkoutEmomDrillBlock(
            drills: drills,
            timeCapMin: value['timeCapMin'],
            intervalMin: value['intervalMin']);
        break;
      case WorkoutDrillType.REST:
        block = WorkoutRestDrillBlock(timeMin: value['timeMin']);
        break;
    }

    block.type = drillType;
    return block;
  }

  List<WorkoutDrill> copyDrills(){
    return drills!.map((w) => w.copy()).toList();
  }
  Map<String,dynamic> toMapParams();

  Map<String,dynamic> toMap() {
    var mainMap = {
      'type': type.toString(),
      'drills': drills!.map((w) => w.toMap()).toList()
    };
    return{} ..addAll(mainMap) ..addAll(toMapParams());
  }
}

class WorkoutSingleDrillBlock extends WorkoutDrillsBlock
{
  WorkoutSingleDrillBlock({required WorkoutDrill drill})
      : super(type: WorkoutDrillType.SINGLE, drills:[drill]);

  WorkoutSingleDrillBlock copy(){
    return WorkoutSingleDrillBlock(drill: copyDrills()[0]);
  }

  @override
  Map<String, dynamic> toMapParams() {
    // TODO: implement toMapParams
    //throw UnimplementedError();
    return{};
  }
}

class WorkoutMultisetDrillBlock extends WorkoutDrillsBlock
{
  WorkoutMultisetDrillBlock({required List<WorkoutDrill> drills})
      : super(type: WorkoutDrillType.MULTISET, drills:drills);

  WorkoutMultisetDrillBlock copy(){
    return WorkoutMultisetDrillBlock(drills: copyDrills());
  }

  @override
  Map<String, dynamic> toMapParams() {
    // TODO: implement toMapParams
    //throw UnimplementedError();
    return{};
  }
}

class WorkoutAmrapDrillBlock extends WorkoutDrillsBlock
{
  int? minutes;

  WorkoutAmrapDrillBlock({this.minutes, List<WorkoutDrill>? drills})
      : super(type: WorkoutDrillType.AMRAP, drills:drills);

  WorkoutAmrapDrillBlock copy(){
    return WorkoutAmrapDrillBlock(minutes: minutes , drills: copyDrills());
  }

  @override
  Map<String, dynamic> toMapParams() {
    // TODO: implement toMapParams
    //throw UnimplementedError();
    return{};
  }
}

class WorkoutForTimeDrillBlock extends WorkoutDrillsBlock
{
  int? timeCapMin;
  int? rounds;
  int? restBetweenRoundsMin;

  WorkoutForTimeDrillBlock({this.timeCapMin, this.rounds, this.restBetweenRoundsMin, List<WorkoutDrill>? drills})
      : super(type: WorkoutDrillType.ForTime, drills:drills);

  WorkoutForTimeDrillBlock copy(){
    return WorkoutForTimeDrillBlock(timeCapMin: timeCapMin, rounds: rounds, restBetweenRoundsMin: restBetweenRoundsMin, drills: copyDrills());
  }

  @override
  Map<String, dynamic> toMapParams() {
    // TODO: implement toMapParams
    //throw UnimplementedError();
    return{};
  }
}

class WorkoutEmomDrillBlock extends WorkoutDrillsBlock
{
  int? timeCapMin;
  int? intervalMin;

  WorkoutEmomDrillBlock({this.timeCapMin, this.intervalMin, List<WorkoutDrill>? drills})
      : super(type: WorkoutDrillType.EMOM, drills:drills);

  WorkoutEmomDrillBlock copy(){
    return WorkoutEmomDrillBlock(timeCapMin: timeCapMin, intervalMin: intervalMin, drills: copyDrills());
  }

  @override
  Map<String, dynamic> toMapParams() {
    // TODO: implement toMapParams
    //throw UnimplementedError();
    return{};
  }
}

class WorkoutRestDrillBlock extends WorkoutDrillsBlock
{
  int? timeMin;

  WorkoutRestDrillBlock({this.timeMin })
      : super(type: WorkoutDrillType.REST, drills:[]);

  WorkoutRestDrillBlock copy(){
    return WorkoutRestDrillBlock(timeMin: timeMin);
  }

  @override
  Map<String, dynamic> toMapParams() {
    // TODO: implement toMapParams
    //throw UnimplementedError();
    return{};
  }
}
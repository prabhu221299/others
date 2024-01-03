import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'dashboard_event.dart';
part 'dashboard_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  int counter = 5; // Initial countdown value in seconds
  int randomNo = 0;
  int seconds = 0;
  int attemptCounts = 0;
  int successScoreCounts = 0;
  int failureScoreCounts = 0;
  bool isSuccess = false;
  bool isNoAction = true;



  DashboardBloc() : super(DashboardInitial()) {
    on<GenerateRandomNoEvent>(generateRandomNoEvent);
    on<TimerEvent>(timerEvent);
    on<SetAfterOpenEvent>(setAfterOpenEvent);
  }

  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

// Retrieving data
  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  FutureOr setAfterOpenEvent(SetAfterOpenEvent event, Emitter DashboardState) {
    if (event.data != null) {
      successScoreCounts = event.data.successScoreCounts;
      failureScoreCounts = event.data.failureScoreCounts;
      attemptCounts = event.data.attemptCounts;
    }
    emit(DashboardInitial());
  }

  int getCurrentSeconds() {
    DateTime now = DateTime.now();
    return now.second;
  }

  int generateRandomNumber() {
    Random random = Random();
    return random.nextInt(
        60); // Generates a random number between 0 (inclusive) and 60 (exclusive)
  }



  FutureOr generateRandomNoEvent(
      GenerateRandomNoEvent event, Emitter DashboardState) {
    isNoAction = false;
    randomNo = generateRandomNumber();
    seconds = getCurrentSeconds();
    if (seconds == randomNo) {
      emit(GetmsgState("Success Score :)"));
      isSuccess = true;
      successScoreCounts++;
      attemptCounts++;

    } else {
      emit(GetmsgState("Sorry try Again !"));
      isSuccess = false;
      failureScoreCounts++;
      attemptCounts++;
    }
    isNoAction = true;

  }

  late Timer timer;
  FutureOr timerEvent(TimerEvent event, Emitter DashboardState) {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) async{
      if (counter!=0) {
        counter--;
      }
      else if (counter==0 ) {
        if(isNoAction ){
          emit(GetmsgState("Sorry No Action!"));
          await Future.delayed(Duration(seconds: 1));
        }
        counter = 5;
        attemptCounts++;
      }
        emit(GetmsgState("Sorry tyr Again !"));

    });
  }
}

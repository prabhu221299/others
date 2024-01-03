import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeplay/blocs/Dashboard/dashboard_bloc.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  DashboardBloc dashboardBloc = DashboardBloc();

  String msg="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var result = dashboardBloc.getData("backupData");
    // dashboardBloc.add(SetAfterOpenEvent(result));
    dashboardBloc.add(TimerEvent());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    dynamic data = {
      "successScoreCounts": dashboardBloc.successScoreCounts,
      "failureScoreCounts": dashboardBloc.failureScoreCounts,
      "attemptCounts": dashboardBloc.attemptCounts
    };

    dashboardBloc.saveData("backupData", data);
    dashboardBloc.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => dashboardBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Play With Random Number'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      return Card(
                        color: Colors.amberAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'Current Seconds',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${dashboardBloc.seconds}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      return Card(
                        color: Colors.cyanAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'Random Number',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${dashboardBloc.randomNo}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if(state is GetmsgState ){
                    msg=state.msg;
                  }
                  return SizedBox(

                    child: Card(
                        color: dashboardBloc.isSuccess
                            ? Colors.green
                            : Colors.orange,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Text(
                                '${msg}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),


                              Text(
                                dashboardBloc.isSuccess
                                    ? 'Score: "${dashboardBloc.successScoreCounts} / ${dashboardBloc.attemptCounts}" '
                                    : 'Attempts: ${dashboardBloc.attemptCounts}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),

                            ],
                          ),
                        )),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  return Container(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: dashboardBloc.counter /
                              5, // Calculate progress based on the remaining time
                          strokeWidth: 10,
                          backgroundColor: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          '00:${dashboardBloc.counter}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () => dashboardBloc.add(GenerateRandomNoEvent()),
                  child: Text('click to play')),

          ],
          ),
        ),
      ),
    );
  }
}

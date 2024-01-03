part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {
}


class GetmsgState extends DashboardState {
  final  String msg;
  GetmsgState(this.msg);
}

class NoActionState extends DashboardState {
  final  String msg;
  NoActionState(this.msg);
}

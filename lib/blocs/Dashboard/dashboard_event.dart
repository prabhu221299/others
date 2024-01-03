part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}


class GenerateRandomNoEvent extends DashboardEvent{}

class TimerEvent extends DashboardEvent{}

class SetAfterOpenEvent extends DashboardEvent{
  final data;
  SetAfterOpenEvent(this.data);
}
import 'package:hueganizer/widgets/dashboard/hue-dashboard.dart';
import 'package:hueganizer/widgets/huelist/huelist_route.dart';
import 'package:hueganizer/widgets/huenotes/huenotes_route.dart';
import 'package:hueganizer/widgets/huestore/huestore_route.dart';
import 'package:hueganizer/widgets/huexpense/huexpense_route.dart';

class HueConstants {
  static const String hueNotes = HueNotesRoute.routeName;
  static const String hueXpense = HueXpenseRoute.routeName;
  static const String hueList = HueListRoute.routeName;
  static const String hueStore = HueStoreRoute.routeName;
  static const String hueDashboard = HueDashboard.routeName;
  static const String hueStoreListMsg = 'Added by Hue-Store';
  static const String appTitle = 'Hueganizer';
  static const String appDesc = 'Organize Thoughts, Stocks\nand anything else...';
  static const String expenses = 'Expenses';
  static const String allTransactions = 'All Transactions';
  static const String credits = 'Credits';
}
import 'package:flutter/material.dart';
import 'package:hueganizer/constants/constants.dart';
import 'package:hueganizer/models/dash_item.dart';
import 'package:hueganizer/widgets/app_drawer.dart';
import 'package:hueganizer/widgets/dashboard/dashboard-item.dart';

class HueDashboard extends StatelessWidget {
  static const String routeName = '/dashboard';
  List<DashItem> dashItems = [
    DashItem(
      id: 'hue-store',
      name: 'Hue-Store',
      desc: 'Manage all your inventory or stocks',
      routes: HueConstants.hueStore,
      color: Colors.red[900],
      icon: Icons.store,
    ),
    DashItem(
      id: 'hue-list',
      name: 'Hue-List',
      desc: 'Create, edit and share any kind of list',
      routes: HueConstants.hueList,
      color: Colors.blue[900],
      icon: Icons.playlist_add_check,
    ),
    DashItem(
      id: 'hue-notes',
      name: 'Hue-Notes',
      desc: 'Note and share anything in your mind',
      routes: HueConstants.hueNotes,
      color: Colors.deepPurple,
      icon: Icons.note,
    ),
    DashItem(
        id: 'hue-xpense',
        name: 'Hue-Xpense',
        desc: 'Track all your weekly expense',
        routes: HueConstants.hueXpense,
        color: Colors.green[900],
        icon: Icons.account_balance_wallet,
      ),
  ];
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Dashboard'),
    );
    
    return new Scaffold(
      appBar: appBar,
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: GridView(
          padding: const EdgeInsets.all(10),
          children: dashItems
              .map((item) => DashboardItem(
                    id: item.id,
                    name: item.name,
                    desc: item.desc,
                    color: item.color,
                    routes: item.routes,
                    icon: item.icon,
                  ))
              .toList(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
        ),
      ),
    );
  }
}

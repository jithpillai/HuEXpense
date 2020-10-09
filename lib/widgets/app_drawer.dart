import 'package:flutter/material.dart';
import '../constants/constants.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Widget _createDrawerItem(
      IconData icon, String text, GestureTapCallback onTap) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/images/hue.png',
                ),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16, top: 5),
                  child: Text(
                    HueConstants.appDesc,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12.0,
                  left: 16.0,
                  child: Text(
                    HueConstants.appTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _createDrawerItem(
            Icons.dashboard,
            'Dashboard',
            () {
              return Navigator.pushReplacementNamed(
                  context, HueConstants.hueDashboard);
            },
          ),
          _createDrawerItem(
            Icons.store,
            'Hue-Store',
            () {
              return Navigator.pushReplacementNamed(
                  context, HueConstants.hueStore);
            },
          ),
          _createDrawerItem(
            Icons.playlist_add_check,
            'Hue-List',
            () {
              return Navigator.pushReplacementNamed(
                  context, HueConstants.hueList);
            },
          ),
          _createDrawerItem(
            Icons.note,
            'Hue-Notes',
            () {
              return Navigator.pushReplacementNamed(
                  context, HueConstants.hueNotes);
            },
          ),
          _createDrawerItem(
            Icons.account_balance_wallet,
            'Hue-Xpense',
            () {
              return Navigator.pushReplacementNamed(
                  context, HueConstants.hueXpense);
            },
          ),
        ],
      ),
    );
  }
}

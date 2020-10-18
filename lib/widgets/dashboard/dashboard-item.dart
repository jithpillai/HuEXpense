import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  final String id;
  final String name;
  final String desc;
  final Color color;
  final String routes;
  final IconData icon;

  DashboardItem({
    this.id,
    this.name,
    this.desc,
    this.color,
    this.routes,
    this.icon,
  });

  IconData tempIcon = Icons.mic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return Navigator.pushNamed(
                  context, routes);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 21,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Icon(
                icon,
                size: 60,
                color: Colors.white,
              ),
            ),
            Text(
              desc,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

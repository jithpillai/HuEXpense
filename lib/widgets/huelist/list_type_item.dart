import 'package:flutter/material.dart';
import 'package:hueganizer/widgets/huelist/view_hue_list.dart';

class ListTypeItem extends StatelessWidget {
  final String id;
  final String name;
  final String desc;
  final Color color;
  final Function onDeletePressed;
  final Function refreshMainGrid;
  final List<String> _nonDeletables = ['shoppingList', 'bucketList', 'ideas'];

  ListTypeItem(
      {this.id, this.name, this.desc, this.color, this.onDeletePressed, this.refreshMainGrid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new ViewHueList(
              id,
              name,
              desc,
              refreshMainGrid,
            ),
          ),
        );
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  child: Text(
                    desc,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _nonDeletables.contains(id) ? SizedBox() : IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    onDeletePressed(id);
                  },
                ),
              ],
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

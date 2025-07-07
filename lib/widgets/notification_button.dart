import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/widgets/list_notification.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class ButtonNotificationWidget extends StatelessWidget {
  final Color? color;
  const ButtonNotificationWidget({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text(DataController.notifications.length.toString()),
      offset:const Offset(0.5, 0.5),
      child: IconButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ListeNotification() ));
      }, icon: Icon(FontAwesomeIcons.bell,color: color)),
    );
  }
}
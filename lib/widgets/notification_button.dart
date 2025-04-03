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
    return IconButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ListeNotification() ));
    }, icon: Icon(FontAwesomeIcons.bell,color: color));
  }
}
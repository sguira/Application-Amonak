
import 'package:application_amonak/data/data_controller.dart';
import 'package:application_amonak/models/user.dart';
import 'package:application_amonak/widgets/follow_user_widget.dart';
import 'package:flutter/material.dart';
class ContainerFollowerWidget extends StatefulWidget {
  final List<User> users;
  const ContainerFollowerWidget({super.key,required this.users});

  @override
  State<ContainerFollowerWidget> createState() => _ContainerFollowerWidgetState();
}

class _ContainerFollowerWidgetState extends State<ContainerFollowerWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: [
        for(var item in widget.users)
        if(DataController.user!.id!=item.id!)
        FollowUserWidget(context,item)
      ],
    );
  }
}


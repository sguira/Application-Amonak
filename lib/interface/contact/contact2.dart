// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:application_amonak/services/socket/chatProvider.dart';

// class ChatScreen extends StatefulWidget {
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Discussions")),
//       body: Consumer<ChatProvider>(
//         builder: (context, chatProvider, child) {
           
//             return  Column(
//               children: [
//                 StreamBuilder<DateTime>(
//                   stream: chatProvider.timeStream,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return Text(
//                         "Heure actuelle : ${snapshot.data}",
//                         style: TextStyle(fontSize: 16),
//                       );
//                     }
//                     return SizedBox();
//                   },
//                 ),
//                 if(chatProvider.users.length>0)
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: chatProvider.users.length,
//                     itemBuilder: (context, index) {
//                       final user = chatProvider.users[index];
//                       return ListTile(
//                         title: Text(user.userName!),
//                         subtitle: Text("Dernier message : "),
//                         onTap: () {
//                           chatProvider.socket!.emit('joinChatRoom', {
//                             'from': chatProvider.userAuth!.id,
//                             'to': user.id,
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
            
//           );
//         },
//       ),
//     );
//   }
// }

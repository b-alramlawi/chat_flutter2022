//
// import 'package:chat_appx/model/chat_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// class CustomCard extends StatelessWidget {
//   const CustomCard({Key key, this.chatModel, this.sourceChat}) : super(key: key);
//   final ChatModel chatModel;
//   final ChatModel sourceChat;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // Navigator.push(
//         //     context,
//         //     MaterialPageRoute(
//         //         builder: (context) => IndividualPage(
//         //               chatModel: chatModel,
//         //             )));
//       },
//       child: Column(
//         children: [
//           ListTile(
//             leading: CircleAvatar(
//               radius: 30,
//               child: SvgPicture.asset(
//                 chatModel.isGroup ? "assets/group.svg" : "assets/person.svg",
//                 color: Colors.white,
//                 height: 36,
//                 width: 36,
//               ),
//               backgroundColor: Colors.blueGrey,
//             ),
//             title: Text(
//               chatModel.name,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Row(
//               children: [
//                 const Icon(Icons.done_all),
//                 const SizedBox(
//                   width: 3,
//                 ),
//                 Text(
//                   chatModel.currentMessage,
//                   style: const TextStyle(
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//             trailing: Text(chatModel.time),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(right: 20, left: 80),
//             child: Divider(
//               thickness: 1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

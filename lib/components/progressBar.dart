

import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }
}

//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//   int _state = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//       ),
//       body: new Center(
//         child: new Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             new Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: new MaterialButton(
//                 child: setUpButtonChild(),
//                 onPressed: () {
//                   setState(() {
//                     if (_state == 0) {
//                       animateButton();
//                     }
//                   });
//                 },
//                 elevation: 4.0,
//                 minWidth: double.infinity,
//                 height: 48.0,
//                 color: Colors.lightGreen,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget setUpButtonChild() {
//     if (_state == 0) {
//       return new Text(
//         "Click Here",
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 16.0,
//         ),
//       );
//     } else if (_state == 1) {
//       return CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//       );
//     } else {
//       return Icon(Icons.check, color: Colors.white);
//     }
//   }
//
//   void animateButton() {
//     setState(() {
//       _state = 1;
//     });
//
//     Timer(Duration(milliseconds: 3300), () {
//       setState(() {
//         _state = 2;
//       });
//     });
//   }
// }

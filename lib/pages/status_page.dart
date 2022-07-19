import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 150,
          width: 150,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: const Icon(
            Icons.info,
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }
}

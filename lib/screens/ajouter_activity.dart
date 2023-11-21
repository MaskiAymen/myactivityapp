import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AjoutActivity extends StatefulWidget {
  const AjoutActivity({super.key});

  @override
  State<AjoutActivity> createState() => _AjoutActivityState();
}

class _AjoutActivityState extends State<AjoutActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('formulaire ajout '),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class Restart extends StatelessWidget {
// const ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'An email has just been sent to you, Click the link provided to complete registration\n'
                  'Then press the Button below',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            /*TextButton(
                onPressed: () {
                 SystemNavigator.pop();//Only for Android
                 // exit(0);

                 // Phoenix.rebirth(context);
                },
                child: Text('Restart (if verifying link is clicked)'))*/
          ],
        ),
      ),
    );
  }
}

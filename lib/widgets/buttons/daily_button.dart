import 'package:flutter/material.dart';


class DailyButton extends StatefulWidget {
  const DailyButton({Key? key}) : super(key: key);

  @override
  _DailyButtonState createState() => _DailyButtonState();
}

class _DailyButtonState extends State<DailyButton> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused))
                return Colors.red;
              return null; // Defer to the widget's default.
            }
        ),
      ),
      onPressed: () { },
      child: Text('Daily'),
    );
  }
}
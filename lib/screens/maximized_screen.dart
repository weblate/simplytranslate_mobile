import 'package:flutter/material.dart';
import '../data.dart';
import '../widgets/copy_to_clipboard_button.dart';

class MaximizedScreen extends StatefulWidget {
  const MaximizedScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MaximizedScreenState createState() => _MaximizedScreenState();
}

class _MaximizedScreenState extends State<MaximizedScreen> {
  double outputFontSize = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 10),
            decoration: boxDecorationCustom,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: SelectableText(
                      translationOutput,
                      style: TextStyle(fontSize: outputFontSize),
                    ),
                  ),
                ),
                Column(
                  children: [
                    CopyToClipboardButton(translationOutput),
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          outputFontSize += 3;
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          outputFontSize -= 3;
                        });
                      },
                      icon: Icon(Icons.minimize),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

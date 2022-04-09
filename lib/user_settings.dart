import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoey_flutter/model/page_sizes.dart';
import 'package:todoey_flutter/model/task_data.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  void changeColor(Color color) => setState(() => currentColor = color);
  String selectedSize = pageSize;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String size in pageSizes) {
      var newItem = DropdownMenuItem(
        child: Text(size),
        value: size,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedSize,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedSize = value ?? '';
          pageSize = value ?? '';
          print(pageSize);
          setUserPref();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentColor,
        title: Text('OPTIONAL SETTINGS'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 30.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 12.0, 6.0, 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 8.0),
              TextFormField(
                initialValue: titleLabel,
                decoration: InputDecoration(
                  labelText: 'Replace Your Title Label',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newText) {
                  setState(() {
                    titleLabel = newText;
                    setUserPref();
                  });
                },
              ),
              SizedBox(height: 15.0),
              TextFormField(
                initialValue: taskLabel,
                decoration: InputDecoration(
                  labelText: 'Replace Your Tasks Label',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newText) {
                  setState(() {
                    taskLabel = newText;
                    setUserPref();
                  });
                },
              ),
              SizedBox(height: 15.0),
              Text(
                'YES will print all, NO will print only unchecked items',
              ),
              Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: ToggleSwitch(
                  totalSwitches: 2,
                  initialLabelIndex: yesOrNo.indexOf(printAllItems),
                  minWidth: double.infinity,
                  cornerRadius: 0.0,
                  activeBgColor: [currentColor],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.black,
                  labels: ['YES', 'NO'],
                  onToggle: (index) {
                    printAllItems = yesOrNo[index ?? 0];
                    print('switched to: $printAllItems');
                    setUserPref();
                  },
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Select Page Size:',
              ),
              Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                alignment: Alignment.center,
                child: androidDropdown(),
              ),
              SizedBox(height: 15.0),
              Text(
                'Choose a specific language font:',
              ),
              Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: ToggleSwitch(
                  totalSwitches: 4,
                  initialLabelIndex: eastOrWest.indexOf(fontSelected),
                  minWidth: double.infinity,
                  cornerRadius: 0.0,
                  activeBgColor: [currentColor],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.black,
                  labels: ['West', '繁體', '中英', '日英'],
                  onToggle: (index) {
                    fontSelected = eastOrWest[index ?? 0];
                    print('switched to: $fontSelected');
                    setUserPref();
                  },
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Adjust Margins (left, top, right, bottom)',
              ),
              Container(
                height: 32.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: left.toString()),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 6.0),
                            border: OutlineInputBorder(),
                            hintText: 'left'),
                        onChanged: (newText) {
                          left = double.parse(newText.toString());
                          setUserMargins();
                        },
                      ),
                    ),
                    SizedBox(width: 3.0),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: top.toString()),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 6.0),
                            border: OutlineInputBorder(),
                            hintText: 'top'),
                        onChanged: (newText) {
                          top = double.parse(newText.toString());
                          setUserMargins();
                        },
                      ),
                    ),
                    SizedBox(width: 3.0),
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: right.toString()),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 6.0),
                            border: OutlineInputBorder(),
                            hintText: 'right'),
                        onChanged: (newText) {
                          right = double.parse(newText.toString());
                          setUserMargins();
                        },
                      ),
                    ),
                    SizedBox(width: 3.0),
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: bottom.toString()),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 6.0),
                            border: OutlineInputBorder(),
                            hintText: 'bottom'),
                        onChanged: (newText) {
                          bottom = double.parse(newText.toString());
                          setUserMargins();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              RaisedButton(
                elevation: 3.0,
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0.0),
                        contentPadding: const EdgeInsets.all(0.0),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: currentColor,
                            onColorChanged: changeColor,
                            colorPickerWidth: 300.0,
                            pickerAreaHeightPercent: 0.7,
                            enableAlpha: true,
                            displayThumbColor: true,
                            showLabel: true,
                            paletteType: PaletteType.hsv,
                            pickerAreaBorderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(2.0),
                              topRight: const Radius.circular(2.0),
                            ),
                          ),
                        ),
                      );
                    },
                  );
//                print(currentColor);
                  setUserColor();
                },
                child: Text('Change Background $currentColor'),
                color: currentColor,
                textColor: useWhiteForeground(currentColor)
                    ? const Color(0xffffffff)
                    : const Color(0xff000000),
              ),
              SizedBox(height: 15.0),
              Text(
                'Select Text Color',
              ),
              Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: ToggleSwitch(
                  totalSwitches: 2,
                  initialLabelIndex: blackOrRed.indexOf(printTextColor),
                  minWidth: double.infinity,
                  cornerRadius: 0.0,
                  activeBgColor: [currentColor],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.black,
                  labels: ['BLACK', 'RED'],
                  onToggle: (index) {
                    printTextColor = blackOrRed[index ?? 0];
                    print('switched to: $printTextColor');
                    setUserPref(); // added to support color red, i.e. DK-2251
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// save user preferences
void setUserPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userPreference =
      '{"titleName":"$titleLabel","taskName":"$taskLabel","pageSize":"$pageSize","printAllItems":"$printAllItems","fontSelected":"$fontSelected","printTextColor":"$printTextColor"}';
  await prefs.setString('userPreference', userPreference);
}

void setUserColor() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('color', currentColor.value);
  print('save color code is ${currentColor.value} value $currentColor');
}

void setUserMargins() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('left', left ?? 0);
  await prefs.setDouble('top', top ?? 0);
  await prefs.setDouble('right', right ?? 0);
  await prefs.setDouble('bottom', bottom ?? 0);
}

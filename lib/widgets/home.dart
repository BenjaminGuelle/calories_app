import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calories_app/widgets/customText.dart';
import 'package:calories_app/widgets/padding.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color girlColor = Colors.pink;
  Color boyColor = Colors.blue;
  Color colorTheme = Colors.grey[800];
  bool switchType = false;
  double taille = 100.0;
  double poid;
  double age;

  Object itemSlected;

  int calorieBase;
  int calorieWithActivity;

  Map sport = {
    0: 'Faible',
    1: 'Modere',
    2: 'Forte',
  };

  List<Widget> radios() {
    List<Widget> list = [];
    sport.forEach((key, value) {
      Column colRadio = Column(
        children: <Widget>[
          Radio(
              activeColor: (switchType) ? boyColor : girlColor,
              value: key,
              groupValue: itemSlected,
              onChanged: (Object b) {
                setState(() {
                  itemSlected = b;
                });
              }),
          customText(value,
              color: (switchType) ? boyColor : girlColor, factor: 1.4),
        ],
      );
      list.add(colRadio);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      print('Nous sommes sur ios');
    } else
      print('Nous sommes pas sur ios');
    double height = MediaQuery.of(context).size.height * 0.65;
    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: (switchType) ? boyColor : girlColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customText(
                'Remplissez tous les champs pour obtenir votre besoin journalier en calories.',
                factor: 1.3,
                color: Colors.grey[800],
              ),
              paddingBox(top: 20.0),
              Card(
                elevation: 20.0,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      paddingBox(top: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          customText('Femme', factor: 1.3, color: girlColor),
                          Switch(
                              inactiveThumbColor: girlColor,
                              activeColor: boyColor,
                              inactiveTrackColor: girlColor,
                              value: switchType,
                              onChanged: (bool b) {
                                setState(() {
                                  switchType = b;
                                });
                              }),
                          customText('Homme', factor: 1.3, color: boyColor),
                        ],
                      ),
                      paddingBox(top: 20.0),
                      buttonCustom(showDate),
                      paddingBox(top: 20.0),
                      customText(
                        'Votre taille est de : ${taille.toInt()} cm.',
                        factor: 1.3,
                        color: Colors.grey[800],
                      ),
                      paddingBox(top: 30.0),
                      Slider(
                          activeColor: (switchType) ? boyColor : girlColor,
                          inactiveColor: Colors.grey[400],
                          value: taille,
                          min: 100.0,
                          max: 220.0,
                          onChanged: (double d) {
                            setState(() {
                              taille = d;
                            });
                          }),
                      paddingBox(top: 20.0),
                      TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (String newPoid) {
                          setState(() {
                            poid = double.tryParse(newPoid);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Indiquez votre poids en kilos',
                        ),
                      ),
                      paddingBox(top: 30.0),
                      customText(
                        'Quelle est votre activité sportive?',
                        factor: 1.5,
                        color: (switchType) ? boyColor : girlColor,
                      ),
                      paddingBox(top: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: radios(),
                      ),
                      paddingBox(top: 30.0),
                    ],
                  ),
                ),
              ),
              paddingBox(top: 20.0),
              ElevatedButton(
                  onPressed: calculCalories,
                  child: customText(
                    'Calculer',
                  )),
            ],
          ),
        ),
      ),
    );
  }

  TextButton buttonCustom(func) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: (switchType)
              ? MaterialStateProperty.all(boyColor)
              : MaterialStateProperty.all(girlColor)),
      onPressed: func,
      child: customText(
        (age == null)
            ? 'Indiquez votre age'
            : 'Votre age est : ${age.toInt()} ans',
        factor: 1.2,
      ),
    );
  }

  Future<Null> showDate() async {
    DateTime choix = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (choix != null) {
      var difference = DateTime.now().difference(choix);
      var jours = difference.inDays;
      var ans = (jours / 365);
      setState(() {
        age = ans;
      });
    }
  }

  void calculCalories() {
    if (age != null && poid != null) {
      if (switchType) {
        calorieBase =
            (66.4730 + (13.7516 * poid) + (5.0033 * taille) - (6.7550 * age))
                .toInt();
      } else {
        calorieBase =
            (655.0955 + (9.5634 * poid) + (1.8496 * taille) - (4.6756 * age))
                .toInt();
      }
      switch (itemSlected) {
        case 0:
          calorieWithActivity = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieWithActivity = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieWithActivity = (calorieBase * 1.8).toInt();
          break;
      }

      setState(() {
        dial();
      });
    } else {
      alerte();
    }
  }

  Future<Null> dial() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return SimpleDialog(
            title: customText("Votre besoin en calories", color: Colors.black),
            contentPadding: EdgeInsets.all(15.0),
            children: [
              customText("Votre besoin de base est de : $calorieBase",
                  color: Colors.black),
              paddingBox(top: 20.0),
              customText(
                  "Votre besoin avec le sport est de : $calorieWithActivity",
                  color: Colors.black),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(buildContext);
                },
                child: customText("ok", color: Colors.black),
              ),
            ],
          );
        });
  }

  Future<Null> alerte() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: customText('Erreur', color: Colors.black),
            content: customText('Tous les champs ne sont pas remplis',
                color: Colors.black),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: customText('ok'))
            ],
          );
        });
  }
}

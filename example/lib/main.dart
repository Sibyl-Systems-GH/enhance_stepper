import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'DDLog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int groupValue = 0;
  StepperType _type = StepperType.vertical;

  List<Tuple2> tuples = [
    Tuple2(Icons.directions_bike, StepState.indexed, ),
    Tuple2(Icons.directions_bus, StepState.editing, ),
    Tuple2(Icons.directions_railway, StepState.complete, ),
    Tuple2(Icons.directions_boat, StepState.disabled, ),
    Tuple2(Icons.directions_car, StepState.error, ),
  ];

  int _index = 0;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(onPressed: (){
            DDLog("change");
            setState(() {
              _type = _type == StepperType.vertical ? StepperType.horizontal : StepperType.vertical;
            });
          }, child: Icon(Icons.change_circle_outlined, color: Colors.white,)),
        ],
        bottom: buildPreferredSize(context),
      ),
      body: groupValue == 0 ? buildStepper(context) : buildStepperCustom(context),
    );
  }

  PreferredSizeWidget buildPreferredSize(BuildContext context) {
    return
      PreferredSize(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 24),
                Expanded(
                  child: CupertinoSegmentedControl(
                    children: const <int, Widget>{
                      0: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Stepper', style: TextStyle(fontSize: 15))),
                      1: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('enhance_stepper', style: TextStyle(fontSize: 15))),
                    },
                    groupValue: groupValue,
                    onValueChanged: (value) {
                      // TODO: - fix it
                      DDLog(value.toString());
                      setState(() {
                        groupValue = int.parse("$value");
                      });
                    },
                    borderColor: Colors.white,
                    selectedColor: Colors.white,
                    unselectedColor: Colors.blue,
                  ),
                ),
                SizedBox(width: 24)
              ],
            ),
          ),
          preferredSize: Size(double.infinity, 48));
  }

  void go(int index) {
    if (index == -1 && _index <= 0 ) {
      DDLog("it's first Step!");
      return;
    }

    if (index == 1 && _index >= tuples.length - 1) {
      DDLog("it's last Step!");
      return;
    }

    setState(() {
      _index += index;
    });
  }

  Widget buildStepper(BuildContext context) {
    return Stepper(
        type: _type,
        currentStep: _index,
        physics: ClampingScrollPhysics(),
        steps: tuples.map((e) => Step(
          state: StepState.values[tuples.indexOf(e)],
          isActive: _index == tuples.indexOf(e),
          isStepperTypeHorizontalBottom: true,
          isStepperTypeHorizontalBottomLineFollowIconMidY: true,
          title: Text("step ${tuples.indexOf(e)}"),
          subtitle: Text("${e.item2.toString().split(".").last}",),
          content: Text("Content for Step ${tuples.indexOf(e)}"),
        )).toList(),
        onStepCancel: () {
          go(-1);
        },
        onStepContinue: () {
          go(1);
        },
        onStepTapped: (index) {
          DDLog(index);
          setState(() {
            _index = index;
          });
        },
        controlsBuilder: (BuildContext context, { VoidCallback? onStepContinue, VoidCallback? onStepCancel }){
          return Row(
            children: [
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: onStepContinue,
                child: Text("Next"),
              ),
              SizedBox(width: 8,),
              TextButton(onPressed: onStepCancel, child: Text("Back"), ),

            ],
          );
        }
    );
  }

  Widget buildStepperCustom(BuildContext context) {
    return EnhanceStepper(
        stepIconSize: 30,
        type: _type,
        currentStep: _index,
        physics: ClampingScrollPhysics(),
        steps: tuples.map((e) => EnhanceStep(
          circleChild: Icon(e.item1, color: Colors.blue, size: 30,),
          state: StepState.values[tuples.indexOf(e)],
          isActive: _index == tuples.indexOf(e),
          isStepperTypeHorizontalBottom: true,
          isStepperTypeHorizontalBottomLineFollowIconMidY: true,
          title: Text("step ${tuples.indexOf(e)}"),
          subtitle: Text("${e.item2.toString().split(".").last}",),
          content: Text("Content for Step ${tuples.indexOf(e)}"),
        )).toList(),
        onStepCancel: () {
          go(-1);
        },
        onStepContinue: () {
          go(1);
        },
        onStepTapped: (index) {
          DDLog(index);
          setState(() {
            _index = index;
          });
        },
        controlsBuilder: (BuildContext context, { VoidCallback? onStepContinue, VoidCallback? onStepCancel }){
          return Row(
            children: [
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: onStepContinue,
                child: Text("Next"),
              ),
              SizedBox(width: 8,),
              TextButton(onPressed: onStepCancel, child: Text("Back"), ),
            ],
          );
        }
    );
  }
}

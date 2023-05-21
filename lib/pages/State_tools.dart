import 'package:arosa/scaffold_adds/drawer.dart';
import 'package:flutter/material.dart';

class State_tools extends StatefulWidget {
  const State_tools({super.key});

  @override
  State<State_tools> createState() => _State_toolsState();
}

class _State_toolsState extends State<State_tools> {
  GlobalKey<FormState> dialogkey = GlobalKey<FormState>();
  var Type;
  var OnOff;
  var State;
  var TimeEnd;
  var TimeStart;
  var distibutedwater = 9;
  List<Tab> mytabs = const [
    Tab(
      text: "Pompes",
    ),
    Tab(
      text: "Vannes",
    )
  ];
  List pompes = [
    {
      'Type': 'Pompe',
      'state': false,
      'O or F': 'Off',
      'Time to Start': '12:30',
      'Time to End': '14:30',
      'distributed water': 0,
    }
  ];
  List valves = [
    {
      'Type': 'Vanne',
      'state': false,
      'O or F': '',
      'Time to Start': '12:30',
      'Time to End': '14:30',
    },
    {
      'Type': 'Vanne',
      'state': false,
      'O or F': '',
      'Time to Start': '12:30',
      'Time to End': '13:30',
    },
    {
      'Type': 'Vanne',
      'state': false,
      'O or F': '',
      'Time to Start': '13:30',
      'Time to End': '14:30',
    }
  ];
  add() {
    Map insert = {};
    if (dialogkey.currentState!.validate()) {
      dialogkey.currentState!.save();

      if (Type == 'Pompe' || Type == 'pompe') {
        insert.addEntries({
          MapEntry('Type', Type),
          MapEntry('State', State),
          MapEntry('O or F', OnOff),
          MapEntry('Time to Start', TimeStart),
          MapEntry('Time to End', TimeEnd),
          MapEntry('distributed water', distibutedwater),
        });
        pompes.add(insert);
        print(pompes);
      } else {
        if (Type == 'Valve' || Type == 'valve') {
          insert.addEntries({
            MapEntry('Type', Type),
            MapEntry('State', State),
            MapEntry('O or F', OnOff),
            MapEntry('Time to Start', TimeStart),
            MapEntry('Time to End', TimeEnd),
          });
          valves.add(insert);
          print(valves);
        }
      }
    }
    insert.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: mytabs.length,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Add Tools'),
                      content: SizedBox(
                          width: double.maxFinite,
                          height: 380,
                          child: ListView(children: [
                            Form(
                                key: dialogkey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Type',
                                        border: OutlineInputBorder(),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onSaved: (newValue) => Type = newValue,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'ON / OFF',
                                        border: OutlineInputBorder(),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onSaved: (newValue) => OnOff = newValue,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                        decoration: const InputDecoration(
                                          hintText: 'State',
                                          border: OutlineInputBorder(),
                                        ),
                                        initialValue:
                                            OnOff == 'On' ? 'true' : 'false',
                                        textInputAction: TextInputAction.next,
                                        onSaved: (newValue) =>
                                            State = newValue),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Time Started',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      onSaved: (newValue) =>
                                          TimeStart = newValue,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Time End',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      onSaved: (newValue) => TimeEnd = newValue,
                                    )
                                  ],
                                )),
                          ])),
                      actions: [
                        ElevatedButton.icon(
                          onPressed: add(),
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                        )
                      ],
                    ));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('State of tools'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back))
          ],
          bottom: TabBar(tabs: mytabs),
        ),
        drawer: const drawer(),
        body: TabBarView(children: [
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: pompes.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  SwitchListTile(
                      secondary: CircleAvatar(
                          child: Image.asset('images/POMPE-icon.jpg')),
                      selected: pompes[index]['state'] == true ? true : false,
                      title: Text('${pompes[index]['Type']}'),
                      value: pompes[index]['state'],
                      onChanged: (value) {
                        setState(() {
                          pompes[index]['state'] = value;
                        });
                      }),
                  ListTile(
                    title: const Text('State'),
                    subtitle: Text(pompes[index]['O or F'] =
                        pompes[index]['state'] == true ? 'On' : 'Off'),
                    trailing: Icon(
                        pompes[index]['state'] == true
                            ? Icons.water_drop
                            : Icons.format_color_reset,
                        color: pompes[index]['state'] == true
                            ? Colors.blueAccent
                            : Colors.grey),
                  ),
                  ListTile(
                    title: const Text('Time'),
                    subtitle: Text(
                        '${pompes[index]['Time to Start']} - ${pompes[index]['Time to End']}'),
                    trailing: Icon(Icons.timer,
                        color: pompes[index]['state'] == true
                            ? Colors.blueAccent
                            : Colors.grey),
                  ),
                  ListTile(
                    title: const Text('Distributed water'),
                    subtitle: Text('${pompes[index]['distributed water']}'),
                    trailing: Icon(Icons.water,
                        color: pompes[index]['state'] == true
                            ? Colors.blueAccent
                            : Colors.grey),
                  )
                ],
              ),
            ),
          ),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: valves.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.all(15),
                child: Column(children: [
                  SwitchListTile(
                    value: valves[index]['state'],
                    selected: valves[index]['state'] == true ? true : false,
                    onChanged: (value) {
                      setState(() {
                        valves[index]['state'] = value;
                      });
                    },
                    title: Text('${valves[index]['Type']} ${index + 1}'),
                    secondary:
                        CircleAvatar(child: Image.asset('images/valve.png')),
                  ),
                  ListTile(
                    title: const Text('State'),
                    subtitle: Text(valves[index]['O or F'] =
                        valves[index]['state'] == true ? 'On' : 'Off'),
                    trailing: Icon(
                        valves[index]['state'] == true
                            ? Icons.water_drop
                            : Icons.format_color_reset,
                        color: valves[index]['state'] == true
                            ? Colors.blueAccent
                            : Colors.grey),
                  ),
                  ListTile(
                    title: const Text('Time'),
                    subtitle: Text(
                        '${valves[index]['Time to Start']} - ${valves[index]['Time to End']}'),
                    trailing: Icon(Icons.timer,
                        color: valves[index]['state'] == true
                            ? Colors.blueAccent
                            : Colors.grey),
                  ),
                ]),
              );
            },
          )
        ]),
      ),
    );
  }
}

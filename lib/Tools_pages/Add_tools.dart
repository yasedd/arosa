import 'package:arosa/scaffold_adds/alert.dart';
import 'package:arosa/scaffold_adds/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';

class Add_tools extends StatefulWidget {
  const Add_tools({super.key});

  @override
  State<Add_tools> createState() => _Add_toolsState();
}

class _Add_toolsState extends State<Add_tools> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> keyform = GlobalKey<FormState>();
    var type, state, timestart, timeend, distributedwater;
    bool settime = false;
    TextEditingController contimestart = TextEditingController();
    TextEditingController contimeend = TextEditingController();
    var ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    List Pompes = [];
    List Vannes = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tools'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back))
        ],
      ),
      drawer: drawer(),
      body: FutureBuilder(
        future: ref.get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          try {
            if (snapshot.data?.data()['Pompes'] != null ||
                snapshot.data?.data()['Vannes'] != null) {
              Pompes = snapshot.data!.data()['Pompes'];
              Vannes = snapshot.data!.data()['Vannes'];
            } else {
              Pompes = [];
              Vannes = [];
            }
          } catch (e) {
            print(e);
          }

          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: [
                Form(
                    key: keyform,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SelectFormField(
                            type: SelectFormFieldType.dropdown,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Type'),
                            items: const [
                              {'value': 'Pompe', 'label': 'Pompe'},
                              {'value': 'Vanne', 'label': 'Vanne'}
                            ],
                            onSaved: (newValue) {
                              type = newValue;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SelectFormField(
                            type: SelectFormFieldType.dropdown,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'State'),
                            items: const [
                              {
                                'value': false,
                              },
                              {
                                'value': true,
                              }
                            ],
                            onSaved: (newValue) {
                              state = newValue == 'true' ? true : false;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Time to Start'),
                            readOnly: true,
                            controller: contimestart,
                            onSaved: ((newValue) async {
                              setState(() {
                                timestart = newValue;
                              });
                            }),
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (pickedTime != null) {
                                contimestart.text =
                                    pickedTime.format(context).toString();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Time to End'),
                            readOnly: true,
                            controller: contimeend,
                            onSaved: ((newValue) async {
                              setState(() {
                                timeend = newValue;
                              });
                            }),
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (pickedTime != null) {
                                contimeend.text =
                                    pickedTime.format(context).toString();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Distributed water',
                                helperText: '*Only for Pompe'),
                            keyboardType: TextInputType.number,
                            onSaved: (newValue) {
                              distributedwater = newValue;
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                keyform.currentState!.save();
                                if (type == 'Pompe') {
                                  Pompes.add({
                                    'Type': type,
                                    'State': state,
                                    'setTime': settime,
                                    'TimeStart': timestart,
                                    'TimeEnd': timeend,
                                    'distributedwater': distributedwater
                                  });
                                  print(Pompes);
                                  ref.update({'Pompes': Pompes}).then((value) {
                                    print('update success');
                                  }).catchError((e) {
                                    print('Error : $e');
                                  });
                                } else {
                                  Vannes.add({
                                    'Type': type,
                                    'State': state,
                                    'setTime': settime,
                                    'TimeStart': timestart,
                                    'TimeEnd': timeend
                                  });
                                  print(Vannes);
                                  ref.update({'Vannes': Vannes});
                                }
                                showloading(context);

                                Navigator.of(context)
                                    .pushReplacementNamed('Home');
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add'),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}

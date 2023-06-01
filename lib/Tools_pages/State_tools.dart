import 'package:firebase_auth/firebase_auth.dart';
import 'package:arosa/scaffold_adds/drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class State_tools extends StatefulWidget {
  const State_tools({super.key});

  @override
  State<State_tools> createState() => _State_toolsState();
}

class _State_toolsState extends State<State_tools> {
  GlobalKey<FormState> dialogkey = GlobalKey<FormState>();
  List Pompes = [];
  List Vannes = [];

  var ref = FirebaseFirestore.instance.collection('users');
  DatabaseReference dataref = FirebaseDatabase.instance.ref();

  List<Tab> mytabs = const [
    Tab(
      text: "Pompes",
    ),
    Tab(
      text: "Vannes",
    )
  ];
  var TimeEnd;
  var TimeStart;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: mytabs.length,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('Add_tools');
            }),
        appBar: AppBar(
          title: const Text('State of tools'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('Remove_tools');
                },
                icon: const Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back))
          ],
          bottom: TabBar(tabs: mytabs),
        ),
        drawer: const drawer(),
        body: StreamBuilder(
          stream: ref.doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            TextEditingController pcontimestart = TextEditingController();
            TextEditingController pcontimeend = TextEditingController();
            TextEditingController vcontimestart = TextEditingController();
            TextEditingController vcontimeend = TextEditingController();
            Pompes = data['Pompes'] ?? [];
            Vannes = data['Vannes'] ?? [];
            Map<String, dynamic> databaseData = {
              'Pompes': Pompes,
              'Vannes': Vannes,
            };
            // ignore: unnecessary_null_comparison
            if (data != null) {
              try {
                dataref
                    .child(FirebaseAuth.instance.currentUser!.uid)
                    .set(databaseData);
              } catch (e) {
                print(' realtime Error : $e');
              }
            }

            return TabBarView(children: [
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: data['Pompes'].length,
                  itemBuilder: (context, index) {
                    // ignore: unnecessary_null_comparison
                    // const Duration(seconds: 3);
                    if (Pompes.isNotEmpty ||
                        Pompes[index] == data['Pompes'][index]) {
                      dataref
                          .child(
                              '${FirebaseAuth.instance.currentUser!.uid}/Pompes/$index/distributedwater')
                          .onValue
                          .listen((DatabaseEvent event) {
                        final sdata = event.snapshot.value;
                        // print(data);
                        try {
                          Pompes[index]['distributedwater'] = sdata;
                        } catch (e) {
                          print('Error St_tl: $e');
                        }
                      });
                    }

                    settimePompe() {
                      showDialog(
                          context: context,
                          builder: (context) {
                            GlobalKey<FormState> Skey = GlobalKey<FormState>();

                            return ListView(children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 170),
                                child: AlertDialog(
                                  title: const Text('Set Time'),
                                  content: Form(
                                      key: Skey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Time to Start'),
                                            readOnly: true,
                                            controller: pcontimestart,
                                            onSaved: ((newValue) async {
                                              setState(() {
                                                Pompes[index]['TimeStart'] =
                                                    newValue;
                                              });
                                            }),
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now());
                                              if (pickedTime != null) {
                                                pcontimestart.text = pickedTime
                                                    .format(context)
                                                    .toString();
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
                                            controller: pcontimeend,
                                            onSaved: ((newValue) async {
                                              setState(() {
                                                Pompes[index]['TimeEnd'] =
                                                    newValue;
                                              });
                                            }),
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now());
                                              if (pickedTime != null) {
                                                pcontimeend.text = pickedTime
                                                    .format(context)
                                                    .toString();
                                              }
                                            },
                                          ),
                                        ],
                                      )),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          if (Skey.currentState!.validate()) {
                                            Skey.currentState!.save();
                                            setState(() {
                                              ref
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .update({
                                                'Pompes': Pompes
                                              }).then((value) {
                                                // print(st);
                                                print('update success');
                                              }).catchError((e) {
                                                print('Error : $e');
                                              });
                                              dataref
                                                  .child(
                                                      '${FirebaseAuth.instance.currentUser!.uid}')
                                                  .update(databaseData);
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text('Sauvegarder')),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Annuler'))
                                  ],
                                ),
                              ),
                            ]);
                          });
                    }

                    return Card(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          SwitchListTile(
                              secondary: CircleAvatar(
                                  child: Image.asset('images/POMPE-icon.jpg')),
                              selected: data['Pompes'][index]['State'],
                              title: Text(
                                  '${data['Pompes'][index]['Type']} ${index + 1}'),
                              value: data['Pompes'][index]['State'],
                              onChanged: (value) {
                                setState(() {
                                  Pompes[index]['State'] = value;
                                  ref
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({'Pompes': Pompes}).then((value) {
                                    print('update success');
                                  }).catchError((e) {
                                    print('Error : $e');
                                  });
                                  dataref
                                      .child(
                                          '${FirebaseAuth.instance.currentUser!.uid}')
                                      .update(databaseData);
                                });
                              }),
                          ListTile(
                              title: const Text('State'),
                              subtitle: Text(
                                  data['Pompes'][index]['State'] == true
                                      ? 'On'
                                      : 'Off'),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                    data['Pompes'][index]['State'] == true
                                        ? Icons.water_drop
                                        : Icons.format_color_reset,
                                    color:
                                        data['Pompes'][index]['State'] == true
                                            ? Colors.blueAccent
                                            : Colors.grey),
                              )),
                          ListTile(
                              title: const Text('Time'),
                              subtitle: Text(
                                  '${data['Pompes'][index]['TimeStart']} - ${data['Pompes'][index]['TimeEnd']}'),
                              onTap: () {
                                if (data['Pompes'][index]['setTime'] == true) {
                                  settimePompe();
                                }
                              },
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      Pompes[index]['setTime'] =
                                          !Pompes[index]['setTime'];

                                      ref
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({'Pompes': Pompes}).then(
                                              (value) {
                                        print('update success');
                                      }).catchError((e) {
                                        print('Error : $e');
                                      });
                                      dataref
                                          .child(
                                              '${FirebaseAuth.instance.currentUser!.uid}')
                                          .update(databaseData);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.schedule_send_rounded,
                                    color: Pompes[index]['setTime'] == true
                                        ? Colors.blueAccent
                                        : Colors.grey,
                                  ))),
                          ListTile(
                              title: const Text('Distributed water'),
                              // subtitle: Text(
                              //     '${data['Pompes'][index]['distributedwater']}'),
                              onTap: () {
                                setState(() {
                                  ref
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({'Pompes': Pompes}).then((value) {
                                    print('update success');
                                  }).catchError((e) {
                                    print('Error : $e');
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 190),
                                        child: AlertDialog(
                                          title: Text(
                                            '${data['Pompes'][index]['Type']} ${index + 1}',
                                            style: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Center(
                                                child: Text(
                                                  'Distributed water',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  '${data['Pompes'][index]['distributedwater']}',
                                                  style: const TextStyle(
                                                      fontSize: 60),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // actions: [
                                          //   ElevatedButton(
                                          //       onPressed: () {
                                          //         Navigator.of(context).pop();
                                          //       },
                                          //       child: const Text('Cancel'))
                                          // ],
                                        ),
                                      );
                                    },
                                  );
                                });
                              },
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.water,
                                    color:
                                        data['Pompes'][index]['State'] == true
                                            ? Colors.blueAccent
                                            : Colors.grey),
                              ))
                        ],
                      ),
                    );
                  }),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data['Vannes'].length,
                itemBuilder: (BuildContext context, int index) {
                  settimeVanne() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          GlobalKey<FormState> Skey = GlobalKey<FormState>();
                          return ListView(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 170),
                                child: AlertDialog(
                                  title: Text('Set Time'),
                                  content: Form(
                                      key: Skey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Time to Start'),
                                            readOnly: true,
                                            controller: vcontimestart,
                                            onSaved: ((newValue) async {
                                              setState(() {
                                                Vannes[index]['TimeStart'] =
                                                    newValue;
                                              });
                                            }),
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now());
                                              if (pickedTime != null) {
                                                vcontimestart.text = pickedTime
                                                    .format(context)
                                                    .toString();
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
                                            controller: vcontimeend,
                                            onSaved: ((newValue) async {
                                              setState(() {
                                                Vannes[index]['TimeEnd'] =
                                                    newValue;
                                              });
                                            }),
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now());
                                              if (pickedTime != null) {
                                                vcontimeend.text = pickedTime
                                                    .format(context)
                                                    .toString();
                                              }
                                            },
                                          ),
                                        ],
                                      )),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          if (Skey.currentState!.validate()) {
                                            Skey.currentState!.save();
                                            setState(() {
                                              ref
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .update({
                                                'Vannes': Vannes
                                              }).then((value) {
                                                print('update success');
                                              }).catchError((e) {
                                                print('Error : $e');
                                              });
                                              dataref
                                                  .child(
                                                      '${FirebaseAuth.instance.currentUser!.uid}')
                                                  .update(databaseData);
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text('Sauvegarder')),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Annuler'))
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  }

                  return Card(
                    margin: const EdgeInsets.all(15),
                    child: Column(children: [
                      SwitchListTile(
                        value: data['Vannes'][index]['State'],
                        selected: data['Vannes'][index]['State'],
                        onChanged: (value) async {
                          setState(() {
                            Vannes[index]['State'] = value;

                            ref
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'Vannes': Vannes}).then((value) {
                              print('update success');
                            }).catchError((e) {
                              print('Error : $e');
                            });
                            dataref
                                .child(
                                    '${FirebaseAuth.instance.currentUser!.uid}')
                                .update(databaseData);
                          });
                        },
                        title: Text(
                            '${data['Vannes'][index]['Type']} ${index + 1}'),
                        secondary: CircleAvatar(
                            child: Image.asset('images/valve.png')),
                      ),
                      ListTile(
                          title: const Text('State'),
                          subtitle: Text(data['Vannes'][index]['State'] == true
                              ? 'On'
                              : 'Off'),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                                data['Vannes'][index]['State'] == true
                                    ? Icons.water_drop
                                    : Icons.format_color_reset,
                                color: data['Vannes'][index]['State'] == true
                                    ? Colors.blueAccent
                                    : Colors.grey),
                          )),
                      ListTile(
                          title: const Text('Time'),
                          subtitle: Text(
                              '${data['Vannes'][index]['TimeStart']} - ${data['Vannes'][index]['TimeEnd']}'),
                          onTap: () {
                            if (data['Vannes'][index]['setTime'] == true) {
                              settimeVanne();
                            }
                          },
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  Vannes[index]['setTime'] =
                                      !Vannes[index]['setTime'];

                                  ref
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({'Vannes': Vannes}).then((value) {
                                    print('update success');
                                  }).catchError((e) {
                                    print('Error : $e');
                                  });
                                  dataref
                                      .child(
                                          '${FirebaseAuth.instance.currentUser!.uid}')
                                      .update(databaseData);
                                });
                              },
                              icon: Icon(
                                Icons.schedule_send_rounded,
                                color: Vannes[index]['setTime'] == true
                                    ? Colors.blueAccent
                                    : Colors.grey,
                              ))),
                    ]),
                  );
                },
              )
            ]);
          },
        ),
      ),
    );
  }
}

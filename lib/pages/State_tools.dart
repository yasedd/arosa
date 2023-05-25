import 'package:arosa/scaffold_adds/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class State_tools extends StatefulWidget {
  const State_tools({super.key});

  @override
  State<State_tools> createState() => _State_toolsState();
}

class _State_toolsState extends State<State_tools> {
  GlobalKey<FormState> dialogkey = GlobalKey<FormState>();
  List user = [];
  List Pompes = [];
  List Vannes = [];

  var ref = FirebaseFirestore.instance.collection('users');
  getdata() async {
    var responcebody = await ref.get();
    setState(() {
      responcebody.docs.forEach((element) {
        user.setAll(0, [element.data()]);
      });
      print(user);
    });
  }

  intdata() async {
    var responce = await ref.get();
    setState(() {
      responce.docs.forEach((element) {
        user.add(element.data());
      });
      print(user);
      print(DateFormat.Hm().format(DateTime.now()));
    });
  }

  @override
  void initState() {
    intdata();
    super.initState();
  }

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
        body: FutureBuilder(
          future: ref.doc('gml9GRvOKYzmgMzO1lQn').get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              Pompes = data['Pompes'];
              Vannes = data['Vannes'];

              return TabBarView(children: [
                ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: data['Pompes'].length,
                    itemBuilder: (context, index) {
                      changeval() async {
                        Future.delayed(Duration(seconds: 1), () {
                          if (Pompes[index]['TimeStart'] ==
                              DateFormat.Hm().format(DateTime.now())) {
                            Pompes[index]['State'] = true;
                          }
                          if (Pompes[index]['TimeEnd'] ==
                              DateFormat.Hm().format(DateTime.now())) {
                            Pompes[index]['State'] = false;
                          }
                        });
                      }

                      settimePompe() {
                        showDialog(
                            context: context,
                            builder: (context) {
                              GlobalKey<FormState> Skey =
                                  GlobalKey<FormState>();
                              return AlertDialog(
                                title: Text('Set Time'),
                                content: Form(
                                    key: Skey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Time to Start',
                                              prefixIcon: Icon(Icons.schedule)),
                                          onSaved: (newValue) {
                                            Pompes[index]['TimeStart'] =
                                                newValue;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Time to End',
                                              prefixIcon: Icon(Icons.schedule)),
                                          onSaved: (newValue) {
                                            Pompes[index]['TimeEnd'] = newValue;
                                          },
                                        )
                                      ],
                                    )),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        if (Skey.currentState!.validate()) {
                                          Skey.currentState!.save();
                                          setState(() {
                                            getdata();
                                            ref
                                                .doc('gml9GRvOKYzmgMzO1lQn')
                                                .update({
                                              'Pompes': Pompes
                                            }).then((value) {
                                              // print(st);
                                              print('update success');
                                            }).catchError((e) {
                                              print('Error : $e');
                                            });
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text('Save'))
                                ],
                              );
                            });
                      }

                      return Card(
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            SwitchListTile(
                                secondary: CircleAvatar(
                                    child:
                                        Image.asset('images/POMPE-icon.jpg')),
                                selected: data['Pompes'][index]['State'],
                                title: Text('${data['Pompes'][index]['Type']}'),
                                value: data['Pompes'][index]['State'],
                                onChanged: (value) {
                                  setState(() {
                                    getdata();
                                    Pompes[index]['State'] = value;
                                    ref.doc('gml9GRvOKYzmgMzO1lQn').update(
                                        {'Pompes': Pompes}).then((value) {
                                      // print(st);
                                      print('update success');
                                    }).catchError((e) {
                                      print('Error : $e');
                                    });
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
                                  if (data['Pompes'][index]['setTime'] ==
                                      true) {
                                    settimePompe();
                                  }
                                },
                                trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        getdata();
                                        Pompes[index]['setTime'] =
                                            !Pompes[index]['setTime'];

                                        ref.doc('gml9GRvOKYzmgMzO1lQn').update(
                                            {'Pompes': Pompes}).then((value) {
                                          // print(st);
                                          print('update success');
                                        }).catchError((e) {
                                          print('Error : $e');
                                        });
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
                                subtitle: Text(
                                    '${data['Pompes'][index]['distributedwater']}'),
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
                            return AlertDialog(
                              title: Text('Set Time'),
                              content: Form(
                                  key: Skey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Time to Start',
                                            prefixIcon: Icon(Icons.schedule)),
                                        onSaved: (newValue) {
                                          Vannes[index]['TimeStart'] = newValue;
                                          print(Vannes[index]['TimeStart']);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Time to End',
                                            prefixIcon: Icon(Icons.schedule)),
                                        onSaved: (newValue) {
                                          Vannes[index]['TimeEnd'] = newValue;

                                          print(Vannes[index]['TimeEnd']);
                                        },
                                      )
                                    ],
                                  )),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      if (Skey.currentState!.validate()) {
                                        Skey.currentState!.save();
                                        setState(() {
                                          getdata();
                                          ref
                                              .doc('gml9GRvOKYzmgMzO1lQn')
                                              .update({'Vannes': Vannes}).then(
                                                  (value) {
                                            // print(st);
                                            print('update success');
                                          }).catchError((e) {
                                            print('Error : $e');
                                          });
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Save'))
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
                              getdata();
                              Vannes[index]['State'] = value;
                              Future.delayed(Duration(seconds: 1), () {
                                if (Vannes[index]['setTime'] = true) {
                                  if (Vannes[index]['TimeStart'] ==
                                      DateFormat.Hm()
                                          .format(DateTime.now())
                                          .toString()) {
                                    Vannes[index]['State'] = true;
                                  } else if (Vannes[index]['TimeEnd'] ==
                                      DateFormat.Hm()
                                          .format(DateTime.now())
                                          .toString()) {
                                    Vannes[index]['State'] = false;
                                  }
                                  print(DateFormat.Hm()
                                      .format(DateTime.now())
                                      .toString());
                                  print(Vannes[index]['State']);
                                }
                              });

                              ref
                                  .doc('gml9GRvOKYzmgMzO1lQn')
                                  .update({'Vannes': Vannes}).then((value) {
                                // print(st);
                                print('update success');
                              }).catchError((e) {
                                print('Error : $e');
                              });
                            });
                          },
                          title: Text(
                              '${data['Vannes'][index]['Type']} ${index + 1}'),
                          secondary: CircleAvatar(
                              child: Image.asset('images/valve.png')),
                        ),
                        ListTile(
                            title: const Text('State'),
                            subtitle: Text(
                                data['Vannes'][index]['State'] == true
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
                                    getdata();
                                    Vannes[index]['setTime'] =
                                        !Vannes[index]['setTime'];

                                    ref.doc('gml9GRvOKYzmgMzO1lQn').update(
                                        {'Vannes': Vannes}).then((value) {
                                      // print(st);
                                      print('update success');
                                    }).catchError((e) {
                                      print('Error : $e');
                                    });
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
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

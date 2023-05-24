import 'package:arosa/scaffold_adds/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User_info extends StatefulWidget {
  const User_info({super.key});

  @override
  State<User_info> createState() => _User_infoState();
}

class _User_infoState extends State<User_info> {
  var ref = FirebaseFirestore.instance
      .collection('users')
      .doc('gml9GRvOKYzmgMzO1lQn');
  GlobalKey<FormState> namechange = GlobalKey<FormState>();
  GlobalKey<FormState> emailchange = GlobalKey<FormState>();
  String username = 'Yasser Eddouche';
  String email = 'eddoucheyasser@gmail.com';
  String password = 'password';
  var un;
  var em;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back))
        ],
      ),
      drawer: const drawer(),
      body: FutureBuilder(
          future: ref.get(),
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
              return ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(data['username']),
                    accountEmail: Text(data['email']),
                    currentAccountPicture: const CircleAvatar(
                        backgroundImage: AssetImage('images/User_default.png')),
                  ),
                  ListTile(
                    title: const Text('Username'),
                    subtitle: Text(data['username']),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Change Username'),
                                content: Form(
                                  key: namechange,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'New Username',
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    textInputAction: TextInputAction.done,
                                    onSaved: (newValue) {
                                      ref.update({'username': newValue});
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please entre your username';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (namechange.currentState!
                                              .validate()) {
                                            namechange.currentState!.save();
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      },
                                      child: const Text('Change'))
                                ],
                              ));
                    },
                  ),
                  ListTile(
                    title: const Text('email'),
                    subtitle: Text(data['email']),
                    leading: const Icon(Icons.email),
                  ),
                  ListTile(
                    title: const Text('Phone'),
                    subtitle: Text(data['phone']),
                    leading: const Icon(Icons.phone),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Change Phone number'),
                                content: Form(
                                  key: namechange,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'New Phone number',
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    textInputAction: TextInputAction.done,
                                    onSaved: (newValue) {
                                      ref.update({'phone': newValue});
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please entre your phone';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (namechange.currentState!
                                              .validate()) {
                                            namechange.currentState!.save();
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      },
                                      child: const Text('Change'))
                                ],
                              ));
                    },
                  ),
                  ListTile(
                    title: const Text('password'),
                    leading: const Icon(Icons.password),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: const Text('Password'),
                                content: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '${data['password']}',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  readOnly: true,
                                  textInputAction: TextInputAction.done,
                                ));
                          });
                    },
                  ),
                ],
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }
}

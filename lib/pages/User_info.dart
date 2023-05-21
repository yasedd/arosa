import 'package:arosa/scaffold_adds/drawer.dart';
import 'package:flutter/material.dart';

class User_info extends StatefulWidget {
  const User_info({super.key});

  @override
  State<User_info> createState() => _User_infoState();
}

class _User_infoState extends State<User_info> {
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
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
            currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('images/User_default.png')),
          ),
          ListTile(
            title: const Text('Username'),
            subtitle: Text(username),
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
                              un = newValue;
                              username = un;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please entre your user name';
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
                                  if (namechange.currentState!.validate()) {
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
            subtitle: Text(email),
            leading: const Icon(Icons.email),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Change Email'),
                        content: Form(
                          key: emailchange,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'New Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email)),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onSaved: (newValue) {
                              em = newValue;
                              email = em;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Fild is empty';
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
                                  if (emailchange.currentState!.validate()) {
                                    emailchange.currentState!.save();
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
            title: const Text('Change password'),
            leading: const Icon(Icons.password),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

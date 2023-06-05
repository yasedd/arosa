import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class drawer extends StatefulWidget {
  const drawer({super.key});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    return Drawer(
      child: FutureBuilder(
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
                  accountName: Text('${data['username']}'),
                  accountEmail: Text('${data['email']}'),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('images/User_default.png'),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pushNamed('Home');
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.content_paste_go_rounded),
                  title: const Text('Controle'),
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pushNamed('State_tools');
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.monitor),
                  title: const Text('Supervision'),
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pushNamed('Supervision');
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Info personnelles'),
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pushNamed('User_info');
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  onTap: () {
                    setState(() {
                      Navigator.of(context).pushNamed('About');
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Déconnexion'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('Login');
                  },
                ),
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

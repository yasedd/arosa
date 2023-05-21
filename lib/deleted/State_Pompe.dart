import 'package:flutter/material.dart';

class State_Pompe extends StatefulWidget {
  const State_Pompe({super.key});

  @override
  State<State_Pompe> createState() => _State_PompeState();
}

class _State_PompeState extends State<State_Pompe> {
  List pompes = [
    {
      'Type': 'Pompe',
      'state': false,
      'Time to Start': '12:30',
      'Time to End': '14:30',
      'distributed water': 0,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State of Pompes'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Yasser Eddouche'),
              accountEmail: Text('yassereddouche@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.amber,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed('Home');
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Personal information'),
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed('User_info');
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed('About');
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                setState(() {
                  Navigator.of(context).pushReplacementNamed('Login');
                });
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: pompes.length,
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.all(15),
          child: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Column(
              children: [
                SwitchListTile(
                    secondary: Icon(Icons.heat_pump_rounded),
                    selected: pompes[index]['state'] == true ? true : false,
                    title: Text('${pompes[index]['Type']}'),
                    value: pompes[index]['state'],
                    onChanged: (value) {
                      setState(() {
                        pompes[index]['state'] = value;
                      });
                    }),
                ListTile(
                  title: Text('State'),
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
                  title: Text('Time'),
                  subtitle: Text(
                      '${pompes[index]['Time to Start']} - ${pompes[index]['Time to End']}'),
                  trailing: Icon(Icons.timer,
                      color: pompes[index]['state'] == true
                          ? Colors.blueAccent
                          : Colors.grey),
                ),
                ListTile(
                  title: Text('Distributed water'),
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
      ),
    );
  }
}

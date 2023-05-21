import 'package:flutter/material.dart';

class State_Valves extends StatefulWidget {
  const State_Valves({super.key});

  @override
  State<State_Valves> createState() => _State_ValvesState();
}

class _State_ValvesState extends State<State_Valves> {
  List valves = [
    {
      'Num of Valve': 1,
      'state': false,
      'O or F': '',
      'Time to Start': '12:30',
      'Time to End': '14:30',
    },
    {
      'Num of Valve': 2,
      'state': false,
      'Time to Start': '12:30',
      'Time to End': '13:30',
    },
    {
      'Num of Valve': 3,
      'state': false,
      'Time to Start': '13:30',
      'Time to End': '14:30',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('State of Valves'),
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
          itemCount: valves.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.all(15),
              child: Column(children: [
                SwitchListTile(
                  value: valves[index]['state'],
                  selected: valves[index]['state'] == true ? true : false,
                  onChanged: (value) {
                    setState(() {
                      valves[index]['state'] = value;
                    });
                  },
                  title: Text('Vanne ${valves[index]['Num of Valve']}'),
                  secondary:
                      CircleAvatar(child: Image.asset('images/valve.png')),
                ),
                ListTile(
                  title: Text('State'),
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
                  title: Text('Time'),
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
        ));
  }
}

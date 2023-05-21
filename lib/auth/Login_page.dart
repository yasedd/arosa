// import 'package:arosa/main.dart';
import 'package:flutter/material.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  var username;
  var password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  login() {
    if (formkey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed('Home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('About');
              },
              icon: const Icon(Icons.help))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              'images/desing_app-removebg.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                      onSaved: (newValue) => username = newValue,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please entre your user name';
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.password),
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSaved: (newValue) => password = newValue,
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Password to week';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                )),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      login();
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Login')),
                const Text('Sign Up Here'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('SignUp');
                    },
                    child: const Text('Sign Up'))
              ],
            )
          ]),
        ]),
      ),
    );
  }
}

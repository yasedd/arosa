import 'package:flutter/material.dart';
// import 'main.dart';

class Signup_page extends StatefulWidget {
  const Signup_page({super.key});

  @override
  State<Signup_page> createState() => _Signup_pageState();
}

class _Signup_pageState extends State<Signup_page> {
  var passconf;
  var username;
  var email;
  var phonenumber;
  var password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  signup() {
    if (formkey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed('Home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                    key: formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person)),
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            username = newValue;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Fild is empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email)),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            email = newValue;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Fild is empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.password)),
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            password = newValue;
                          },
                          validator: (value) {
                            passconf = value;
                            if (value!.length < 6) {
                              return "Weak password";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              labelText: 'Confirmation Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.done)),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value != passconf) {
                              return "Not the Same";
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
                          signup();
                        },
                        icon: const Icon(Icons.app_registration_sharp),
                        label: const Text('Sing Up')),
                    const Text('Login here '),
                    TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.person),
                        label: const Text('Login')),
                    // IconButton(onPressed: () {}, icon: const Icon(Icons.clear))
                  ],
                )
              ],
            ),
          ]),
        ));
  }
}

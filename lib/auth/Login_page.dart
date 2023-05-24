import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  var email;
  var password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  login() async {
    print('$email $password');
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  title: 'Error',
                  desc: 'No user found for that email.')
              .show();
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  title: 'Error',
                  desc: 'Wrong password provided for that user.')
              .show();
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool value = true;
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: 'email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email)),
                      textInputAction: TextInputAction.next,
                      onSaved: (newValue) {
                        email = newValue;
                        // print(newValue);
                      },
                      validator: (value) {
                        if (value!.contains('@') & value.contains('.')) {
                          return null;
                        } else {
                          return 'Not a email adress';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                value = false;
                              });
                            },
                            icon: const Icon(Icons.remove_red_eye)),
                      ),
                      obscureText: value,
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
                    onPressed: () async {
                      UserCredential responce = await login();
                      // ignore: unnecessary_null_comparison
                      if (responce != null) {
                        Navigator.of(context).pushReplacementNamed('Home');
                      } else {
                        print("Login faild ");
                      }
                      print('***************');
                      print(responce);
                      print('***************');
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

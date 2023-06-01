import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../scaffold_adds/alert.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/cover3.jpg'), fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const SizedBox(
              height: 40,
            ),
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(110),
                  image: const DecorationImage(
                      image: AssetImage('images/desing_app.jpg'),
                      fit: BoxFit.cover),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 10)
                  ]),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 20)
                  ]),
              child: Form(
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
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.password),
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
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 20)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      onPressed: () async {
                        UserCredential responce = await login();
                        // ignore: unnecessary_null_comparison
                        if (responce != null) {
                          showloading(context);
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
              ),
            )
          ]),
        ]),
      ),
    );
  }
}

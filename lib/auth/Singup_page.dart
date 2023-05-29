import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../scaffold_adds/alert.dart';

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
  List Pompes = [];
  List Vannes = [];
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  register() async {
    var ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    ref.set({
      'username': username,
      'email': email,
      'phone': phonenumber,
      'userid': FirebaseAuth.instance.currentUser!.uid,
      'Pompes': Pompes,
      'Vannes': Vannes
    });
  }

  signup() async {
    print("$email  $password");
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
                  context: context,
                  title: 'Error',
                  body: const Text('The password provided is too weak.'))
              .show();
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
                  context: context,
                  title: 'Error',
                  body:
                      const Text('The account already exists for that email.'))
              .show();
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Sign up'),
        //   centerTitle: true,
        // ),
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/cover.jpg'), fit: BoxFit.cover),
      ),
      padding: const EdgeInsets.all(20),
      child: ListView(children: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Sign Up',
              style: TextStyle(
                  letterSpacing: 15,
                  wordSpacing: 5,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black, blurRadius: 30)]),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 20)
                  ]),
              child: Form(
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
                        decoration: const InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone)),
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) {
                          phonenumber = newValue;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter your phone number';
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
                            return 'Weak password';
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
                        var response = await signup();
                        // ignore: unnecessary_null_comparison
                        if (response != null) {
                          register();
                          showloading(context);
                          Navigator.of(context).pushNamed('Home');
                        } else {
                          // ignore: use_build_context_synchronously
                          AwesomeDialog(
                                  context: context,
                                  title: 'Error',
                                  desc: 'Sign Up Faild')
                              .show();
                        }

                        print(response.user);
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
                ],
              ),
            )
          ],
        ),
      ]),
    ));
  }
}

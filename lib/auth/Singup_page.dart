import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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
  signup() async {
    print("$email  $password");
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      try {
        // ignore: unused_local_variable
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
            ..show();
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
              context: context,
              title: 'Error',
              body: const Text('The account already exists for that email.'))
            ..show();
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
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.password)),
                          // obscureText: true,
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            password = newValue;
                            // print(newValue);
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
                          // obscureText: true,
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
                        onPressed: () async {
                          var response = await signup();
                          // ignore: unnecessary_null_comparison
                          if (response != null) {
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
                    // IconButton(onPressed: () {}, icon: const Icon(Icons.clear))
                  ],
                )
              ],
            ),
          ]),
        ));
  }
}

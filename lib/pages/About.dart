import 'package:flutter/material.dart';
import 'package:profile/profile.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Profile(
              imageUrl:
                  "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-photo-183042379.jpg",
              name: "Yasser Eddouche",
              website: "",
              designation: "Embedded System Student ",
              email: "eddoucheyasser@gmail.com",
              phone_number: "0655939399",
            ),
          ),
        ],
      ),
    );
  }
}

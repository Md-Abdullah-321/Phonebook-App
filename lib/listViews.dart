import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phonebook/model/ContactModel.dart'; // Adjusted import path

class ListViewsScreen extends StatefulWidget {
  const ListViewsScreen({super.key});

  @override
  State<ListViewsScreen> createState() => _ListViewsScreenState();
}

class _ListViewsScreenState extends State<ListViewsScreen>
    with SingleTickerProviderStateMixin {
  List<ContactModel> contacts = [];
  bool isLoading = false;

  late AnimationController animationController;
  late Animation degOneTranslationAnimation;
  late Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void initState() {
    getContacts();
    animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 250));
    degOneTranslationAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Phonebook App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue[500],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: const TextField(
              decoration: InputDecoration(
                labelText: "Search...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return ContactCard(contact: contacts[index]);
                    },
                  ),
          ),
          SizedBox(
            height: 100, // Specify a height for the container
            child: Stack(
              children: <Widget>[
                Positioned(
                    right: 30,
                    bottom: 30,
                    child: Stack(
                      children: <Widget>[
                        Transform.translate(
                            offset: Offset.fromDirection(
                                getRadiansFromDegree(180),
                                degOneTranslationAnimation.value * 100),
                            child: Transform(
                              transform: Matrix4.rotationZ(
                                  getRadiansFromDegree(rotationAnimation.value))
                                ..scale(degOneTranslationAnimation.value),
                              alignment: Alignment.center,
                              child: CircularButton(
                                color: Colors.red,
                                width: 50,
                                height: 50,
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                onClick: () {},
                              ),
                            )),
                        Transform.translate(
                            offset: Offset.fromDirection(
                                getRadiansFromDegree(225),
                                degOneTranslationAnimation.value * 100),
                            child: Transform(
                                transform: Matrix4.rotationZ(
                                    getRadiansFromDegree(
                                        rotationAnimation.value))
                                  ..scale(degOneTranslationAnimation.value),
                                alignment: Alignment.center,
                                child: CircularButton(
                                  color: Colors.yellow,
                                  width: 50,
                                  height: 50,
                                  icon: const Icon(Icons.camera,
                                      color: Colors.white),
                                  onClick: () {},
                                ))),
                        Transform.translate(
                            offset: Offset.fromDirection(
                                getRadiansFromDegree(270),
                                degOneTranslationAnimation.value * 100),
                            child: Transform(
                                transform: Matrix4.rotationZ(
                                    getRadiansFromDegree(
                                        rotationAnimation.value))
                                  ..scale(degOneTranslationAnimation.value),
                                alignment: Alignment.center,
                                child: CircularButton(
                                  color: Colors.deepOrange,
                                  width: 50,
                                  height: 50,
                                  icon: const Icon(Icons.person,
                                      color: Colors.white),
                                  onClick: () {},
                                ))),
                        Transform(
                            transform: Matrix4.rotationZ(
                                getRadiansFromDegree(rotationAnimation.value)),
                            alignment: Alignment.center,
                            child: CircularButton(
                              color: Colors.blue,
                              width: 60,
                              height: 60,
                              icon: const Icon(Icons.menu, color: Colors.white),
                              onClick: () {
                                if (animationController.isCompleted) {
                                  animationController.reverse();
                                } else {
                                  animationController.forward();
                                }
                              },
                            )),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getContacts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('https://phonebook-api-lhb4.onrender.com/api/user'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final bool success = jsonResponse['success'];

        if (success) {
          final List<dynamic> payload = jsonResponse['payload'];
          final List<ContactModel> fetchedContacts = payload
              .map(
                  (json) => ContactModel.fromJson(json as Map<String, dynamic>))
              .toList();

          setState(() {
            contacts = fetchedContacts;
          });
        } else {
          print('Failed to fetch contacts: ${jsonResponse['message']}');
        }
      } else {
        print('Failed to load contacts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching contacts: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class ContactCard extends StatelessWidget {
  final ContactModel contact;

  const ContactCard({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.blue[50],
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (contact.profile != null)
            Image.network(contact.profile!)
          else
            Container(
              height: 80,
              width: 80,
              child: const Image(
                image: AssetImage('assets/default-user.png'),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${contact.firstName} ${contact.lastName}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
                Text(
                  "Phone: ${contact.phoneNumbers[0].number}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  "Email: ${contact.emailAddresses[0].email}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final VoidCallback onClick;

  const CircularButton({
    Key? key,
    required this.color,
    required this.width,
    required this.height,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(
        icon: icon,
        enableFeedback: true,
        onPressed: onClick,
      ),
    );
  }
}

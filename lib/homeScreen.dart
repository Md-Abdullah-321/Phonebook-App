// home_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phonebook/model/ContactModel.dart'; // Adjusted import path

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ContactModel> contacts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Call getContacts when the widget is initialized
    getContacts();
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
            child: TextField(
              decoration: const InputDecoration(
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
                      return Container(
                        height: 100,
                        color: Colors.blue[50],
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (contacts[index].profile != null)
                                  Image.network(contacts[index].profile!)
                                else
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: const Image(
                                      image:
                                          AssetImage('assets/default-user.png'),
                                    ),
                                  ),
                                Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${contacts[index].firstName}  ${contacts[index].lastName}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Phone: ${contacts[index].phoneNumbers[0].number}",
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        Text(
                                            "Email: ${contacts[index].emailAddresses[0].email}",
                                            style: TextStyle(
                                                color: Colors.grey[600]))
                                      ],
                                    ))
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Method to fetch contacts
  Future<void> getContacts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('https://phonebook-api-lhb4.onrender.com/api/user'));

      if (response.statusCode == 200) {
        // Parse JSON response
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        bool success = jsonResponse['success'];
        String message = jsonResponse['message'];

        if (success) {
          List<dynamic> payload = jsonResponse['payload'];
          List<ContactModel> fetchedContacts =
              payload.map((json) => ContactModel.fromJson(json)).toList();

          setState(() {
            contacts = fetchedContacts;
            isLoading = false;
          });
        } else {
          // Handle failure case
          setState(() {
            isLoading = false;
          });
          print('Failed to fetch contacts: $message');
        }
      } else {
        // Handle other status codes
        setState(() {
          isLoading = false;
        });
        print('Failed to load contacts: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or JSON decoding errors
      setState(() {
        isLoading = false;
      });
      print('Error fetching contacts: $e');
    }
  }
}

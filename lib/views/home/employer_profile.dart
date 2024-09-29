// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class EmployerProfile extends StatelessWidget {
  var listTileShape = RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.grey,
      width: 1,
    ),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text('Company Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {},
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: listTileShape,
              title: const Row(
                children: [Text("Company "), Icon(Icons.business)],
              ),
              subtitle: const Text("BILAT"),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Edit'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              shape: listTileShape,
              title: Row(
                children: [Text("Website "), Icon(Icons.public)],
              ),
              subtitle: Text("BILAT"),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              shape: listTileShape,
              title: Row(
                children: [Text("Phone Number "), Icon(Icons.phone)],
              ),
              subtitle: Text("BILAT"),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              shape: listTileShape,
              title: Row(
                children: [Text("Email "), Icon(Icons.email)],
              ),
              subtitle: Text("BILAT"),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              shape: listTileShape,
              title: Row(
                children: [Text("Industry "), Icon(Icons.factory)],
              ),
              subtitle: Text("BILAT"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.white, // Button color
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Delete Account',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.redAccent, // Button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

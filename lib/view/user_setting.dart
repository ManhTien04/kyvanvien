import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String username = 'Ngô Mạnh Tiến';
  final String email = 'manhtienngo@gmail.com';
  final String balance = '1000000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
      ),
      body: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://example.com/user-profile-image-url'),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(' $username'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Handle edit username
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(' $email'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Handle edit email
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('$balance'),
          ),
        ],
      ),
    );
  }
}
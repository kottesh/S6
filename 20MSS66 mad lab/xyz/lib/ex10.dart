import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class OnBoard extends StatefulWidget {
    const OnBoard({super.key});

    @override
    State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
    final _username = TextEditingController();
    final _password = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    bool _isVisible = true;
    bool _isLogin = true;

    @override
    void dispose() {
        _username.dispose();
        _password.dispose();
        super.dispose();
    }

    void _showMessage(BuildContext context, String content, bool isColorRed) {
        if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(content),
                    backgroundColor: isColorRed ? Colors.red : Colors.green
                )
            );
        }
    }

    Future<File> getDbPath() async {
        final appDocs = await getApplicationDocumentsDirectory();
        return File('${appDocs.path}/users.txt');
    }

    Future<void> _saveUser(BuildContext context, String username, String password) async {
        try {
            final file = await getDbPath();
            if (!await file.exists()) {
                file.create(recursive: true);
            }


            file.writeAsString(
                '${username.trim()}\t${BCrypt.hashpw(password.trim(), BCrypt.gensalt())}\n',
                mode: FileMode.append
            );
        } catch (err) {
            _showMessage(context, 'Error: ${err.toString()}', true);
        }
    }

    Future<bool> _verifyCredentials(BuildContext context, username, String password) async {
        try {
            final file = await getDbPath();

            if (!await file.exists()) {
                _showMessage(context, 'No users found. Register as first person :)', true);
                setState(() {
                    _isLogin = !_isLogin;
                });
                return false;
            }

            final contents = await file.readAsString();
            final records = contents.split('\n');

            for (String record in records) {
                final data = record.split('\t');
                
                if (data[0] == username.trim()) {
                    try {
                        if (BCrypt.checkpw(password.trim(), data[1])) {
                            return true;
                        }
                    } catch (err) {
                        _showMessage(context, 'Error: ${err.toString()}', true);
                    }
                }
            }

            _showMessage(context, 'Invalid username or password', true);
            return false;
        } catch (err) {
            _showMessage(context, 'Error: ${err.toString()}', true);
            return false;
        }
    }

    Future<bool> _checkIfUsernameExists(BuildContext context, String username) async {
        try {
            final file = await getDbPath();

            if (!await file.exists()) {
                return false;
            }

            username = username.trim();

            final contents = await file.readAsString();
            final records = contents
                .split('\n')
                .where((String record) => record.isNotEmpty)
                .toList();

            return records.any((String record) {
                final data = record.split('\t'); 
                return data[0].trim() == username.trim();
            });
        } catch (err) {
            _showMessage(context, 'Error: ${err.toString()}', true);
            return false;
        }
    }

    Future<void> _handleSubmit(BuildContext context) async {      
        if (_isLogin) {
            if (await _verifyCredentials(context, _username.text, _password.text)) {
                _showMessage(context, 'Welcome back! ${_username.text}', false);
            }
        } else {
            if (await _checkIfUsernameExists(context, _username.text)) {
                _showMessage(context, 'Username already exists', true);
            } else {
                await _saveUser(context, _username.text, _password.text);
                _showMessage(context, 'Registration Done!', false);

                setState(() {
                    _isLogin = !_isLogin;
                });
            }
        }       
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(12),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Text(
                                            (_isLogin ? 'Login' : "Register"),
                                            style: TextStyle(
                                                fontFamily: 'Bricolage Grotesque',
                                                fontSize: 28
                                            ),
                                        ),
                                    ],
                                ),

                                const SizedBox(height: 20,),

                                TextFormField(
                                    controller: _username,
                                    decoration: InputDecoration(
                                        labelText: 'Username',
                                        border: OutlineInputBorder() 
                                    ),
                                    validator: (value) {
                                        if (value == null || value.isEmpty) {
                                            return "Username can't be empty";
                                        }
                      
                                        return null;
                                    },
                                ),
                      
                                const SizedBox(height: 12,),
                      
                                TextFormField(
                                    controller: _password,
                                    decoration: InputDecoration(
                                    labelText: 'Password',
                                        border: OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                                setState(() {
                                                    _isVisible = !_isVisible;
                                                });
                                            },
                                            icon: _isVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                                        )
                                    ),
                                    obscureText: _isVisible,
                                    validator: (value) {
                                            if (value == null || value.isEmpty) {
                                                return "Password can't be empty";
                                            }
                                            return null;
                                    },
                                ),

                                const SizedBox(height: 16,),

                                Row(
                                    spacing: 12,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        TextButton(
                                            onPressed: (() {
                                                setState(() {
                                                    _username.clear();
                                                    _password.clear();
                                                    _isLogin = !_isLogin;
                                                });
                                            }),
                                            child: Text(
                                                _isLogin ? 'Need to register ?' : 'Already have an account ?',
                                                style: TextStyle(color: Colors.blueAccent),
                                            ),
                                        ),
                                        ElevatedButton(
                                            onPressed: (() async {
                                                await _handleSubmit(context);
                                            }),
                                            child: Text(_isLogin ? "Login" : "Register"),
                                        )
                                    ],
                                )
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}

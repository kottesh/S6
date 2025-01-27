import 'package:flutter/material.dart';
import 'package:xyz/db/db.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final _formKey = GlobalKey<FormState>();
    bool _isLogin = true;
    bool _isVisible = true;

    final _username = TextEditingController();
    final _password = TextEditingController();
    final db = DB();

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: <Widget>[
                            const Text(
                                'Get Started',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Bricolage Grotesque',
                                ),
                            ),
                            const RotatedBox(
                                quarterTurns: 1,
                                child: Text(
                                    'RISE',
                                    style: TextStyle(
                                        fontFamily: 'Bricolage Grotesque',
                                        fontSize: 10
                                    ),
                                ),
                            )
                        ],
                    ) 
                ),
                body: Center(
                    child: SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(12),
                            alignment: Alignment.center,
                    
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    children: [
                                        TextFormField(
                                            controller: _username,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                label: const Text('Username')
                                            ),
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                    return 'username is empty';
                                                }
                    
                                                return null;
                                            },
                                        ),
                    
                                        const SizedBox(height: 12,),
                    
                                        TextFormField(
                                            controller: _password,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                label: const Text('Pasword'),
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                        setState(() {
                                                            _isVisible = !_isVisible;
                                                        });
                                                    },
                                                    icon: Icon(
                                                        _isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined
                                                    )
                                                ),
                                            ),
                                            obscureText: !_isVisible,
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                    return 'password is empty';
                                                }
                    
                                                return null;
                                            },
                                        ),
                    
                                        const SizedBox(height: 12,),
                    
                                        Row(
                                            mainAxisAlignment : MainAxisAlignment.end,
                                            children: [
                                                TextButton(
                                                    onPressed: () {
                                                        _username.clear();
                                                        _password.clear();
                                                        setState(() {
                                                            _isLogin = !_isLogin;
                                                        });
                                                    },
                                                    child: Text(
                                                        _isLogin ? 'Need to register ?' : 'Already have an account ?'
                                                    )
                                                ),
                    
                                                const SizedBox(
                                                    width: 8,
                                                ),
                    
                                                ElevatedButton(
                                                    onPressed: () async {
                                                        if (_formKey.currentState!.validate()) {
                                                            if (_isLogin) {
                                                                if (await db.authenticateUser(_username.text, _password.text)) {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                            backgroundColor: Colors.green,
                                                                            content: Text('Welcome Back! ${_username.text}'),
                                                                        )
                                                                    );
                                                                } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                            backgroundColor: Colors.red,
                                                                            content: Text('Error occured during login.'),
                                                                        )
                                                                    );
                                                                }
                                                            } else {
                                                                int user_id = await db.addUser(_username.text, _password.text);
                                                                
                                                                if (user_id == -1) {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                            backgroundColor: Colors.red,
                                                                            content: Text('Error occured during registration.'),
                                                                        )
                                                                    );
                                                                } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                            backgroundColor: Colors.green,
                                                                            content: Text('Registered. Login now!'),
                                                                        )
                                                                    );
                                                                    setState(() {
                                                                        _isLogin = !_isLogin;
                                                                    });
                                                                }
                                                            }
                                                        }
                                                    },
                                                    child: Text(
                                                        _isLogin ? 'Login' : 'Register',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                    )
                                                )
                                            ],
                                        )
                                    ],
                                ),
                            )
                        ),
                    ),
                ),
            ),
        );
    }
}

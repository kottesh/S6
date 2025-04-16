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

    void _showMessage(BuildContext context, String message, Color color) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: color,
                content: Text(message),
            )
        );
    } 

    Future<void> _handleSubmit(BuildContext context) async {
        if (_formKey.currentState!.validate()) {
            if (_isLogin) {
                if (await db.authenticateUser(_username.text, _password.text)) {
                    _showMessage(context, 'Welcome Back! ${_username.text}', Colors.green);
                } else {
                    _showMessage(context, 'Error occured during login.', Colors.red);
                }
            } else {
                int user_id = await db.addUser(_username.text, _password.text);
                                                                
                if (user_id == -1) {
                    _showMessage(context, 'Error occured during registration', Colors.red);
                } else {
                    _showMessage(context, 'Registerd. Login now!', Colors.green);
                    setState(() {
                        _isLogin = !_isLogin;
                    });
                }
            }
        }
    }

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
                                                    return 'Username is empty';
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
                                                    return 'Password is empty';
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
                                                        setState(() {
                                                            _username.clear();
                                                            _password.clear();
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
                                                        await _handleSubmit(context);
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

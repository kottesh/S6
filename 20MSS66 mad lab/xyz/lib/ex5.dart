import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Opener extends StatefulWidget {
   const Opener({super.key});

  @override
  State<Opener> createState() => _OpenerState();
}

class _OpenerState extends State<Opener> {
    final _phoneController = TextEditingController();

    final _messageController = TextEditingController();

    final _siteController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    @override
    void dispose() {
        _phoneController.dispose();
        _messageController.dispose();
        _siteController.dispose();
        super.dispose();
    }

    String? validatePhoneNumber(String? value) {
        if (value == null || value.isEmpty) {
            return 'Enter a valid number.';
        }

        if (10 - value.length != 0) {
            return 'Check ${10 - value.length} digit missing';
        } 

        return null;
    }

    Future<void> _doAction(BuildContext context, final uri) async {
        try {
            if (!await launchUrl(uri)) {
                if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Something went wrong'),
                            backgroundColor: Colors.redAccent,
                        )
                    );
                }
            }
        } catch (error) {
            if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error: ${error.toString()}'),
                        backgroundColor: Colors.redAccent,
                    )
                );
            }
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 16,
                        children: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                    _phoneController.clear();
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                            return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                                                    top: 12, left: 12, right: 12
                                                ),
                                                child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                        Form(
                                                            key: _formKey,
                                                            child: TextFormField(
                                                                controller: _phoneController,
                                                                decoration: InputDecoration(
                                                                    border: OutlineInputBorder(),
                                                                    label: const Text('Phone Number'),
                                                                    hintText: 'eg. 12345 54321',
                                                                ),
                                                                keyboardType: TextInputType.number,
                                                                inputFormatters: [
                                                                    FilteringTextInputFormatter.digitsOnly,
                                                                    LengthLimitingTextInputFormatter(10)
                                                                ],
                                                                validator: validatePhoneNumber,
                                                            ),
                                                        ),

                                                        SizedBox(height: 14,),

                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            spacing: 12,
                                                            children: [
                                                                ElevatedButton(
                                                                    onPressed: () => Navigator.pop(context), 
                                                                    child: const Text('Cancel') 
                                                                ),
                                                                ElevatedButton(
                                                                    onPressed: () async {
                                                                        if (_formKey.currentState!.validate()) {
                                                                            Navigator.pop(context);
                                                                            ScaffoldMessenger
                                                                                .of(context)
                                                                                .showSnackBar(SnackBar(
                                                                                    content: Text('Calling ${_phoneController.text}'),
                                                                                    duration: Duration(seconds: 1),
                                                                                    backgroundColor: Colors.greenAccent,
                                                                                ));
                                                                            await _doAction(context, Uri.parse('tel:${_phoneController.text}'));
                                                                        }
                                                                    }, 
                                                                    child: const Text('Call'),
                                                                )
                                                            ],
                                                        ) 
                                                    ]
                                                ),
                                            );
                                        }
                                    ); 
                                },
                                child: Icon(
                                    CupertinoIcons.device_phone_portrait,
                                    color: Colors.blueGrey[700],
                                ) 
                            ),
                            ElevatedButton(
                                onPressed: () {
                                    _phoneController.clear();
                                    _messageController.clear();
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                            return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                                                    top: 12, left: 12, right: 12
                                                ),
                                                child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                        Form(
                                                            key: _formKey,
                                                            child: Column(
                                                                children: [
                                                                    TextFormField(
                                                                        controller: _phoneController,
                                                                        decoration: InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            label: const Text('Phone Number'),
                                                                            hintText: 'eg. 12345 54321',
                                                                        ),
                                                                        keyboardType: TextInputType.number,
                                                                        inputFormatters: [
                                                                            FilteringTextInputFormatter.digitsOnly,
                                                                            LengthLimitingTextInputFormatter(10)
                                                                        ],
                                                                        validator: validatePhoneNumber,
                                                                    ),

                                                                    SizedBox(height: 14,),

                                                                    TextFormField(
                                                                        controller: _messageController,
                                                                        decoration: InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            label: const Text('Message'),
                                                                            hintText: 'type your message here.',
                                                                        ),
                                                                        validator: (value) {
                                                                            if (value == null || value.isEmpty) {
                                                                                return 'Message can\'t be empty';
                                                                            }
                                                                            return null;
                                                                        },
                                                                    )
                                                                ],
                                                            )
                                                        ),

                                                        SizedBox(height: 14,),

                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            spacing: 12,
                                                            children: [
                                                                ElevatedButton(
                                                                    onPressed: () => Navigator.pop(context), 
                                                                    child: const Text('Cancel') 
                                                                ),
                                                                ElevatedButton(
                                                                    onPressed: () async {
                                                                        if (_formKey.currentState!.validate()) {
                                                                            Navigator.pop(context);
                                                                            ScaffoldMessenger
                                                                                .of(context)
                                                                                .showSnackBar(SnackBar(
                                                                                    content: Text('Sending Message.'),
                                                                                    backgroundColor: Colors.greenAccent,
                                                                                    duration: Duration(seconds: 1),
                                                                                ));
                                                                            await _doAction(context, Uri.parse('sms:${_phoneController.text}?body=${_messageController.text}'));
                                                                        }
                                                                    }, 
                                                                    child: const Text('Send'),
                                                                )
                                                            ],
                                                        ) 
                                                    ]
                                                ),
                                            );
                                        }
                                    ); 
                                },
                                child: Icon(
                                    CupertinoIcons.text_bubble,
                                    color: Colors.blueGrey[700],
                                )
                            ),
                            ElevatedButton(
                                onPressed: () {
                                    _siteController.clear();
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                            return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                                                    top: 12, left: 12, right: 12
                                                ),
                                                child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                        Form(
                                                            key: _formKey,
                                                            child: Column(
                                                                children: [
                                                                    TextFormField(
                                                                        controller: _siteController,
                                                                        decoration: InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            label: const Text('URL'),
                                                                            hintText: 'https://example.com',
                                                                        ),
                                                                        validator: (value) {
                                                                            if (value == null || value.isEmpty) {
                                                                                return 'No URL found.';
                                                                            }

                                                                            if (!RegExp(r'^(http|https):\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?$').hasMatch(value)) {
                                                                                return 'Enter a valid URL starting with http:// or https://';
                                                                            }

                                                                            return null;
                                                                        },
                                                                    )
                                                                ],
                                                            )
                                                        ),

                                                        SizedBox(height: 14,),

                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            spacing: 12,
                                                            children: [
                                                                ElevatedButton(
                                                                    onPressed: () => Navigator.pop(context), 
                                                                    child: const Text('Cancel') 
                                                                ),
                                                                ElevatedButton(
                                                                    onPressed: () async {
                                                                        if (_formKey.currentState!.validate()) {
                                                                            Navigator.pop(context);
                                                                            ScaffoldMessenger
                                                                                .of(context)
                                                                                .showSnackBar(SnackBar(
                                                                                    content: Text('Opening site ${_siteController.text}.'),
                                                                                    backgroundColor: Colors.greenAccent,
                                                                                    duration: Duration(seconds: 1),
                                                                                ));
                                                                            await _doAction(context, Uri.parse(_siteController.text));
                                                                        }
                                                                    }, 
                                                                    child: const Text('Open'),
                                                                )
                                                            ],
                                                        ) 
                                                    ]
                                                ),
                                            );
                                        }
                                    ); 
                                },
                                child: Icon(
                                    CupertinoIcons.arrow_up_right,
                                    color: Colors.blueGrey[700],
                                ) 
                            )
                        ],
                    ),
                ),
            ),
        );
    }
}

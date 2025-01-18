import 'package:flutter/material.dart';

class DisplayHello extends StatefulWidget {
    const DisplayHello({super.key});

    @override
    DisplayHelloState createState() => DisplayHelloState();
}

class DisplayHelloState extends State<DisplayHello> {
    final textController = TextEditingController();

    String? greeting = ''; 

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        Expanded(
                            child: Center(
                                child: Text(
                                    greeting as String,
                                    style: TextStyle(
                                        fontFamily: 'Bricolage Grotesque',
                                        fontSize: 18
                                    ),
                                ),
                            )
                        ),
                        TextField(
                            controller: textController,
                            decoration: InputDecoration(
                                hintText: 'Enter your name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                        color: Colors.amber.shade200
                                    )
                                )   
                            ),
                        ),
                        MaterialButton(
                            color: Colors.amberAccent[100],
                            onPressed: () {
                                setState(() {
                                    greeting = 'Hi 👋🏻, ${textController.text}';
                                });
                            }, 
                            child: Text('Show'),
                        )
                    ]
                ),
            )
        );
    }
}

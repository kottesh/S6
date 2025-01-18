import 'package:flutter/material.dart';

class Hello extends StatelessWidget {
    const Hello({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Text(
                    'Hiya 👋🏻',
                    style: TextStyle(
                        fontFamily: 'Bricolage Grotesque',
                        fontSize: 18
                    ),
                ),
            )
        );
    }
}

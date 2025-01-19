import 'package:flutter/material.dart';

import 'package:xyz/ex1.dart';
import 'package:xyz/ex2.dart';
import 'package:xyz/ex3.dart';
import 'package:xyz/ex4.dart';

void main() {
    runApp(
        MaterialApp(
            theme: ThemeData(
                fontFamily: 'DM Sans',
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.greenAccent,
                    surface: Colors.white,
                    error: Colors.redAccent[200],
                    onTertiary: Colors.deepOrangeAccent 
                ),
            ),
            home: Phone(),
        )
    );
}

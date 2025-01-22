import 'package:flutter/material.dart';
import 'package:xyz/ex10.dart';

// void main() {
//     runApp(
//         MaterialApp(
//             theme: ThemeData(
//                 fontFamily: 'DM Sans',
//                 useMaterial3: true,
//                 colorScheme: ColorScheme.fromSeed(
//                     seedColor: Colors.lightGreen,
//                     surface: Colors.white,
//                     error: Colors.redAccent[200],
//                     onTertiary: Colors.deepOrangeAccent 
//                 ),
//             ),
//             home: Login(),
//         )
//     );
// }

void main() {
    runApp(
        MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: 'DM Sans',
                useMaterial3: true
            ),
            home: OnBoard()
        )
    );
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Infos extends StatefulWidget {
  const Infos({super.key});

  @override
  State<Infos> createState() => _InfosState();
}

class _InfosState extends State<Infos> {
    final _formKey = GlobalKey<FormState>();

    String username = '';
    String password = '';
    String address = '';
    String gender = '';
    int? age;
    DateTime? dob;
    String state = '';

    bool show = false;

    final List<String> states = [
        'Andhra Pradesh',
        'Arunachal Pradesh',
        'Assam',
        'Bihar',
        'Chhattisgarh',
        'Goa',
        'Gujarat',
        'Haryana',
        'Himachal Pradesh',
        'Jharkhand',
        'Karnataka',
        'Kerala',
        'Madhya Pradesh',
        'Maharashtra',
        'Manipur',
        'Meghalaya',
        'Mizoram',
        'Nagaland',
        'Odisha',
        'Punjab',
        'Rajasthan',
        'Sikkim',
        'Tamil Nadu',
        'Telangana',
        'Tripura',
        'Uttar Pradesh',
        'Uttarakhand',
        'West Bengal',
        // Union Territories
        'Andaman and Nicobar Islands',
        'Chandigarh',
        'Dadra and Nagar Haveli and Daman and Diu',
        'Delhi',
        'Jammu and Kashmir',
        'Ladakh',
        'Lakshadweep',
        'Puducherry',
    ];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                backgroundColor: Colors.greenAccent[100],
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                            'Infos',
                            style: TextStyle(
                                fontFamily: 'Bricolage Grotesque',
                            ),
                        ),
                        RotatedBox(
                            quarterTurns: 1,
                            child: Text(
                                'Clan X',
                                style: TextStyle(
                                    fontFamily: 'Bricolage Grotesque',
                                    fontSize: 14
                                ),
                            ),
                        )
                    ],
                )
            ), 
            body: Padding(
                padding: EdgeInsets.all(12),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Username',
                                    border: OutlineInputBorder() 
                                ),
                                onChanged: (value) => username = value,
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                        return 'don\'t you have any name';
                                    }
                                    return null;
                                },
                            ),

                            const SizedBox(height: 16),

                            TextFormField( obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    border: OutlineInputBorder()
                                ),
                                onChanged: (value) => password = value,
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                        return 'where is the password';
                                    }
                                    return null;
                                },
                            ),

                            const SizedBox(height: 16),

                            TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Address',
                                    border: OutlineInputBorder()
                                ),
                                maxLines: 4,
                                onChanged: (value) => address = value,
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                        return 'don\'t you live anywhere, are you dead ?';
                                    }
                                    return null;
                                },
                            ),

                            const  SizedBox(height: 12),

                            const Text(
                                'Gender',
                                style: TextStyle(fontSize: 14)
                            ),
                            Row(
                                children: [
                                    Radio<String>(
                                        value: 'Male',
                                        groupValue: gender,
                                        onChanged: (value) {
                                            setState(() {
                                                gender = value as String;
                                            });
                                        }
                                    ),
                                    const Text('Male'),
                                    Radio<String>(
                                        value: 'Female',
                                        groupValue: gender,
                                        onChanged: (value) {
                                            setState(() {
                                                gender = value as String;
                                            });
                                        }
                                    ),
                                    const Text('Female'),
                                    Radio<String>(
                                        value: 'Prefer not to say',
                                        groupValue: gender,
                                        onChanged: (value) {
                                            setState(() {
                                                gender = value as String;
                                            });
                                        }
                                    ),
                                    const Text('Prefer not to say'),
                                ]
                            ),

                            const  SizedBox(height: 12),

                            TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Age',
                                    border: OutlineInputBorder()
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => age = int.tryParse(value) ?? 0,
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                        return 'what is your age';
                                    }
                                    if (int.tryParse(value) !> 100) {
                                        return 'what the fish, what do you eat to live this long...';
                                     }
                                    return null;
                                },
                            ),

                            const  SizedBox(height: 12),

                            InkWell(
                                onTap: () async {
                                    final DateTime? pick = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime.now()
                                    );
                                    if (pick != null) {
                                        setState(() {
                                            dob = pick;
                                        });
                                    }
                                },
                                child: InputDecorator(
                                    decoration: const InputDecoration(
                                        labelText: 'DOB',
                                        border: OutlineInputBorder()
                                    ), 
                                    child: Text(
                                        dob == null ? 'Select Date' : '${dob!.day}-${dob!.month}-${dob!.year}' 
                                    ),
                                ),
                            ),

                            const  SizedBox(height: 12),

                            DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: 'Select state',
                                    border: OutlineInputBorder()
                                ),
                                items: states.map(
                                    (String value) {
                                        return DropdownMenuItem(
                                            value: value,
                                            child: Text(value)  
                                        );
                                    }
                                ).toList(),
                                onChanged: (value) {
                                    setState(() {
                                        state = value as String;
                                    });
                                } 
                            ),

                            const  SizedBox(height: 12),

                            Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                            setState(() {
                                                show = true;
                                            });
                                        }
                                    },
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center, children: [
                                            Text(
                                                'go',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Bricolage Grotesque'
                                                ),
                                            ),
                                            SizedBox(width: 8,),
                                            Icon(
                                                CupertinoIcons.checkmark_seal_fill,
                                                size: 14,
                                            ),

                                        ],
                                    ),
                                ),
                            ),
                            if (show) ...[
                                const SizedBox(height: 24,),

                                Divider(
                                    color: Colors.blueGrey.shade200,
                                    height: 8,
                                ),

                                Text(
                                    'your infos.',
                                    style: TextStyle(
                                        fontFamily: 'Bricolage Grotesque',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        color: Colors.blueGrey[300]
                                    ),
                                ),

                                const SizedBox(height: 12,),

                                Text('Username: $username'),
                                Text('Password: ${password.replaceAll(RegExp(r'.'), '*')}'),
                                Text('Address: $address'),
                                Text('Gender: $gender'),
                                Text('Age: $age'),
                                Text('Date of Birth: ${dob == null ? 'N/A' : DateFormat('dd/MM/yyyy').format(dob as DateTime)}'),
                                Text('State: $state'),
                            ]
                        ],
                    ) 
                ),
            )
        );
    }
}

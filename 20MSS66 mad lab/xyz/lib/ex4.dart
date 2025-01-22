import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Phone extends StatefulWidget {
    const Phone({super.key});

    @override
    State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
    List<String> areaCodes = ['040', '041', '050', '0400', '04'];

    final _formKey = GlobalKey<FormState>();
    final _phoneController = TextEditingController();
    bool isValid = false;
    String? errMsg;

    String? validatePhNumber(String? phone) {
        if (phone == null || phone.isEmpty) {
            return 'Enter a valid phone number.';
        }

        phone = phone.replaceAll(' ', '');

        bool hasValidCode = false;
        int remLen = 0;

        for (String areaCode in areaCodes) {
            if (phone.startsWith(areaCode)) {
                hasValidCode = true;
                remLen = phone.length - areaCode.length;
                break;
            }
        }

        if (!hasValidCode) {
            return "Invalid area code. Use 040, 041, 050, 0400, or 04";
        }

        if (remLen < 6 || remLen > 8) {
            return 'Number should have 6-8 digits after area code';
        }

        return null;
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: ElevatedButton(
                    onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: false,
                            context: context,
                            builder: (BuildContext context) {
                                return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 14,
                                        left: 14,
                                        right: 14, 
                                        top: 14
                                    ),

                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                TextFormField(
                                                    controller: _phoneController,
                                                    decoration: InputDecoration(
                                                        labelText: 'Phone Number',
                                                        hintText: 'e.g., 040 123 4567', 
                                                        border: const OutlineInputBorder(),
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    validator: validatePhNumber,
                                                    inputFormatters: [
                                                        FilteringTextInputFormatter.digitsOnly,
                                                        LengthLimitingTextInputFormatter(12)
                                                    ],
                                                ),

                                                const SizedBox(height: 16,),

                                                Row(
                                                    mainAxisAlignment:MainAxisAlignment.end,
                                                    children: [
                                                        TextButton(
                                                            onPressed: () {
                                                                Navigator.pop(context);
                                                            },
                                                            child: const Text('Cancel') 
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                                if (_formKey.currentState!.validate()) {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(
                                                                            content: Text('Valid Phone Number: ${_phoneController.text}'),
                                                                            backgroundColor: Colors.green,
                                                                        )
                                                                    );
                                                                    Navigator.pop(context);
                                                                }
                                                            },
                                                            child: const Icon(
                                                                Icons.check_circle,
                                                                color: Colors.greenAccent,
                                                            ),
                                                        ),
                                                    ],
                                                )
                                            ],
                                        ),
                                    )
                                );
                            }
                        );
                    },
                    child: Icon(
                        Icons.phone_android,
                        color: Colors.blueGrey[400],
                        size: 24,
                    )
                ),
            ) 
        );
    }
}

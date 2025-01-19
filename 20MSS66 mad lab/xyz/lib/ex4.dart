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
    bool isValid = false;
    String? errMsg;

    void validatePhNumber(String phone) {
        setState(() {
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
                errMsg = "invalid area code.";
                return;
            }

            if (remLen < 6 || remLen > 8) {
                errMsg = 'invalid length phone number.';
                return;
            }
        });
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
                                        bottom: MediaQuery.of(context).viewInsets.bottom,
                                        left: 14,
                                        right: 14, 
                                        top: 14
                                    ),

                                    child: Container(
                                        padding: EdgeInsets.only(bottom: 20),

                                        child: Form(
                                            key: _formKey,
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                    TextFormField(
                                                        decoration: InputDecoration(
                                                            labelText: 'Phone Number',
                                                            hintText: 'e.g., 0401234567', 
                                                            border: const OutlineInputBorder(),
                                                        ),
                                                        keyboardType: TextInputType.number,
                                                        validator: (value) {
                                                            validatePhNumber(value as String);
                                                            if (errMsg != null) {
                                                                return errMsg;
                                                            } else {
                                                                return 'phone number is ok!';
                                                            }
                                                        },
                                                        inputFormatters: [
                                                            FilteringTextInputFormatter.digitsOnly,
                                                            LengthLimitingTextInputFormatter(12)
                                                        ],
                                                    ),

                                                    const SizedBox(height: 16,),

                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            shape: const CircleBorder(),
                                                            padding: EdgeInsets.all(14)
                                                        ),
                                                        onPressed: () {
                                                            if (_formKey.currentState!.validate()) {
                                                                Navigator.pop(context);
                                                            }
                                                        },
                                                        child: const Icon(
                                                            Icons.check_circle,
                                                            color: Colors.greenAccent,
                                                        ),
                                                    )
                                                ],
                                            ),
                                        )
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

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Natureofbussiness extends StatefulWidget {
  const Natureofbussiness({Key? key}) : super(key: key);

  @override
  State<Natureofbussiness> createState() => _NatureofbussinessState();
}

class _NatureofbussinessState extends State<Natureofbussiness> {
  String? gender;

  @override
  Widget build(BuildContext context) {
    return ViewItem(context);
  }

  ViewItem(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        // <-- SEE HERE
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      )),
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            Image.asset(
              'assets/hori_line.png',
              width: 150,
              height: 5,
            ),
            const SizedBox(height: 5),
            const Center(
              child: Text('Select Nature of Business',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')),
            ),
            RadioListTile(
              title: const Text("Manufacturer",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')),
              value: "Manufacturer",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text("Importer",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')),
              value: "Importer",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text("Exporter",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')),
              value: "Exporter",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text("Male",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')),
              value: "male",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text("Wholesaler",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')),
              value: "Wholesaler",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text("Distributor",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')),
              value: "Distributor",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text("Retailer",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')),
              value: "Retailer",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  Fluttertoast.showToast(msg: 'hello$gender');
                  gender = value.toString();
                });
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1.2,
              height: 60,
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(50.0),
                color: const Color.fromARGB(255, 0, 91, 148)),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Update',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

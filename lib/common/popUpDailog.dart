import 'dart:async';
import 'package:flutter/material.dart';

class CommanDialog extends StatelessWidget {
  String title;
  String content;
  VoidCallback onPressed;

  CommanDialog({super.key,
      required this.content,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      insetPadding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'assets/fonst/Metropolis-Black.otf')
                .copyWith(fontSize: 20),
          ),
          const Divider(color: Colors.black26),
          const SizedBox(
            height: 20,
          ),
          Text(
            content,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'assets/fonst/Metropolis-Black.otf')
                .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 45,
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(255, 0, 91, 148),
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); //
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 0, 91, 148),
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 45,
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(50.0),
                  color: const Color.fromARGB(255, 0, 91, 148),
                ),
                child: TextButton(
                  onPressed: onPressed,
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

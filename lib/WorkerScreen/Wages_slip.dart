import 'package:flutter/material.dart';

class WagesSlip extends StatefulWidget {
  const WagesSlip({super.key});

  @override
  State<WagesSlip> createState() => _WagesSlipState();
}

class _WagesSlipState extends State<WagesSlip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wages Slip',
          style: TextStyle(
            fontSize: (MediaQuery.of(context).size.width * 0.045).clamp(
              16.0,
              20.0,
            ),
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: const Column(children: [

        ],
      ),
    );
  }
}

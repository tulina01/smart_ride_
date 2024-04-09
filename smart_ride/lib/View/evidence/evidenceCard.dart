import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EvidenceCard extends StatefulWidget {
  const EvidenceCard({super.key});

  @override
  State<EvidenceCard> createState() => _EvidenceCardState();
}

class _EvidenceCardState extends State<EvidenceCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1.0, color: Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kandy to colombo"),
                  Image.network(
                    "https://picsum.photos/170/100",
                    width: 170,
                    height: 100,
                  )
                ],
              ),
              Column(
                children: [
                  const Text("75kmh"),
                  new CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 12.0,
                    animation: true,
                    percent: 0.7,
                    center: new Text(
                      "70.0%",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: new Text(
                        "Risk Ride",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: Colors.blue,
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

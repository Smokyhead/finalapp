import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ConsultationCard extends StatelessWidget {
  const ConsultationCard(
      {super.key,
      required this.doctorImageUrl,
      required this.doctorFirstName,
      required this.date,
      required this.time,
      required this.doctorLastName});
  final String doctorImageUrl;
  final String doctorFirstName;
  final String doctorLastName;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 165,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0.005,
              blurRadius: 10,
            )
          ],
          color: kPrimaryLightColor,
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 0.005,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade400,
                    radius: 25,
                    backgroundImage:
                        const AssetImage("assets/images/avatar.jpg"),
                    foregroundImage: Doctor.imageUrl.isEmpty
                        ? null
                        : NetworkImage(doctorImageUrl),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      time,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      date,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$doctorFirstName $doctorLastName",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      IconlyBold.call,
                      size: 18,
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 7.5,
                ),
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      IconlyBold.delete,
                      size: 18,
                    ),
                    color: Colors.white,
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                CircleAvatar(
                  radius: 17,
                  backgroundColor: kPrimaryColor,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                    ),
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String username;

  const Header({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        Text(
          "Hi $username!",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
         CircleAvatar(
          radius:  28,
          backgroundColor: Colors.grey,
          child:  Container(
           
            decoration: BoxDecoration(
             
              borderRadius: BorderRadius.circular(18),
              image: const DecorationImage(
                image: NetworkImage("https://scontent.cdninstagram.com/v/t51.2885-19/403804288_298404726428890_3095377741445273576_n.jpg?stp=dst-jpg_s150x150_tt6&_nc_cat=105&ccb=1-7&_nc_sid=f7ccc5&_nc_ohc=-aSh1_NIW2UQ7kNvwGzQBbC&_nc_oc=AdlFCls0W8S4xa4GGg3603GN8p_-45Q_ZoVNxmY4quCPSVU6u1AKnEtYeDaV46IHDPI&_nc_ad=z-m&_nc_cid=1360&_nc_zt=24&_nc_ht=scontent.cdninstagram.com&oh=00_AfF3kU_U-W99ApDUOJnmlQpiQqpwsFVs6McSkarcNMJaHg&oe=6809F595"),
                fit: BoxFit.cover,
              ),
            ),)
            
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/global.colors.dart';

class SocialSignup extends StatelessWidget {
  const SocialSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            '-Or sign up with-',
            style: TextStyle(
              color: GlobalColor.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            // Google
            Expanded(
                child: Container(
              alignment: Alignment.center,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ]),
              child: SvgPicture.asset(
                'assets/images/Google_logo.svg',
                height: 30,
              ),
            )),
            // Facebook
            Expanded(
                child: Container(
              alignment: Alignment.center,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ]),
              child: SvgPicture.asset(
                'assets/images/facebook logo.svg',
                height: 30,
              ),
            )),
            // twitter
            Expanded(
                child: Container(
              alignment: Alignment.center,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ]),
              child: SvgPicture.asset(
                'assets/images/twitter_new_logo.svg',
                height: 30,
              ),
            ))
          ],
        ),
      ],
    );
  }
}

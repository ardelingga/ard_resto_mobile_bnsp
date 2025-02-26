import 'package:flutter/material.dart';

import 'package:ard_resto_mobile_bnsp/data/constants/app_colors.dart';

class RatingRestoDetailComponent extends StatelessWidget {
  const RatingRestoDetailComponent({
    super.key,
    required this.totalStars,
  });

  final double totalStars;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Text(
            'Rating',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          const Spacer(),
          Row(
            children: _buildStars(),
          ),

        ],
      ),
    );
  }
  List<Widget> _buildStars() {
    double validStars = totalStars.clamp(0, 5);
    int fullStars = validStars.floor();
    bool hasHalfStar = (validStars - fullStars) >= 0.5;
    List<Widget> stars = List.generate(
      fullStars,
          (index) => const Icon(Icons.star_rounded, color: Color(0xFFFFC107)),
    );
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half_rounded, color: Color(0xFFFFC107)));
    }
    while (stars.length < 5) {
      stars.add(const Icon(Icons.star_outline_rounded, color: Color(0xFFFFC107)));
    }
    return stars;
  }

}

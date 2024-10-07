import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BalanceDisplay extends StatelessWidget {
  final String? balance;
  final double? width;
  final double? height;

  const BalanceDisplay({
    super.key,
    this.balance,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: balance == null
          ? Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width ?? 35,
          height: height ?? 25,
          color: Colors.grey,
        ),
      )
          : Text(
        "₹${balance!}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
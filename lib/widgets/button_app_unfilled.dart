import 'package:flutter/widgets.dart';
import 'package:xnusa_mobile/constant/constant.dart';

class ButtonAppUnfilled extends StatelessWidget {
  const ButtonAppUnfilled({
    super.key,
    required this.onTap,
    required this.title,
  });

  final Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.symmetric(vertical: SizeApp.customHeight(6)),
        // width: double.infinity,
        decoration: BoxDecoration(
          // color: ColorApp.primary,
          border: Border.all(color: ColorApp.grey),
          borderRadius: BorderRadius.circular(SizeApp.h8),
        ),
        child: Center(
          child: Text(
            title,
            style: TypographyApp.textLight.copyWith(color: ColorApp.primary),
          ),
        ),
      ),
    );
  }
}

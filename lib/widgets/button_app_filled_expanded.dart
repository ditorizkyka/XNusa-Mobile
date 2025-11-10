import 'package:flutter/widgets.dart';
import 'package:xnusa_mobile/constant/constant.dart';

class ButtonAppFilledExpanded extends StatelessWidget {
  const ButtonAppFilledExpanded({
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
        padding: EdgeInsets.symmetric(vertical: SizeApp.h12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorApp.primary,
          borderRadius: BorderRadius.circular(SizeApp.h8),
        ),
        child: Center(child: Text(title, style: TypographyApp.textLight)),
      ),
    );
  }
}

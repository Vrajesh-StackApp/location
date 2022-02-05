import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/app/theme/app_theme.dart';

class CommonLoader extends StatelessWidget {
  final Color? color;
  final double? size;

  const CommonLoader({Key? key,this.size,this.color = AppTheme.colorPrimary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitDoubleBounce(
        color: color,
        size: size ?? 40.0,
      ),
    );
  }
}

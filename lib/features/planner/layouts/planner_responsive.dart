import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'desktop_layout.dart';
import 'mobile_landscape_layout.dart';
import 'mobile_portrait_layout.dart';


class PlannerResponsive extends ConsumerWidget {
  const PlannerResponsive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    if (width < 576) {
      return PlannerMobilePortrait(ref: ref);
    } else if (width < 992) {
      // Se siamo in landscape ma ancora su un dispositivo stretto, usa comunque un layout mobile
      if (orientation == Orientation.landscape) {
        return PlannerMobileLandscape(ref: ref);
      } else {
        return PlannerMobilePortrait(ref: ref);
      }
    } else {
      return PlannerDesktop(ref: ref);
    }
  }
}

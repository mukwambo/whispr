import 'package:flutter/material.dart';

import 'package:whispr/core/theme/app_colors.dart';

/// A back button with no surrounding chrome - transparent, no elevation,
/// no title - for screens reached via `context.push` that should still
/// feel like the plain form pages they sit on top of.
///
/// A plain widget (not `extends AppBar`) so it can read `context.appColors`
/// at build time - the icon's muted gray differs between light and dark
/// mode, so it can't be baked in as a compile-time constant.
class QuietBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuietBackAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: BackButton(color: context.appColors.inkMuted),
    );
  }
}

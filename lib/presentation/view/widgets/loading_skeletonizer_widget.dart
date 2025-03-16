import 'package:asset_tracker/core/config/constants/string_constant.dart';
import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
class LoadingSkeletonizerWidget extends StatelessWidget {
  const LoadingSkeletonizerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Skeletonizer(
        child: SizedBox(
          width: ResponsiveSize(context).screenWidth / 1.1,
          height: ResponsiveSize(context).screenHeight / 1.5,
          child: const Column(
            children: [
              SkeletonListTileWidget(),
              SkeletonListTileWidget(),
              SkeletonListTileWidget(),
              SkeletonListTileWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonListTileWidget extends StatelessWidget {
  const SkeletonListTileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(DefaultLocalStrings.censoredText),
      subtitle: const Text(DefaultLocalStrings.censoredText),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
      ),
    );
  }
}

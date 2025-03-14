import 'package:asset_tracker/core/config/theme/extension/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
class LoadingSkeletonizerWidget extends StatelessWidget {
  const LoadingSkeletonizerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Skeletonizer(
        child: SizedBox(
          width: ResponsiveSize(context).screenWidth / 1.1,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) => Card(
              
              child: ListTile(
                title: const Text("**********"),
                subtitle: const Text("**********"),
                
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

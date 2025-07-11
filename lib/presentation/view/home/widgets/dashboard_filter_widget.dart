import 'package:asset_tracker/core/config/localization/generated/locale_keys.g.dart';
import 'package:asset_tracker/core/constants/enums/widgets/dashboard_filters_enum.dart';
import 'package:asset_tracker/injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterSection extends ConsumerWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sadece filter state'ini dinle
    final filters =
        ref.watch(dashboardViewModelProvider.select((vm) => vm.filters));

    final selectedFilter =
        ref.watch(dashboardViewModelProvider.select((vm) => vm.selectedFilter));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.dashboard_myAssets.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return OptimizedFilterChip(
                  filter: filter,
                  isSelected: filter == selectedFilter,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OptimizedFilterChip extends ConsumerWidget {
  final DashboardFilterEnum filter; // Filter tipinizi buraya yazın
  final bool isSelected;

  const OptimizedFilterChip({
    super.key,
    required this.filter,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(filter.name.tr()),
        selected: isSelected,
        onSelected: (selected) {
          // ref.read kullanarak method'u çağır
          ref
              .read(dashboardViewModelProvider.notifier)
              .changeSelectedFilter(filter);
        },
        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
        selectedColor: isDark
            ? Theme.of(context).primaryColor.withOpacity(0.3)
            : Colors.white,
        checkmarkColor: isDark
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor,
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
          width: isSelected ? 2 : 1,
        ),
        labelStyle: TextStyle(
          color: isSelected
              ? (isDark ? Colors.white : Theme.of(context).primaryColor)
              : (isDark ? Colors.grey[300] : Colors.grey[700]),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        elevation: isDark ? 2 : 1,
        shadowColor: isDark
            ? Colors.black.withOpacity(0.3)
            : Colors.black.withOpacity(0.1),
      ),
    );
  }
}

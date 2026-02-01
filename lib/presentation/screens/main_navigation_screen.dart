import 'package:flutter/material.dart';
import 'today_tab_screen.dart';
import 'dialogue_tab_screen.dart';
import 'progress_tab_screen.dart';

/// メインナビゲーション画面
/// 3つのタブ（今日・対話・軌跡）を管理
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  final List<Widget> _screens = [
    const TodayTabScreen(),
    const DialogueTabScreen(),
    const ProgressTabScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.today_outlined,
      activeIcon: Icons.today,
      label: '今日',
      tooltip: '今日のタスクと気分',
    ),
    NavigationItem(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: '対話',
      tooltip: 'AIとの対話と感情記録',
    ),
    NavigationItem(
      icon: Icons.trending_up_outlined,
      activeIcon: Icons.trending_up,
      label: '軌跡',
      tooltip: '成長の軌跡と統計',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _screens.length,
      vsync: this,
      initialIndex: _currentIndex,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _tabController.animateTo(index);

    // ハプティックフィードバック
    _provideFeedback();
  }

  void _provideFeedback() {
    // 軽いハプティックフィードバック
    // HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(), // スワイプ無効
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navigationItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == _currentIndex;

                return _NavigationButton(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => _onTabTapped(index),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/// ナビゲーションアイテムデータ
class NavigationItem {
  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.tooltip,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String tooltip;
}

/// カスタムナビゲーションボタン
class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });
  final NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Tooltip(
        message: item.tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    key: ValueKey(isSelected),
                    size: 24,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withOpacity(0.6),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  child: Text(item.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

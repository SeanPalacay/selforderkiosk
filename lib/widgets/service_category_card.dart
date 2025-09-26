import 'package:flutter/material.dart';
import '../models/service.dart';
import '../screens/service_selection_screen.dart';

class ServiceCategoryCard extends StatelessWidget {
  final String category;
  final List<Service> services;

  const ServiceCategoryCard({
    super.key,
    required this.category,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final IconData categoryIcon = _getCategoryIcon(category);
    final Color categoryColor = _getCategoryColor(category);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      surfaceTintColor: categoryColor.withValues(alpha:0.08),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ServiceSelectionScreen(
                category: category,
                services: services,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeOutCubic;

                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );

                return SlideTransition(
                  position: animation.drive(tween),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 350),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                categoryColor.withValues(alpha:0.15),
                categoryColor.withValues(alpha:0.08),
                categoryColor.withValues(alpha:0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha:0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  categoryIcon,
                  size: 40,
                  color: categoryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                category,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${services.length} service${services.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'AI Photobooth':
        return Icons.camera_alt;
      case 'AI Consultation':
        return Icons.psychology;
      case 'AI Health Scan':
        return Icons.health_and_safety;
      case 'AI Creative':
        return Icons.palette;
      default:
        return Icons.smart_toy;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'AI Photobooth':
        return const Color(0xFF00004c); // Deep navy blue
      case 'AI Consultation':
        return const Color(0xFF0074a8); // Blue accent
      case 'AI Health Scan':
        return const Color(0xFF2E7D32); // Green for health
      case 'AI Creative':
        return const Color(0xFF7B1FA2); // Purple for creativity
      default:
        return const Color(0xFF00004c); // Default to primary
    }
  }
}
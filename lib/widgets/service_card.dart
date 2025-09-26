import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/service.dart';
import '../providers/cart_provider.dart';
import '../screens/service_options_screen.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = _getCategoryColor(service.category);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 1,
      surfaceTintColor: colorScheme.primaryContainer.withValues(alpha:0.3),
      child: InkWell(
        onTap: () => _handleServiceTap(context),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: categoryColor.withValues(alpha:0.12),
                ),
                child: Icon(
                  _getServiceIcon(),
                  size: 36,
                  color: categoryColor,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '₱${service.price.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colorScheme.onTertiaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (service.options.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Chip(
                            label: const Text('Customizable'),
                            backgroundColor: colorScheme.secondaryContainer,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            side: BorderSide.none,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  FilledButton(
                    onPressed: () => _handleServiceTap(context),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                    child: Text(
                      service.options.isNotEmpty ? 'Configure' : 'Add to Cart',
                    ),
                  ),
                  if (service.options.isNotEmpty)
                    TextButton(
                      onPressed: () => _addToCartDirectly(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                      ),
                      child: const Text('Quick Add'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleServiceTap(BuildContext context) {
    if (service.options.isNotEmpty) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ServiceOptionsScreen(service: service),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

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
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      _addToCartDirectly(context);
    }
  }

  void _addToCartDirectly(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false).addItem(service);

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '${service.name} added to cart',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        showCloseIcon: true,
      ),
    );
  }

  IconData _getServiceIcon() {
    switch (service.category) {
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
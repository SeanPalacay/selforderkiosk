import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/service.dart';
import '../providers/cart_provider.dart';

class ServiceOptionsScreen extends StatefulWidget {
  final Service service;

  const ServiceOptionsScreen({super.key, required this.service});

  @override
  State<ServiceOptionsScreen> createState() => _ServiceOptionsScreenState();
}

class _ServiceOptionsScreenState extends State<ServiceOptionsScreen> {
  final Map<String, dynamic> _selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final categoryColor = _getCategoryColor(widget.service.category);

    double totalPrice = widget.service.price;
    for (final option in widget.service.options) {
      if (_selectedOptions.containsKey(option.id) &&
          _selectedOptions[option.id] != null &&
          _selectedOptions[option.id] != false) {
        totalPrice += option.additionalPrice;
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Configure Service',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: categoryColor,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  categoryColor,
                  categoryColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getServiceIcon(widget.service.category),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.service.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.service.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customize Your Service',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Configure your preferences for the perfect experience',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        ...widget.service.options.map((option) => _buildOptionWidget(option, colorScheme, categoryColor)),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Price:',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSecondaryContainer,
                                  letterSpacing: 0,
                                ),
                              ),
                              Text(
                                '₱${totalPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: colorScheme.primary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ready to add this service?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                letterSpacing: 0.15,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _addToCart,
                    icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                    label: Text(
                      'Add to Cart - ₱${totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: categoryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionWidget(ServiceOption option, ColorScheme colorScheme, Color categoryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: categoryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                if (option.additionalPrice > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: categoryColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '+₱${option.additionalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: categoryColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildOptionInput(option, colorScheme, categoryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionInput(ServiceOption option, ColorScheme colorScheme, Color categoryColor) {
    switch (option.type) {
      case OptionType.boolean:
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: CheckboxListTile(
            title: Text(
              'Enable this option',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            value: _selectedOptions[option.id] == true,
            onChanged: (value) {
              setState(() {
                _selectedOptions[option.id] = value;
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            activeColor: categoryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );

      case OptionType.choice:
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: option.choices.map((choice) {
              return RadioListTile<String>(
                title: Text(
                  choice,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                value: choice,
                groupValue: _selectedOptions[option.id],
                onChanged: (value) {
                  setState(() {
                    _selectedOptions[option.id] = value;
                  });
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                activeColor: categoryColor,
              );
            }).toList(),
          ),
        );

      case OptionType.text:
        return TextField(
          decoration: InputDecoration(
            hintText: 'Enter your preference...',
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: categoryColor,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
          onChanged: (value) {
            setState(() {
              _selectedOptions[option.id] = value.isNotEmpty ? value : null;
            });
          },
        );

    }
  }

  void _addToCart() {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColor = _getCategoryColor(widget.service.category);

    Provider.of<CartProvider>(context, listen: false).addItem(
      widget.service,
      options: _selectedOptions,
    );

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
                '${widget.service.name} added to cart!',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: categoryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );

    Navigator.pop(context);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'AI Photobooth':
        return const Color(0xFF00004c);
      case 'AI Consultation':
        return const Color(0xFF0074a8);
      case 'AI Health Scan':
        return const Color(0xFF2E7D32);
      case 'AI Creative':
        return const Color(0xFF7B1FA2);
      default:
        return const Color(0xFF00004c);
    }
  }

  IconData _getServiceIcon(String category) {
    switch (category) {
      case 'AI Photobooth':
        return Icons.camera_alt_rounded;
      case 'AI Consultation':
        return Icons.psychology_rounded;
      case 'AI Health Scan':
        return Icons.health_and_safety_rounded;
      case 'AI Creative':
        return Icons.palette_rounded;
      default:
        return Icons.smart_toy_rounded;
    }
  }
}
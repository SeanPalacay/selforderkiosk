import '../models/service.dart';

class ServicesData {
  static const List<Service> services = [
    // AI Photobooth Services
    Service(
      id: 'ai_photobooth_basic',
      name: 'AI Photobooth Basic',
      description: 'AI-enhanced photo session with instant editing',
      price: 150.0,
      category: 'AI Photobooth',
      imageUrl: 'assets/images/photobooth_basic.jpg',
      options: [
        ServiceOption(
          id: 'background',
          name: 'Background Style',
          additionalPrice: 30.0,
          type: OptionType.choice,
          choices: ['Studio', 'Nature', 'Abstract', 'Custom'],
        ),
        ServiceOption(
          id: 'filters',
          name: 'AI Filters',
          additionalPrice: 20.0,
          type: OptionType.boolean,
        ),
      ],
    ),
    Service(
      id: 'ai_photobooth_premium',
      name: 'AI Photobooth Premium',
      description: 'Professional AI photo session with advanced editing',
      price: 250.0,
      category: 'AI Photobooth',
      imageUrl: 'assets/images/photobooth_premium.jpg',
      options: [
        ServiceOption(
          id: 'background',
          name: 'Background Style',
          additionalPrice: 0.0,
          type: OptionType.choice,
          choices: ['Studio', 'Nature', 'Abstract', 'Custom', 'AI Generated'],
        ),
        ServiceOption(
          id: 'prints',
          name: 'Physical Prints',
          additionalPrice: 50.0,
          type: OptionType.boolean,
        ),
      ],
    ),

    // AI Consultation Services
    Service(
      id: 'ai_consultation_business',
      name: 'AI Business Consultation',
      description: 'Strategic AI implementation consultation for your business',
      price: 500.0,
      category: 'AI Consultation',
      imageUrl: 'assets/images/consultation_business.jpg',
      options: [
        ServiceOption(
          id: 'duration',
          name: 'Session Duration',
          additionalPrice: 200.0,
          type: OptionType.choice,
          choices: ['30 minutes', '60 minutes', '90 minutes'],
        ),
      ],
    ),
    Service(
      id: 'ai_consultation_personal',
      name: 'Personal AI Assistant Setup',
      description: 'Personalized AI assistant configuration and training',
      price: 300.0,
      category: 'AI Consultation',
      imageUrl: 'assets/images/consultation_personal.jpg',
    ),

    // AI Health Scan Services
    Service(
      id: 'ai_health_basic',
      name: 'Basic Health Scan',
      description: 'AI-powered basic health assessment',
      price: 200.0,
      category: 'AI Health Scan',
      imageUrl: 'assets/images/health_basic.jpg',
      options: [
        ServiceOption(
          id: 'report_detail',
          name: 'Detailed Report',
          additionalPrice: 100.0,
          type: OptionType.boolean,
        ),
      ],
    ),
    Service(
      id: 'ai_health_comprehensive',
      name: 'Comprehensive Health Analysis',
      description: 'Complete AI health assessment with recommendations',
      price: 400.0,
      category: 'AI Health Scan',
      imageUrl: 'assets/images/health_comprehensive.jpg',
      options: [
        ServiceOption(
          id: 'follow_up',
          name: 'Follow-up Consultation',
          additionalPrice: 150.0,
          type: OptionType.boolean,
        ),
      ],
    ),

    // AI Creative Services
    Service(
      id: 'ai_art_generation',
      name: 'AI Art Generation',
      description: 'Custom AI-generated artwork based on your preferences',
      price: 120.0,
      category: 'AI Creative',
      imageUrl: 'assets/images/art_generation.jpg',
      options: [
        ServiceOption(
          id: 'style',
          name: 'Art Style',
          additionalPrice: 0.0,
          type: OptionType.choice,
          choices: ['Digital', 'Oil Painting', 'Watercolor', 'Abstract', 'Photorealistic'],
        ),
        ServiceOption(
          id: 'size',
          name: 'Canvas Size',
          additionalPrice: 80.0,
          type: OptionType.choice,
          choices: ['Small (8x10)', 'Medium (11x14)', 'Large (16x20)'],
        ),
      ],
    ),
  ];

  static List<String> get categories {
    return services.map((service) => service.category).toSet().toList();
  }

  static List<Service> getServicesByCategory(String category) {
    return services.where((service) => service.category == category).toList();
  }
}
import 'package:flutter/material.dart';

class ProjectItem {
  final String id;
  final String title;
  final String category;
  final String description;
  final List<String> technologies;
  final IconData icon;
  final String status;
  final String? githubUrl;
  final String? demoUrl;

  const ProjectItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.technologies,
    required this.icon,
    required this.status,
    this.githubUrl,
    this.demoUrl,
  });
}

class ProjectsData {
  static const List<String> categories = [
    'All',
    'Mobile',
    'AI & ML',
    'Web Apps',
    'IoT & Hardware',
  ];

  static const List<ProjectItem> projects = [
    ProjectItem(
      id: 'secure-her',
      title: 'SecureHER — Women Safety App',
      category: 'Mobile',
      description:
          'A safety-focused mobile application concept designed to support emergency SOS, real-time location sharing, emergency contacts, and safe-route navigation assistance.',
      technologies: ['Flutter / React Native', 'Flask', 'Supabase', 'Geolocation API'],
      icon: Icons.security_rounded,
      status: 'Safety Concept',
      githubUrl: 'https://github.com/hashir1006',
    ),
    ProjectItem(
      id: 'firewall-ai',
      title: 'Firewall for AI',
      category: 'AI & ML',
      description:
          'An AI and cybersecurity-oriented project exploring defenses against prompt injection, malicious inputs, and model exploitation in large language model pipelines.',
      technologies: ['Python', 'FastAPI', 'LLM Guardrails', 'Cybersecurity'],
      icon: Icons.shield_rounded,
      status: 'AI Security Prototype',
      githubUrl: 'https://github.com/hashir1006',
    ),
    ProjectItem(
      id: 'food-waste',
      title: 'Smart Food Waste Reduction System',
      category: 'Web Apps',
      description:
          'A sustainability-focused platform for restaurant inventory optimization, predictive demand estimation, food-waste minimization, and surplus-food redistribution.',
      technologies: ['Next.js', 'PostgreSQL', 'Demand Forecasting', 'REST API'],
      icon: Icons.eco_rounded,
      status: 'Sustainability Concept',
      githubUrl: 'https://github.com/hashir1006',
    ),
    ProjectItem(
      id: 'movie-review',
      title: 'Movie Review System',
      category: 'Web Apps',
      description:
          'A movie discovery and discussion web application presenting film metadata, verified user ratings, sentiment-driven reviews, and tailored watchlists.',
      technologies: ['React.js', 'Node.js', 'MongoDB', 'TMDB API'],
      icon: Icons.movie_filter_rounded,
      status: 'Web Application',
      githubUrl: 'https://github.com/hashir1006',
    ),
    ProjectItem(
      id: 'personalised-ca',
      title: 'Personalised CA',
      category: 'AI & ML',
      description:
          'An intelligent accounting and financial advisory assistant designed to categorize business expenditures, forecast tax obligations, and offer audit-ready insights.',
      technologies: ['Python', 'Financial Analytics', 'Automation', 'LLM Agent'],
      icon: Icons.account_balance_wallet_rounded,
      status: 'FinTech Concept',
      githubUrl: 'https://github.com/hashir1006',
    ),
    ProjectItem(
      id: 'drug-delivery',
      title: 'Drug Delivery System App',
      category: 'Mobile',
      description:
          'A digital healthcare application streamlining authentic prescription uploads, nearby pharmacy discovery, order verification, and rapid doorstep delivery.',
      technologies: ['React Native / Flutter', 'Firebase', 'Live Tracking', 'State Mgmt'],
      icon: Icons.medical_services_rounded,
      status: 'Healthcare App',
      githubUrl: 'https://github.com/hashir1006',
    ),
    ProjectItem(
      id: 'two-way-intercom',
      title: 'Two-Way Intercom Device',
      category: 'IoT & Hardware',
      description:
          'An IoT communication system enabling low-latency bidirectional voice transmission between hardware units and central monitoring stations over local network protocols.',
      technologies: ['Embedded C / Python', 'WebSockets', 'Hardware Audio', 'Microcontrollers'],
      icon: Icons.cell_tower_rounded,
      status: 'Hardware / IoT',
      githubUrl: 'https://github.com/hashir1006',
    ),
  ];
}

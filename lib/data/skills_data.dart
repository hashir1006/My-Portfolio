import 'package:flutter/material.dart';

class SkillGroup {
  final String title;
  final IconData icon;
  final List<String> skills;

  const SkillGroup({
    required this.title,
    required this.icon,
    required this.skills,
  });
}

class SkillsData {
  static const List<SkillGroup> skillGroups = [
    SkillGroup(
      title: 'Frontend Development',
      icon: Icons.code_rounded,
      skills: [
        'HTML5',
        'CSS3',
        'JavaScript (ES6+)',
        'React.js',
        'Next.js',
        'Tailwind CSS',
        'Three.js',
      ],
    ),
    SkillGroup(
      title: 'Backend & Databases',
      icon: Icons.dns_rounded,
      skills: [
        'Python',
        'Node.js',
        'Django',
        'Flask',
        'MySQL',
        'PostgreSQL',
        'MongoDB',
        'Supabase',
        'Firebase',
      ],
    ),
    SkillGroup(
      title: 'Programming & Mobile',
      icon: Icons.phone_android_rounded,
      skills: [
        'Java',
        'Kotlin',
        'React Native',
        'Expo',
        'Flutter & Dart',
      ],
    ),
    SkillGroup(
      title: 'Tools & Workflows',
      icon: Icons.build_circle_rounded,
      skills: [
        'Git',
        'GitHub',
        'REST APIs',
        'Postman',
        'Linux / Shell',
        'AI-Assisted Dev Tools',
      ],
    ),
    SkillGroup(
      title: 'AI & Machine Learning',
      icon: Icons.psychology_rounded,
      skills: [
        'AI/ML Fundamentals',
        'Data Analysis & Pandas',
        'Model Integration',
        'Prompt Engineering',
        'Computer Vision Basics',
      ],
    ),
  ];
}

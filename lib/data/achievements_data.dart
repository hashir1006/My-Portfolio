import 'package:flutter/material.dart';

class AchievementItem {
  final String title;
  final String badge;
  final String description;
  final IconData icon;
  final String metric;

  const AchievementItem({
    required this.title,
    required this.badge,
    required this.description,
    required this.icon,
    required this.metric,
  });
}

class AchievementsData {
  static const String heading = 'Challenges That Shaped Me';
  static const String intro =
      'Building under pressure, collaborating with teams, and turning ideas into prototypes.';

  static const List<AchievementItem> achievements = [
    AchievementItem(
      title: 'Hackathon Final-Round Selections',
      badge: 'National & State Level',
      metric: '18+',
      description:
          'Selected into final pitch and prototype evaluation stages across 18+ competitive university and national-level hackathons.',
      icon: Icons.military_tech_rounded,
    ),
    AchievementItem(
      title: 'Hackathon Champions / 1st Place',
      badge: 'Competitive Honors',
      metric: '2 Wins',
      description:
          'Clinched 1st place and winner titles in 2 intense hackathons through high-velocity full-stack implementation and clear problem framing.',
      icon: Icons.emoji_events_rounded,
    ),
    AchievementItem(
      title: 'Rapid Prototyping & Technical Leadership',
      badge: 'Team Captaincy',
      metric: '100% Delivery',
      description:
          'Steered cross-functional teams in ideation, git version management, and live project demonstrations under strict 24–48 hour clocks.',
      icon: Icons.groups_rounded,
    ),
    AchievementItem(
      title: 'AI & Impact-Driven Solution Architecture',
      badge: 'Social Innovation',
      metric: '7+ Concepts',
      description:
          'Engineered end-to-end prototypes spanning women’s personal security, food waste reduction, AI guardrails, and healthcare logistics.',
      icon: Icons.lightbulb_rounded,
    ),
  ];
}

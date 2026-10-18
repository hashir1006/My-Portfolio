class ExperienceItem {
  final String organization;
  final String role;
  final String period;
  final String location;
  final String type; // e.g. "Academic Training / Hackathon Lead", "Internship"
  final List<String> responsibilities;
  final List<String> technologies;
  final bool isVerified; // Only verified experiences are shown in public view

  const ExperienceItem({
    required this.organization,
    required this.role,
    required this.period,
    required this.location,
    required this.type,
    required this.responsibilities,
    required this.technologies,
    this.isVerified = false,
  });
}

class ExperienceData {
  static const List<ExperienceItem> experiences = [
    // Verified academic role & project team leadership
    ExperienceItem(
      organization: 'MHSSCE Developer & Hackathon Cohort',
      role: 'Hackathon Team Lead & Core Developer',
      period: '2024 – Present',
      location: 'Mumbai, India',
      type: 'Academic & Hackathon Leadership',
      responsibilities: [
        'Led student developer teams in 18+ hackathon final rounds, directing architecture from problem statement to functional prototype within 24–48 hour sprints.',
        'Architected cross-platform mobile and web client interfaces, coordinating API integration with backend services and cloud databases.',
        'Mentored junior engineering peers in Git workflows, UI design principles, and rapid project pitching.',
      ],
      technologies: ['Flutter', 'React', 'Python', 'Git', 'Supabase'],
      isVerified: true,
    ),

    // Editable placeholder for future verified corporate internship:
    // Set isVerified: true once confirmed by Hashir
    ExperienceItem(
      organization: '[Company / Organization Name]',
      role: 'Software Engineering / AI Intern',
      period: '[Start Date] – [End Date]',
      location: 'Mumbai / Remote',
      type: 'Professional Internship',
      responsibilities: [
        'Editable: Specify official core responsibilities and deliverables.',
        'Editable: Specify technologies implemented and production metrics.',
      ],
      technologies: ['Python', 'Dart', 'SQL'],
      isVerified: false, // Incomplete placeholder hidden from public view
    ),
  ];

  // Helper to get only verified entries
  static List<ExperienceItem> get activeExperiences =>
      experiences.where((item) => item.isVerified).toList();
}

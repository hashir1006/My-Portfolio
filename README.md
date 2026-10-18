# Hashir Shaikh — Personal Portfolio Website
### Flutter Web • Dart • Responsive UI • Persian-Inspired Design • Vercel

A personal portfolio website for **Hashir Shaikh**, Computer Science and AI/ML student at M. H. Saboo Siddik College of Engineering, Mumbai.

Built according to the academic specification:
> *"To design, develop, and deploy a fully responsive personal portfolio website using Flutter Web framework with dark and light theme support, animated UI components, and public hosting on the Vercel cloud platform."*

---

## 🌟 Key Features

1. **Persian & Islamic Aesthetic Heritage**:
   - Subtle Persian pointed arch (Mihrab) with authentic ogee curves and 8-point geometric star lattices.
   - Ornamental side border trim and faint architectural mosque horizon silhouette in distant mist.
   - Restrained gold accents (`#B88946`), Cormorant Garamond serif headings, and Inter sans-serif typography.

2. **Hero Section (Pixel-Accurate to Reference Image)**:
   - Floating dark charcoal capsule navigation bar with active golden section dot indicator.
   - Bismillah marker, greeting, and large editorial name treatment with gold surname highlight.
   - Translucent glassmorphism buttons: **Download Resume** (primary gold gradient) and **Know More** (frosted glass).
   - Minimalist faceless silhouette profile portrait in double gold border with soft luminous edge glow.

3. **Complete Portfolio Sections**:
   - **About Me ("Beyond the Code")**: Student biography and 3 verified metrics (18+ hackathon finals, 2 wins, 7+ project concepts).
   - **Education**: B.E. in CSE (AI & ML) at MHSSCE, study timeline (2024–2028), and academic coursework chips.
   - **Technical Skills**: Visual categorization into Frontend, Backend & Databases, Mobile & Systems, Workflows, and AI & ML.
   - **Selected Works**: 7 distinct project concepts (SecureHER, Firewall for AI, Food Waste Reduction, Movie Reviews, Personalised CA, Drug Delivery, Two-Way Intercom) with category filters and modal detail views.
   - **Experience & Practical Leadership**: Verified hackathon lead roles, 24–48h rapid prototyping sprints, and cleanly hidden unverified internship placeholders.
   - **Achievements ("Challenges That Shaped Me")**: Verified competitive achievements and hackathon wins.
   - **Contact & Inquiries**: Form with input validation and honest mailto fallback (no simulated fake success).
   - **Footer**: Programmatic copyright year, monogram, social links, and closing philosophy.

4. **Dual Theme Architecture**:
   - Warm parchment light theme (`#F7F2E8`) and deep midnight charcoal dark theme (`#121316`).
   - Persistent preference storage via `shared_preferences`.

5. **Cloud Deployment Ready**:
   - Configured with `vercel.json` and `vercel-build.sh` publishing `build/web`.

---

## 📁 Project Architecture

```
lib/
├── app.dart                   # Main app structure, smooth scroll & section tracking
├── main.dart                  # Application entry point & theme initialization
├── theme/
│   ├── app_theme.dart         # Design tokens, color palettes & typography
│   └── theme_controller.dart  # ThemeMode state notifier with SharedPreferences
├── data/
│   ├── portfolio_data.dart    # Centralized personal info, links, and stats
│   ├── skills_data.dart       # Grouped technical skill data
│   ├── projects_data.dart     # 7 project items, categories, and tags
│   ├── experience_data.dart   # Verified roles and toggleable placeholders
│   └── achievements_data.dart # Hackathon and leadership milestones
├── widgets/
│   ├── navbar.dart            # Capsule header, active dot & mobile drawer
│   ├── glass_button.dart      # Reusable glassmorphic & gradient buttons
│   ├── image_placeholder.dart # Faceless portrait with Persian arch & gold border
│   ├── section_heading.dart   # Editorial heading with star ornament
│   ├── project_card.dart      # Interactive card with modal details & tags
│   ├── persian_decorations.dart # CustomPainters for arches, lattice & skyline
│   └── footer.dart            # Minimalist footer with live year & links
└── sections/
    ├── hero_section.dart      # Split-screen hero matching reference image
    ├── about_section.dart     # Bio narrative & verified metrics
    ├── education_section.dart # University degree details & coursework
    ├── skills_section.dart    # Categorized skill chips
    ├── projects_section.dart  # Filterable project catalog
    ├── experience_section.dart# Team lead timeline & responsibilities
    ├── achievements_section.dart# Hackathon wins and awards
    └── contact_section.dart   # Contact form with email validation
```

---

## 💻 Local Development

### Prerequisites
- Flutter SDK (3.47.7 or later)
- Dart SDK (3.13.5 or later)
- Google Chrome browser

### Run Locally
```bash
# Get dependencies
flutter pub get

# Run static analysis
flutter analyze

# Run automated tests
flutter test

# Start local web development server
flutter run -d chrome
```

### Production Build
```bash
flutter build web --release
```
The optimized web distribution is generated in `build/web`.

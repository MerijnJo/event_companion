import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event.dart';
import '../data/event_repository.dart';
import 'check_in_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  Future<void> _openMap() async {
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(event.location)}');
    if (!await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $googleMapsUrl');
    }
  }

  void _simulateNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔔 Herinnering: ${event.title} start over 10 minuten!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF4E45E4);
    final backgroundColor = const Color(0xFFFCF8FE);
    final onSurfaceColor = const Color(0xFF32323B);

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: backgroundColor.withOpacity(0.8),
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: primaryColor),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF6F2FB),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              title: Text(
                'Details',
                style: GoogleFonts.manrope(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
              actions: [
                ListenableBuilder(
                  listenable: eventRepository,
                  builder: (context, child) {
                    final isFav = eventRepository.isFavorite(event.id);
                    return IconButton(
                      icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border),
                      color: primaryColor,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF6F2FB),
                      ),
                      onPressed: () => eventRepository.toggleFavorite(event.id),
                    );
                  },
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: primaryColor),
                  onSelected: (value) {
                    if (value == 'notify') _simulateNotification(context);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'notify',
                      child: Text('Simuleer notificatie'),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 64 + 24,
            bottom: 140,
            left: 24,
            right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primaryColor.withOpacity(0.1),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=1000&auto=format&fit=crop'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black26, BlendMode.darken),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4E1ED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF6760FD),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event.tag,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: Color(0xFF5F5E68),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      event.title,
                      style: GoogleFonts.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -0.5,
                        color: onSurfaceColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bento Grid Info Section
            Row(
              children: [
                Expanded(
                  child: _buildBentoCard(
                    icon: Icons.schedule,
                    label: 'Datum & Tijd',
                    value: event.time,
                    primaryColor: primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _openMap,
                    child: _buildBentoCard(
                      icon: Icons.location_on,
                      label: 'Locatie',
                      value: event.location.split(',').first, // Korte locatie
                      primaryColor: primaryColor,
                      trailingIcon: Icons.open_in_new,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Description Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Over dit event',
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: onSurfaceColor,
                  ),
                ),
                Row(
                  children: [
                    _buildAvatar('https://i.pravatar.cc/150?img=33'),
                    Transform.translate(
                      offset: const Offset(-12, 0),
                      child: _buildAvatar('https://i.pravatar.cc/150?img=47'),
                    ),
                    Transform.translate(
                      offset: const Offset(-24, 0),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: primaryColor,
                        child: const Text('+84',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              event.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF5F5E68),
              ),
            ),
            const SizedBox(height: 24),
            
            // Feature Pills
            Row(
              children: [
                _buildFeaturePill(Icons.local_pizza, 'Catering', primaryColor),
                const SizedBox(width: 16),
                _buildFeaturePill(Icons.bolt, 'Wifi & Power', primaryColor),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomCTA(context, primaryColor, onSurfaceColor),
    );
  }

  Widget _buildBentoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color primaryColor,
    IconData? trailingIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 32),
          const SizedBox(height: 12),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Color(0xFF7B7984),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF32323B),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 4),
                Icon(trailingIcon, size: 16, color: primaryColor),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 4,
            width: 32,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFCF8FE), width: 2),
      ),
      child: CircleAvatar(
        radius: 14,
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String label, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F2FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF32323B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA(BuildContext context, Color primaryColor, Color onSurfaceColor) {
    return ListenableBuilder(
      listenable: eventRepository,
      builder: (context, child) {
        final isRegistered = eventRepository.isRegistered(event.id);
        final isCheckedIn = eventRepository.isCheckedIn(event.id);

        return Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color(0xFFFCF8FE),
                const Color(0xFFFCF8FE).withOpacity(0.9),
                const Color(0xFFFCF8FE).withOpacity(0.0),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOEGANG',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFF7B7984),
                      ),
                    ),
                    if (isRegistered && !isCheckedIn)
                      GestureDetector(
                        onTap: () =>
                            eventRepository.toggleRegistration(event.id),
                        child: const Text(
                          'Afmelden',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.redAccent,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.redAccent,
                          ),
                        ),
                      )
                    else
                      Text(
                        'Gratis',
                        style: GoogleFonts.manrope(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: onSurfaceColor,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    if (isCheckedIn) return;
                    if (!isRegistered) {
                      eventRepository.toggleRegistration(event.id);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckInScreen(
                              eventId: event.id, eventTitle: event.title),
                        ),
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: isCheckedIn
                          ? null
                          : LinearGradient(
                              colors: [primaryColor, const Color(0xFF6760FD)],
                            ),
                      color: isCheckedIn ? const Color(0xFF34C759) : null,
                      boxShadow: isCheckedIn
                          ? []
                          : [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              )
                            ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isCheckedIn
                              ? 'Ingecheckt!'
                              : (isRegistered ? 'Check-in scanner' : 'Aanmelden'),
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isCheckedIn
                              ? Icons.verified
                              : (isRegistered
                                  ? Icons.qr_code_scanner
                                  : Icons.arrow_forward),
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
    return Scaffold(
      backgroundColor: Colors.white, // Detailpagina's zijn vaak wit
      appBar: AppBar(
        title: const Text('Details'), // Kortere titel in de bar
        backgroundColor: Colors.white,
        actions: [
          ListenableBuilder(
            listenable: eventRepository,
            builder: (context, child) {
              final isFav = eventRepository.isFavorite(event.id);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.red : null,
                onPressed: () => eventRepository.toggleFavorite(event.id),
              );
            },
          ),
          PopupMenuButton<String>(
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, height: 1.2),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: 8),
                Text(event.time, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _openMap,
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      size: 20, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(event.location,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                            )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Over dit event',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
            const SizedBox(height: 32),
            ListenableBuilder(
              listenable: eventRepository,
              builder: (context, child) {
                final isRegistered = eventRepository.isRegistered(event.id);
                final isCheckedIn = eventRepository.isCheckedIn(event.id);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton.icon(
                      onPressed: isCheckedIn
                          ? null
                          : () => eventRepository.toggleRegistration(event.id),
                      icon: Icon(
                          isRegistered ? Icons.check_circle : Icons.person_add),
                      label: Text(isRegistered
                          ? 'Aangemeld voor dit event'
                          : 'Aanmelden'),
                      style: isRegistered
                          ? FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF34C759))
                          : null,
                    ),
                    if (isRegistered && !isCheckedIn) ...[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckInScreen(
                                  eventId: event.id, eventTitle: event.title),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code),
                        label: const Text('Check-in'),
                      ),
                    ],
                    if (isCheckedIn) ...[
                      const SizedBox(height: 12),
                      const Card(
                        color: Color(0xFF34C759),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Je bent ingecheckt!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
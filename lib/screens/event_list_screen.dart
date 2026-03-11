import 'package:flutter/material.dart';
import '../data/event_repository.dart';
import 'event_detail_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Bepaal de titel op basis van de geselecteerde tab
    String title = 'Event Companion';
    if (_selectedIndex == 1) title = 'Mijn Favorieten';
    if (_selectedIndex == 2) title = 'Mijn Aanmeldingen';

    return Scaffold(
      body: ListenableBuilder(
        listenable: eventRepository,
        builder: (context, child) {
          final allEvents = eventRepository.events;
          List events;
          
          // Filter de events op basis van de tab
          if (_selectedIndex == 0) {
            events = allEvents;
          } else if (_selectedIndex == 1) {
            events = allEvents
                .where((e) => eventRepository.isFavorite(e.id))
                .toList();
          } else {
            events = allEvents
                .where((e) => eventRepository.isRegistered(e.id))
                .toList();
          }

          return CustomScrollView(
            slivers: [
              // Hier wordt de 'title' variabele gebruikt
              SliverAppBar.large(
                title: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              if (events.isEmpty && _selectedIndex != 0)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      _selectedIndex == 1
                          ? 'Je hebt nog geen favorieten opgeslagen.'
                          : 'Je hebt je nog nergens voor aangemeld.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = events[index];
                      final isRegistered =
                          eventRepository.isRegistered(event.id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: const CircleAvatar(
                                child: Icon(Icons.event_note)),
                            title: Text(event.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 17)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('${event.time}\n${event.location}'),
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isRegistered)
                                  const Icon(Icons.check_circle,
                                      color: Color(0xFF34C759)),
                                if (isRegistered) const SizedBox(width: 8),
                                const Icon(Icons.chevron_right,
                                    color: Colors.grey),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetailScreen(event: event),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    childCount: events.length,
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorieten',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Aangemeld',
          ),
        ],
      ),
    );
  }
}

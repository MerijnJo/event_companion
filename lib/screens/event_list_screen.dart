import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/event_repository.dart';
import 'event_detail_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  int _selectedIndex = 0;

  IconData _getIcon(String name) {
    switch (name) {
      case 'psychology':
        return Icons.psychology;
      case 'terminal':
        return Icons.terminal;
      case 'security':
        return Icons.security;
      case 'cloud':
        return Icons.cloud;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'sensors':
        return Icons.sensors;
      case 'local_bar':
        return Icons.local_bar;
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'developer_board':
        return Icons.developer_board;
      case 'badge':
        return Icons.badge;
      default:
        return Icons.event;
    }
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final primaryColor = const Color(0xFF4E45E4);
    final inactiveColor = const Color(0xFF32323B).withOpacity(0.6);

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: isSelected ? primaryColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String headerTitle = 'Upcoming\nin Tilburg';
    String headerSubtitle = 'Hand-picked tech events for you.';

    if (_selectedIndex == 1) {
      headerTitle = 'Saved\nfor Later';
      headerSubtitle = 'Your favorite hand-picked events.';
    } else if (_selectedIndex == 2) {
      headerTitle = 'Ready\nto Go';
      headerSubtitle = 'Events you are currently attending.';
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: const Color(0xFFFCF8FE).withOpacity(0.8),
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF32323B)),
                onPressed: () {},
              ),
              title: Text(
                'Event Companion',
                style: GoogleFonts.manrope(
                  color: Color(0xFF4E45E4),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
              centerTitle: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFE4E1ED),
                    child: Icon(Icons.person, color: Colors.grey[700], size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: eventRepository,
        builder: (context, child) {
          final allEvents = eventRepository.events;
          List events;

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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      24, MediaQuery.of(context).padding.top + 10, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headerTitle,
                        style: GoogleFonts.manrope(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: -1,
                          color: Color(0xFF32323B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        headerSubtitle,
                        style: const TextStyle(
                          color: Color(0xFF5F5E68),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (events.isEmpty && _selectedIndex != 0)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      _selectedIndex == 1
                          ? 'You haven\'t saved any favorites yet.'
                          : 'You aren\'t attending any events yet.',
                      style: const TextStyle(color: Color(0xFF5F5E68)),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = events[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventDetailScreen(event: event),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          padding: const EdgeInsets.all(20),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6F2FB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getIcon(event.iconName),
                                  color: const Color(0xFF4E45E4),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4E45E4)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        event.tag,
                                        style: const TextStyle(
                                          color: Color(0xFF4E45E4),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      event.title,
                                      style: GoogleFonts.manrope(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF32323B),
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.schedule,
                                            size: 16, color: Color(0xFF5F5E68)),
                                        const SizedBox(width: 4),
                                        Text(
                                          event.time,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF5F5E68),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Icon(Icons.hub,
                                              size: 16, color: Color(0xFF5F5E68)),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            event.location,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF5F5E68),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: Color(0xFFB3B0BC)),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: events.length,
                  ),
                ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
            ],
          );
        },
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 80 + MediaQuery.of(context).padding.bottom,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom),
            color: const Color(0xFFFCF8FE).withOpacity(0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.event, 'Events'),
                _buildNavItem(1, Icons.favorite, 'Favorieten'),
                _buildNavItem(2, Icons.check_circle, 'Aangemeld'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

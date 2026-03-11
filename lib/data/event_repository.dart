import 'package:flutter/foundation.dart';
import '../models/event.dart';

class EventRepository extends ChangeNotifier {
  final Set<String> _favoriteIds = {};
  final Set<String> _registeredIds = {};
  final Set<String> _checkedInIds = {};

  final List<Event> _events = const [
    Event(
      id: '1',
      title: 'AI & Ethics Symposium',
      time: '10 apr 2026 | 13:00',
      location: 'Locomotiefboulevard 101, 5041 SE Tilburg',
      description:
          'Een diepgaande discussie over de ethische implicaties van AI in de moderne samenleving, met sprekers uit de industrie en de academische wereld.',
    ),
    Event(
      id: '2',
      title: 'Tilburg Hackathon 2026',
      time: '15 apr 2026 | 09:00',
      location: 'Burgemeester Brokxlaan 6, 5041 SB Tilburg',
      description:
          '24-uurs hackathon waar teams werken aan innovatieve oplossingen voor stedelijke uitdagingen. Inclusief pizza en energiedrankjes!',
    ),
    Event(
      id: '3',
      title: 'Cybersecurity Workshop',
      time: '22 apr 2026 | 14:00',
      location: 'Professor Cobbenhagenlaan 13, 5037 DA Tilburg',
      description:
          'Leer de basis van ethisch hacken en netwerkbeveiliging in deze hands-on workshop. Neem je eigen laptop mee.',
    ),
    Event(
      id: '4',
      title: 'Cloud Computing Summit',
      time: '05 mei 2026 | 10:00',
      location: 'Goirlese Weg 34, 5026 PC Tilburg',
      description:
          'Ontdek de laatste trends in AWS, Azure en Google Cloud. Keynotes van experts en netwerkmogelijkheden.',
    ),
    Event(
      id: '5',
      title: 'Game Dev Meetup',
      time: '12 mei 2026 | 19:30',
      location: 'Burgemeester Brokxlaan 1000, 5041 SG Tilburg',
      description:
          'Voor indie developers en hobbyisten. Show je projecten, krijg feedback en ontmoet andere game developers uit de regio.',
    ),
    Event(
      id: '6',
      title: 'IoT & Smart Cities',
      time: '20 mei 2026 | 15:00',
      location: 'Stappegoorweg 1, 5022 DA Tilburg',
      description:
          'Hoe maken we Tilburg slimmer? Presentaties over sensoren, data-analyse en duurzame stedelijke ontwikkeling.',
    ),
    Event(
      id: '7',
      title: 'Data Science Borrel',
      time: '28 mei 2026 | 17:00',
      location: 'Piusplein 8, 5038 WL Tilburg',
      description:
          'Informele netwerkborrel voor data scientists, analisten en studenten. Eerste drankje is van het huis!',
    ),
    Event(
      id: '8',
      title: 'Start-up Pitch Night',
      time: '04 jun 2026 | 19:00',
      location: 'Burgemeester Brokxlaan 12, 5041 SB Tilburg',
      description:
          'Lokale tech start-ups pitchen hun ideeën voor een jury van investeerders. Kom kijken naar de innovatie van morgen.',
    ),
    Event(
      id: '9',
      title: 'DevOps Masterclass',
      time: '15 jun 2026 | 09:00',
      location: 'Burgemeester Brokxlaan 1000, 5041 SG Tilburg',
      description:
          'Een intensieve dagcursus over CI/CD pipelines, containerization met Docker en Kubernetes orchestratie.',
    ),
    Event(
      id: '10',
      title: 'Tech Career Fair',
      time: '25 jun 2026 | 11:00',
      location: 'Burgemeester Brokxlaan 2, 5041 SB Tilburg',
      description:
          'Op zoek naar een stage of baan in de IT? Ontmoet topwerkgevers uit Brabant en daarbuiten.',
    ),
  ];

  List<Event> get events => List.unmodifiable(_events);

  bool isFavorite(String id) => _favoriteIds.contains(id);
  bool isRegistered(String id) => _registeredIds.contains(id);
  bool isCheckedIn(String id) => _checkedInIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  void toggleRegistration(String id) {
    if (_registeredIds.contains(id)) {
      _registeredIds.remove(id);
    } else {
      _registeredIds.add(id);
    }
    notifyListeners();
  }

  void checkIn(String id) {
    _checkedInIds.add(id);
    notifyListeners();
  }
}

// A simple global instance for this project scope.
// In a larger app, you would use a Provider or Dependency Injection.
final eventRepository = EventRepository();
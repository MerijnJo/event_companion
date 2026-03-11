import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/event_repository.dart';

class CheckInScreen extends StatefulWidget {
  final String eventId;
  final String eventTitle;

  const CheckInScreen({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  bool _isScanning = true;
  final TextEditingController _codeController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void dispose() {
    _codeController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _onCheckIn(String code) {
    // Simuleer validatie: de code moet "event-<id>" zijn
    if (code.trim() == 'event-${widget.eventId}') {
      eventRepository.checkIn(widget.eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Succesvol ingecheckt bij ${widget.eventTitle}!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ongeldige code. Probeer "event-${widget.eventId}"'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isScanning
                ? MobileScanner(
                    controller: _scannerController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          _scannerController.stop();
                          _onCheckIn(barcode.rawValue!);
                          break;
                        }
                      }
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Voer de code handmatig in',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _codeController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Event Code',
                            hintText: 'Bijv. event-1',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => _onCheckIn(_codeController.text),
                          child: const Text('Check-in bevestigen'),
                        ),
                      ],
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() => _isScanning = true),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan QR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isScanning
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _isScanning = false),
                  icon: const Icon(Icons.keyboard),
                  label: const Text('Handmatig'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_isScanning
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
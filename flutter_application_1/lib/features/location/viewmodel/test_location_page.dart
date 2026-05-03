import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../game/viewmodel/gps_location_vm.dart';

class TestLocationPage extends StatelessWidget {
  const TestLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locationVM = Provider.of<GpsLocationVM>(context);

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await locationVM.fetchLocation();
            if (locationVM.currentPosition != null) {
              print('Lat: ${locationVM.currentPosition!.latitude}, Long: ${locationVM.currentPosition!.longitude}');
            } else {
              print('Fejl: ${locationVM.errorMessage}');
            }
          },
          child: const Text('Hent lokation'),
        ),
      ),
    );
  }
}
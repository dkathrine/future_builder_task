import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /* added TextEditingController to read TextField */
  final TextEditingController _controller = TextEditingController();

  /* variable to safe the zip and use to search it */
  Future<String>? _cityName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            /* added mainaxisalingment to align ui elements in the middle(vertically) of the screen */
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 32,
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Postleitzahl",
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  /* setState to add the city returned by the getCityFromZip function to _cityName */
                  setState(() {
                    _cityName = getCityFromZip(_controller.text);
                  });
                },
                child: const Text("Suche"),
              ),
              /* added ternary to show Text before any Search happened */
              _cityName == null
                  ? Text(
                      "Ergebnis: Noch keine PLZ gesucht",
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  : FutureBuilder(
                      future: _cityName,
                      builder: (context, snapshot) {
                        /* Lade Zustand */
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Column(
                            spacing: 12,
                            children: [
                              CircularProgressIndicator(),
                              Text(
                                "City wird gesucht...",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          );
                        }

                        /* Fehler Zustand */
                        if (snapshot.hasError) {
                          return Column(
                            spacing: 12,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 32,
                              ),
                              Text(
                                "ERROR: ${snapshot.error}",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          );
                        }

                        /* Efrfolgs Zustand */
                        if (snapshot.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 4,
                            children: [
                              const Icon(Icons.location_city),
                              Text(
                                "${snapshot.data}",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          );
                        }

                        /* Kein Ergebnis */
                        return Text(
                          "Kein Ergebnis",
                          style: Theme.of(context).textTheme.labelLarge,
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    /* disposing the controller */
    _controller.dispose();
    super.dispose();
  }

  Future<String> getCityFromZip(String zip) async {
    // simuliere Dauer der Datenbank-Anfrage
    await Future.delayed(const Duration(seconds: 3));

    switch (zip) {
      case "10115":
        return 'Berlin';
      case "20095":
        return 'Hamburg';
      case "80331":
        return 'München';
      case "50667":
        return 'Köln';
      case "60311":
      case "60313":
        return 'Frankfurt am Main';
      default:
        return 'Unbekannte Stadt';
    }
  }
}

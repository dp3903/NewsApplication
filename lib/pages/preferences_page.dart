import 'package:flutter/material.dart';

class PreferencesPage extends StatefulWidget {

  final Map<String,bool> preferences;
  final void Function() onConfirm;
  final void Function(String,bool) onChange;
  PreferencesPage({required this.preferences, required this.onConfirm, required this.onChange});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  late Map<String, bool> preferences;
  @override
  void initState() {
    super.initState();
    // Initialize the _preferences map with the passed preferences map
    preferences = Map.from(widget.preferences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10,),
            Text(
              "KeyWords",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10,),
            Wrap(
              spacing: 8.0, // Gap between chips
              runSpacing: 6.0, // Gap between lines
              children: preferences.keys.map((keyword) {
                return FilterChip(
                  label: Text(
                      keyword,
                      style: TextStyle(
                        color: preferences[keyword]!
                            ? Colors.white
                            : Colors.black,
                      ),
                  ),
                  selected: preferences[keyword]!,
                  onSelected: (bool selected) {
                    setState(() {
                      preferences[keyword] = selected;
                      widget.onChange(keyword,selected);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Colors.grey[200]!,
                    ),
                  ),
                  backgroundColor: Colors.grey[200],
                  selectedColor: Colors.black,
                  showCheckmark: false, // Hide checkmark for a cleaner look
                  avatar: Icon(
                    preferences[keyword]!
                        ? Icons.check_circle
                        : Icons.add_circle,
                    color: preferences[keyword]!
                        ? Colors.white
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20,),
            TextButton(
              onPressed: () {
                widget.onConfirm();
              },
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.black, // Background color
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),// Border around the button
              ),
            ),
            Text("(Go back to home page after pressing confirm to see your chages.)")
          ],
        ),
      ),
    );
  }
}

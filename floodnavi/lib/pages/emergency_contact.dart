import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContact {
  final String name;
  final String phoneNumber;
  final Color color;
  final IconData icon;

  EmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.color,
    required this.icon,
  });
}

class EmergencyContactScreen extends StatelessWidget {
  final List<EmergencyContact> contacts = [
    EmergencyContact(
      name: 'Mae Sai Police Station',
      phoneNumber: '053-731-222',
      color: Colors.green,
      icon: Icons.security,
    ),
    EmergencyContact(
      name: 'Department of Disaster Prevention and Mitigation (DDPM)',
      phoneNumber: '1784',
      color: Colors.green,
      icon: Icons.flood,
    ),
    EmergencyContact(
      name: 'Ambulance/ Medical Emergency',
      phoneNumber: '1669',
      color: Colors.green,
      icon: Icons.medical_services,
    ),
    EmergencyContact(
      name: 'Mae Sai Subdistrict Municipality',
      phoneNumber: '199',
      color: Colors.green,
      icon: Icons.account_balance_rounded,
    ),
    EmergencyContact(
      name: 'For Myanmar Flood Victims in Mae Sai',
      phoneNumber: '087-726-5404',
      color: Colors.green,
      icon: Icons.water,
    ),
    EmergencyContact(
      name: 'Fire Station – Mae Sai, Chiang Rai',
      phoneNumber: '0-5373-3123',
      color: Colors.green,
      icon: Icons.local_fire_department,
    ),
  ];

  void _callContact(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not call $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Emergency Contacts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: contacts.length,
          separatorBuilder: (context, idx) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border(
                    left: BorderSide(color: contact.color, width: 5),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: contact.color.withOpacity(0.15),
                    child: Icon(contact.icon, color: contact.color, size: 28),
                    radius: 28,
                  ),
                  title: Text(
                    contact.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    contact.phoneNumber,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: contact.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      elevation: 2,
                    ),
                    icon: Icon(Icons.call, color: Colors.white, size: 18),
                    label: Text(
                      'Call',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => _callContact(contact.phoneNumber),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavItem extends StatelessWidget {
   String ?title;
  final IconData icon;
  final Widget destination;
  final List<String>? dropdownItems;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;

   NavItem({
    super.key,
      this.title,
    required this.icon,
    required this.destination,
    this.dropdownItems,
    this.selectedItem,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title!,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        trailing: dropdownItems != null && dropdownItems!.isNotEmpty
            ? DropdownButton<String>(
                value: selectedItem,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                dropdownColor: Colors.grey[800],
                underline: Container(),
                items: dropdownItems!.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: onChanged,
              )
            : null,
        onTap: dropdownItems == null
            ? () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                );
              }
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hoverColor: Colors.white.withOpacity(0.1),
      ),
    );
  }
}

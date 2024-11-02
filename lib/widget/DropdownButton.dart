import 'package:durub_ali/fillters/costomername.dart';
import 'package:flutter/material.dart';

class ArabicForm extends StatefulWidget {
  final ValueChanged<String?> onChanged;
    final TextEditingController customerNameController;

  const ArabicForm({Key? key, required this.onChanged, required this.customerNameController}) : super(key: key);

  @override
  State<ArabicForm> createState() => _ArabicFormState();
}

class _ArabicFormState extends State<ArabicForm> {
  final TextEditingController _customerNameController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'تخصيص معلومات المستقبل',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            // Name TextField
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'الاسم',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 30,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                    child: CustomerNameSearchWidget(
                      label: "al",
                      onChanged: widget.onChanged,
                      customerNameController: widget.customerNameController,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Region Dropdown (unchanged)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'المنطقة',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 30,
                  child: DropdownButtonFormField<String>(
                    alignment: AlignmentDirectional.centerEnd,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    hint: const Text(
                      'يرجى الاختيار او البحث',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                      textAlign: TextAlign.right,
                    ),
                    items: const [],
                    onChanged: (value) {},
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    dropdownColor: Colors.grey[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Buttons Row (unchanged)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: const Text(
                    'تم',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

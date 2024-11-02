import 'package:flutter/material.dart';

class LocationManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إدارة المناطق'),
          backgroundColor: Colors.brown[700],
        ),
        body: Row(
          children: [
            Expanded(child: RegionsColumn()),
            Expanded(child: CitiesColumn()),
            Expanded(child: VillagesColumn()),
            Expanded(child: VillagesList()),
          ],
        ),
      ),
    );
  }
}

class RegionsColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('طريق المطار'),
                ),
                CheckboxListTile(
                  value: false,
                  onChanged: null,
                  title: Text('أراضي ال48'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('عجلون'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('العقبة'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('الكرك'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('المفرق'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('الطفيلة'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('الزرقاء'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('عمان'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('البلقاء'),
                ),
                CheckboxListTile(
                  value: false,
                  onChanged: null,
                  title: Text('غزة'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('اربد'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('جرش'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.delete),
                  label: Text('حذف'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.add),
                  label: Text('إضافة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('اختيار المواقع'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              minimumSize: Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }
}

class CitiesColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('العقبة'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.delete),
                  label: Text('حذف'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.add),
                  label: Text('إضافة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('اختيار المواقع'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              minimumSize: Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }
}

class VillagesColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('وادي عربة'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('وادي رم'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('الريشة'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('المحدود'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('القويرة'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('القريقرة'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('العقبة'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('الطويسة'),
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: null,
                  title: Text('الديسة'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.delete),
                  label: Text('حذف'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.add),
                  label: Text('إضافة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('اختيار المواقع'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              minimumSize: Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }
}

class VillagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'بحث كل القرى',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(title: Text('الديسة - العقبة - العقبة')),
                ListTile(title: Text('الطويسة - العقبة - العقبة')),
                ListTile(title: Text('العقبة - العقبة - العقبة')),
                ListTile(title: Text('القريقرة - العقبة - العقبة')),
                ListTile(title: Text('القويرة - العقبة - العقبة')),
                ListTile(title: Text('المحدود - العقبة - العقبة')),
                ListTile(title: Text('المريغة - العقبة - العقبة')),
                ListTile(title: Text('وادي رم - العقبة - العقبة')),
                ListTile(title: Text('وادي عربة - العقبة - العقبة')),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.delete),
                  label: Text('حذف الكل'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('اختيار المواقع'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              minimumSize: Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }
}
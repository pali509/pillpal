import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'main.dart';


Future<void> connecting() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://amwzytiutgstvnrpaiju.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtd3p5dGl1dGdzdHZucnBhaWp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgzNDA3MzQsImV4cCI6MjAxMzkxNjczNH0.-15tfv5ltd59NnnC00FKUL-IsCmWvrpk1y4ktfHA2Y4',
  );
}

class trial extends StatelessWidget {
  final _future = Supabase.instance.client.from('Pills').select<List<Map<String, dynamic>>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pastillas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('error'));
          }
          final pills = snapshot.data!;
          return ListView.builder(
            itemCount: pills.length,
            itemBuilder: ((context, index) {
              final pill = pills[index];
              return ListTile(
                title: Text(pill['pill_name']),
              );
            }),
          );
        },
      ),
    );
  }
}

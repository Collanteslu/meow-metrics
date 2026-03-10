import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ColoniesListScreen extends ConsumerStatefulWidget {
  const ColoniesListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ColoniesListScreen> createState() => _ColoniesListScreenState();
}

class _ColoniesListScreenState extends ConsumerState<ColoniesListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement with Riverpod provider
    final colonies = <String>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Colonies'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search colonies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: colonies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_city,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No colonies yet',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first colony to get started',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: colonies.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Colony ${index + 1}'),
                        subtitle: const Text('Tap to view details'),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          context.push('/colonies/${index + 1}');
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add colony screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add colony functionality coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

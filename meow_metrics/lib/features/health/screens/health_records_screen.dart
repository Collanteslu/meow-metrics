import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthRecordsScreen extends ConsumerStatefulWidget {
  final String catId;

  const HealthRecordsScreen({
    Key? key,
    required this.catId,
  }) : super(key: key);

  @override
  ConsumerState<HealthRecordsScreen> createState() =>
      _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends ConsumerState<HealthRecordsScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    // TODO: Implement with Riverpod provider
    final records = <String>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Records'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedFilter == 'all',
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = 'all';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Vaccination'),
                    selected: _selectedFilter == 'vaccination',
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = 'vaccination';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Treatment'),
                    selected: _selectedFilter == 'treatment',
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = 'treatment';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Sterilization'),
                    selected: _selectedFilter == 'sterilization',
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = 'sterilization';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: records.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.health_and_safety,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No health records',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a health record to track this cat\'s health',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.health_and_safety),
                          ),
                          title: Text('Record ${index + 1}'),
                          subtitle: const Text('Health check'),
                          trailing: const Text('2024-01-15'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add health record coming soon'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

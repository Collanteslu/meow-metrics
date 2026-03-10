import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CatsListScreen extends ConsumerStatefulWidget {
  final String colonyId;

  const CatsListScreen({
    Key? key,
    required this.colonyId,
  }) : super(key: key);

  @override
  ConsumerState<CatsListScreen> createState() => _CatsListScreenState();
}

class _CatsListScreenState extends ConsumerState<CatsListScreen> {
  late TextEditingController _searchController;
  String _selectedFilter = 'all';

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
    final cats = <String>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cats'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search cats...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
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
                        label: const Text('Not Sterilized'),
                        selected: _selectedFilter == 'not_sterilized',
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'not_sterilized';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Sterilized'),
                        selected: _selectedFilter == 'sterilized',
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'sterilized';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: cats.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pets,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No cats yet',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cats.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: const Icon(Icons.pets),
                          ),
                          title: Text('Cat ${index + 1}'),
                          subtitle: const Text('Tap to view details'),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            context.push(
                              '/colonies/${widget.colonyId}/cats/${index + 1}',
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/colonies/${widget.colonyId}/cats/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

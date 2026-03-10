import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ColonyDetailScreen extends ConsumerStatefulWidget {
  final String colonyId;

  const ColonyDetailScreen({
    Key? key,
    required this.colonyId,
  }) : super(key: key);

  @override
  ConsumerState<ColonyDetailScreen> createState() => _ColonyDetailScreenState();
}

class _ColonyDetailScreenState extends ConsumerState<ColonyDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colony Details'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Cats'),
            Tab(text: 'Map'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Info tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Colony Name',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Colony #${widget.colonyId}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                // TODO: Add colony details
                const Text('Location information will appear here'),
              ],
            ),
          ),
          // Cats tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // TODO: Load cats from provider
              const Text('Cats list will appear here'),
            ],
          ),
          // Map tab
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: Text('Map will appear here'),
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

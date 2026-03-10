import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CatDetailScreen extends ConsumerStatefulWidget {
  final String colonyId;
  final String catId;

  const CatDetailScreen({
    Key? key,
    required this.colonyId,
    required this.catId,
  }) : super(key: key);

  @override
  ConsumerState<CatDetailScreen> createState() => _CatDetailScreenState();
}

class _CatDetailScreenState extends ConsumerState<CatDetailScreen>
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
        title: const Text('Cat Details'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Health'),
            Tab(text: 'Photos'),
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
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.pets,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Cat Name',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Gender:', 'Unknown'),
                _buildInfoRow('Color:', 'Not specified'),
                _buildInfoRow('Microchip ID:', 'Not set'),
                _buildInfoRow('Sterilization:', 'Not sterilized'),
                _buildInfoRow('CER Status:', 'Pending'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/health/${widget.catId}');
                    },
                    child: const Text('View Health Records'),
                  ),
                ),
              ],
            ),
          ),
          // Health tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // TODO: Load health records from provider
              const ListTile(
                title: Text('No health records yet'),
                subtitle: Text('Add a health record to get started'),
              ),
            ],
          ),
          // Photos tab
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 0, // TODO: Load photos
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

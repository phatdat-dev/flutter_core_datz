import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../extensions/app_extensions.dart';
import '../controller/app_log_controller.dart';

@RoutePage()
class AppLogView extends StatefulWidget {
  const AppLogView({super.key});

  @override
  State<AppLogView> createState() => _AppLogViewState();
}

class _AppLogViewState extends State<AppLogView> {
  final _logController = AppLogController.instance;
  AppLogLevel _selectedLevel = AppLogLevel.all;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<AppLogEntry> _getFilteredLogs() {
    final allLogs = _logController.logs;
    List<AppLogEntry> filteredLogs;
    if (_selectedLevel == AppLogLevel.all) {
      filteredLogs = allLogs;
    } else {
      filteredLogs = allLogs.where((log) => log.level == _selectedLevel).toList();
    }
    // Reverse the list to show newest logs first
    return filteredLogs.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _getFilteredLogs();
    final stats = _logController.getLogStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Logs'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'share_text':
                  final logsText = _logController.exportLogsAsString();
                  await SharePlus.instance.share(ShareParams(text: logsText));
                  break;
                case 'copy_all':
                  final logsText = _logController.exportLogsAsString();
                  await Clipboard.setData(ClipboardData(text: logsText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All logs copied to clipboard')),
                  );
                  break;
                case 'clear_all':
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text('Are you sure you want to delete all logs?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await _logController.clearLogs();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All logs deleted')),
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share_text',
                child: ListTile(
                  leading: Icon(Icons.share_outlined),
                  title: Text('Share logs'),
                ),
              ),
              const PopupMenuItem(
                value: 'copy_all',
                child: ListTile(
                  leading: Icon(Icons.copy_outlined),
                  title: Text('Copy all'),
                ),
              ),

              const PopupMenuItem(
                value: 'clear_all',
                child: ListTile(
                  leading: Icon(Icons.delete_forever_outlined, color: Colors.red),
                  title: Text('Delete all', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              // Stats row
              Container(
                height: 50,
                padding: const EdgeInsets.all(8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatChip('Total', stats.values.fold(0, (a, b) => a + b)),
                    ...AppLogLevel.values
                        .where((level) => level != AppLogLevel.all)
                        .map(
                          (level) => _buildStatChip(
                            level.name.toTitleCase(),
                            stats[level] ?? 0,
                            level.color,
                          ),
                        ),
                  ],
                ),
              ),
              // Filter row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  children: AppLogLevel.values
                      .map(
                        (level) => ChoiceChip(
                          label: Text(level.name.toTitleCase()),
                          selected: _selectedLevel == level,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedLevel = level);
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: filteredLogs.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            'No logs available',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredLogs.length,
                      itemBuilder: (context, index) {
                        final log = filteredLogs[index];
                        return _buildLogItem(log);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, [Color? color]) {
    return Chip(
      label: Text(
        '$label: $count',
        style: TextStyle(
          color: color ?? Theme.of(context).textTheme.bodySmall?.color,
          fontSize: 12,
        ),
      ),
      backgroundColor: color?.withValues(alpha: 0.1),
    );
  }

  Widget _buildLogItem(AppLogEntry log) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ExpansionTile(
        leading: Icon(log.level.icon, color: log.level.color, size: 20),
        title: Text(
          log.message,
          style: TextStyle(
            color: log.level.color,
            fontWeight: log.level == AppLogLevel.error ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          '${log.timestamp.toString().substring(11, 19)} - ${log.level}',
          style: const TextStyle(fontSize: 12),
        ),
        children: [
          if (log.data != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(log.data.toString()),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HistoryDetailCard extends StatelessWidget {
  final List<Map<String, String>>? detailInfo;
  const HistoryDetailCard({super.key, required this.detailInfo});

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: detailInfo == null
            ? const Center(child: Text("無詳細資訊"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: detailInfo!.map((info) => _buildDetailRow(info.keys.first, info.values.first)).toList()),
      ),
    );
  }
}

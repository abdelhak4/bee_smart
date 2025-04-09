import 'package:flutter/material.dart';
import '../utils/theme.dart';

class StatusIndicator extends StatelessWidget {
  final String status;
  final bool showLabel;
  
  const StatusIndicator({
    Key? key,
    required this.status,
    this.showLabel = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);
    final statusLabel = _getStatusLabel(status);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            statusLabel,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'strong':
        return Colors.green;
      case 'improving':
        return Colors.lightGreen;
      case 'declining':
        return Colors.orange;
      case 'wintering':
        return Colors.blue;
      case 'danger':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  String _getStatusLabel(String status) {
    switch (status) {
      case 'strong':
        return 'Strong';
      case 'improving':
        return 'Improving';
      case 'declining':
        return 'Declining';
      case 'wintering':
        return 'Wintering';
      case 'danger':
        return 'Danger';
      default:
        return 'Unknown';
    }
  }
}
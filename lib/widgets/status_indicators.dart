import 'package:flutter/material.dart';

enum StatusType { loading, success, error, warning, info, idle }

class StatusIndicator extends StatelessWidget {
  final StatusType status;
  final String message;
  final double? progress;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;
  final Color? customColor;
  final IconData? customIcon;
  final EdgeInsetsGeometry? padding;
  final bool showProgress;

  const StatusIndicator({
    super.key,
    required this.status,
    required this.message,
    this.progress,
    this.onRetry,
    this.onCancel,
    this.customColor,
    this.customIcon,
    this.padding,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getBackgroundColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getBackgroundColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _getTextColor(context),
                      ),
                    ),
                    if (showProgress && progress != null) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getBackgroundColor(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress! * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: _getTextColor(context).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onRetry != null || onCancel != null) ...[
                const SizedBox(width: 8),
                _buildActions(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    switch (status) {
      case StatusType.loading:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_getBackgroundColor()),
          ),
        );
      case StatusType.success:
        icon = customIcon ?? Icons.check_circle;
        break;
      case StatusType.error:
        icon = customIcon ?? Icons.error;
        break;
      case StatusType.warning:
        icon = customIcon ?? Icons.warning;
        break;
      case StatusType.info:
        icon = customIcon ?? Icons.info;
        break;
      case StatusType.idle:
        icon = customIcon ?? Icons.radio_button_unchecked;
        break;
    }

    return Icon(icon, color: customColor ?? _getBackgroundColor(), size: 20);
  }

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onRetry != null)
          IconButton(
            icon: const Icon(Icons.refresh, size: 18),
            onPressed: onRetry,
            tooltip: 'Coba Lagi',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        if (onCancel != null)
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onCancel,
            tooltip: 'Batal',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
      ],
    );
  }

  Color _getBackgroundColor() {
    if (customColor != null) return customColor!;

    switch (status) {
      case StatusType.loading:
        return Colors.blue;
      case StatusType.success:
        return Colors.green;
      case StatusType.error:
        return Colors.red;
      case StatusType.warning:
        return Colors.orange;
      case StatusType.info:
        return Colors.blue;
      case StatusType.idle:
        return Colors.grey;
    }
  }

  Color _getTextColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
  }
}

class MultiStatusIndicator extends StatelessWidget {
  final Map<String, StatusIndicator> statusIndicators;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const MultiStatusIndicator({
    super.key,
    required this.statusIndicators,
    this.padding,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    if (statusIndicators.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            statusIndicators.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: spacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    entry.value,
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}

class UploadProgressIndicator extends StatelessWidget {
  final Map<String, double> fileProgress;
  final Map<String, StatusType> fileStatus;
  final Map<String, String> fileMessages;
  final VoidCallback? onCancel;
  final EdgeInsetsGeometry? padding;

  const UploadProgressIndicator({
    super.key,
    required this.fileProgress,
    required this.fileStatus,
    required this.fileMessages,
    this.onCancel,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.upload_file, color: Colors.blue),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Upload Progress',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              if (onCancel != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onCancel,
                  tooltip: 'Batalkan Upload',
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...fileProgress.keys.map((fileName) {
            final progress = fileProgress[fileName] ?? 0.0;
            final status = fileStatus[fileName] ?? StatusType.idle;
            final message = fileMessages[fileName] ?? 'Memproses...';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  StatusIndicator(
                    status: status,
                    message: message,
                    progress: status == StatusType.loading ? progress : null,
                    showProgress: status == StatusType.loading,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class StatusFAB extends StatelessWidget {
  final StatusType status;
  final VoidCallback? onPressed;
  final String? tooltip;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const StatusFAB({
    super.key,
    required this.status,
    this.onPressed,
    this.tooltip,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: status == StatusType.loading ? null : onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? _getBackgroundColor(),
      foregroundColor: foregroundColor ?? Colors.white,
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    switch (status) {
      case StatusType.loading:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      case StatusType.success:
        return Icon(icon ?? Icons.check);
      case StatusType.error:
        return Icon(icon ?? Icons.error);
      case StatusType.warning:
        return Icon(icon ?? Icons.warning);
      case StatusType.info:
        return Icon(icon ?? Icons.info);
      case StatusType.idle:
        return Icon(icon ?? Icons.add);
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case StatusType.loading:
        return Colors.grey;
      case StatusType.success:
        return Colors.green;
      case StatusType.error:
        return Colors.red;
      case StatusType.warning:
        return Colors.orange;
      case StatusType.info:
        return Colors.blue;
      case StatusType.idle:
        return Colors.blue;
    }
  }
}

class StatusSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required StatusType type,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          _getIcon(type),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: _getBackgroundColor(type),
      duration: duration,
      action:
          onAction != null && actionLabel != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
              : null,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Widget _getIcon(StatusType type) {
    IconData iconData;
    switch (type) {
      case StatusType.loading:
        return const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      case StatusType.success:
        iconData = Icons.check_circle;
        break;
      case StatusType.error:
        iconData = Icons.error;
        break;
      case StatusType.warning:
        iconData = Icons.warning;
        break;
      case StatusType.info:
        iconData = Icons.info;
        break;
      case StatusType.idle:
        iconData = Icons.info;
        break;
    }
    return Icon(iconData, color: Colors.white, size: 20);
  }

  static Color _getBackgroundColor(StatusType type) {
    switch (type) {
      case StatusType.loading:
        return Colors.blue;
      case StatusType.success:
        return Colors.green;
      case StatusType.error:
        return Colors.red;
      case StatusType.warning:
        return Colors.orange;
      case StatusType.info:
        return Colors.blue;
      case StatusType.idle:
        return Colors.grey;
    }
  }
}

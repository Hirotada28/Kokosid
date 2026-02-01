import 'package:flutter/material.dart';

/// 音声入力ボタンウィジェット
class VoiceInputButton extends StatefulWidget {
  const VoiceInputButton({
    super.key,
    required this.isRecording,
    required this.onRecordingChanged,
  });
  final bool isRecording;
  final ValueChanged<bool> onRecordingChanged;

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isRecording) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VoiceInputButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _toggleRecording,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) => Transform.scale(
          scale: widget.isRecording ? _pulseAnimation.value : 1.0,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.isRecording
                    ? [Colors.red.shade400, Colors.red.shade600]
                    : [theme.colorScheme.primary, theme.colorScheme.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: (widget.isRecording
                          ? Colors.red
                          : theme.colorScheme.primary)
                      .withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: widget.isRecording ? 5 : 0,
                ),
              ],
            ),
            child: Icon(
              widget.isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  void _toggleRecording() {
    widget.onRecordingChanged(!widget.isRecording);
  }
}

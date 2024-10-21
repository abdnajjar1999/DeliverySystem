import 'package:flutter/material.dart';

class AnimatedBuildTextFormField extends StatefulWidget {
  final double width;
  final String hintText;
  final String label;
  final IconData iconData;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;

  const AnimatedBuildTextFormField({
    Key? key,
    required this.width,
    required this.hintText,
    required this.label,
    required this.iconData,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _AnimatedBuildTextFormFieldState createState() => _AnimatedBuildTextFormFieldState();
}

class _AnimatedBuildTextFormFieldState extends State<AnimatedBuildTextFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: widget.width * 0.9,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            maxLines: widget.maxLines,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hintText,
              labelStyle: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(widget.iconData, color: Colors.blue[800]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
          ),
        ),
      ),
    );
  }
}

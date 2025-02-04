import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final List<Color> colors;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.colors,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Ensure the onPressed is properly called
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        height: 65,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.94, 0.34),
            end: Alignment(0.94, -0.34),
            colors: colors,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 10,
              offset: Offset(0, 5),
              spreadRadius: 0,
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFFFCFCFF),
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

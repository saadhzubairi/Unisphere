import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.roboto(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
          //textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: "dismiss",
          textColor: Theme.of(context).colorScheme.onError,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showThemedSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),
          //textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.grey.shade200,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: "dismiss",
          textColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }
}

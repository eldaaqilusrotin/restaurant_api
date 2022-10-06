
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restaurant_api/providers/database_provider.dart';

class AddToFavoriteDialog extends StatefulWidget {
  final DatabaseProvider provider;
  final String favoritedRestaurantId;
  final bool isFavorited;

  const AddToFavoriteDialog({
    super.key,
    required this.provider,
    required this.favoritedRestaurantId,
    required this.isFavorited,
  });

  @override
  State<AddToFavoriteDialog> createState() =>
      _AddToFavoriteDialogState();
}

class _AddToFavoriteDialogState extends State<AddToFavoriteDialog> {
  late FToast fToast;

  _showMyCustomToast(Color backgroundColor, Icon icon, String text,
      Color textColor, ToastGravity gravity, Duration duration) {
    Widget toast = Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: gravity,
      toastDuration: duration,
    );
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: const Text(
        'Tambahkan restoran ini ke daftar favorit?',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('TIDAK'),
        ),
        TextButton(
          onPressed: () {
            if (widget.isFavorited == true) {
              Navigator.pop(context);
              _showMyCustomToast(
                Colors.red,
                const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                ),
                'Restorant ini sudah ditambahkan sebelumnya',
                Colors.white,
                ToastGravity.BOTTOM,
                const Duration(seconds: 3),
              );
            } else {
              widget.provider.addFavorite(widget.favoritedRestaurantId);
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Restoran berhasil ditambahkan ke daftar favorit',
                backgroundColor: Colors.lightBlueAccent,
                textColor: Colors.white,
                gravity: ToastGravity.SNACKBAR,
              );
            }
          },
          child: const Text('YA'),
        ),
      ],
    );
  }
}
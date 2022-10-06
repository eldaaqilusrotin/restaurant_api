import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restaurant_api/ui/home_page.dart';
import '../providers/database_provider.dart';
import '../providers/detail_restaurant_provider.dart';

class DeleteFavoriteDialog extends StatelessWidget {
  final DatabaseProvider databaseProvider;
  final DetailRestaurantProvider restaurantDetailProvider;
  final String favoritedRestaurantId;

  const DeleteFavoriteDialog({
    super.key,
    required this.databaseProvider,
    required this.restaurantDetailProvider,
    required this.favoritedRestaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lightBlueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content: Text(
        'Anda yakin ingin menghapus restoran ${restaurantDetailProvider.detail.restaurant.name} dari daftar favorit?',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('TIDAK', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () {
            databaseProvider.removeFavorite(favoritedRestaurantId);
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
            Fluttertoast.showToast(
              msg:
              'Restoran ${restaurantDetailProvider.detail.restaurant.name} telah dihapus dari daftar favorit',
              backgroundColor: Colors.lightBlueAccent,
              textColor: Colors.white,
              gravity: ToastGravity.SNACKBAR,
            );
          },
          child: const Text('YA', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}


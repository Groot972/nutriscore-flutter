import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutriscore_flutter/Colors.dart';
import 'package:nutriscore_flutter/app_icons.dart';
import 'package:nutriscore_flutter/vues/fiche.dart';



class AddCardScreen extends StatelessWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Mes scans'),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0), // Ajoutez ici la valeur de margin souhaitée
              child: IconButton(
                icon: const Icon(AppIcons.barcode),
                tooltip: 'Show Snackbar',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This is a snackbar')));
                },
              ),
            ),
      ]
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('res/svg/ill_empty.svg'),
            const SizedBox(height: 80),
            const Text(
              "Vous n'avez pas encore scanné de produit",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 50.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> ProductDetails()),);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.blue,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22.0))),
                backgroundColor: AppColors.yellow,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Commencer',
                    style: TextStyle(
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_alt,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

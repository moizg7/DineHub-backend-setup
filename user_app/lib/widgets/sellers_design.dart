import 'package:flutter/material.dart';
import 'package:user_app/mainScreens/menus_screen.dart';
import 'package:user_app/models/sellers.dart';

class SellersDesignWidget extends StatefulWidget {
  final Sellers? model;
  final BuildContext? context;

  const SellersDesignWidget({super.key, this.model, this.context});

  @override
  State<SellersDesignWidget> createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    print('Seller Model Data:');
    print('Name: ${widget.model?.sellerName}');
    print('Photo URL: ${widget.model?.photoUrl}');

    return InkWell(
      onTap: () {
        print("Tapped seller: ${widget.model?.sellerName}");
        print("Seller UID: ${widget.model?.sellerUID}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenusScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Divider(
              height: 4,
              thickness: 3,
              color: Colors.grey[300],
            ),
            widget.model?.photoUrl != null
                ? Image.network(
                    widget.model!.photoUrl!,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: ${widget.model!.photoUrl}');
                      print('Error details: $error');
                      return Container(
                        height: 220,
                        color: Colors.grey[300],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error,
                                size: 50, color: Colors.red),
                            const SizedBox(height: 10),
                            Text(
                              'Failed to load image',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 220,
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    height: 220,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 100),
                  ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.model?.sellerName ?? 'Unknown Seller',
              style: const TextStyle(
                color: Color.fromARGB(255, 64, 140, 255),
                fontSize: 20,
                fontFamily: "Poppins",
              ),
            ),
            Divider(
              height: 4,
              thickness: 2,
              color: Colors.grey[300],
            )
          ]),
        ),
      ),
    );
  }
}

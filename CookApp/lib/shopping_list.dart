import 'package:flutter/material.dart';

class ShoppingListForm extends StatefulWidget {
  const ShoppingListForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingListFormState createState() => _ShoppingListFormState();
}

class _ShoppingListFormState extends State<ShoppingListForm> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: const ListTile(
                  title: Text(
                    'PÁGINA NÃO FUNCIONAL',
                    style: TextStyle(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 45,
                  ),
                  trailing: Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

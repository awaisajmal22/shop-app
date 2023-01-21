import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products.dart';
import '../screens/edit_product_screen.dart';

class UserPrdouct extends StatelessWidget {
  const UserPrdouct({Key? key, required this.title, required this.image, required this.id}) : super(key: key);
  final String title;
  final String image;
  final String id;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: id,
              );
            }, 
            icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
              try{
                await Provider.of<Products>(context, listen: false).deleteProduct(id);
                } catch(error){
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Deleting Faild', textAlign: TextAlign.center,) ,
                    )
                  );
                }
            },
             icon: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
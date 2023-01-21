

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editProductScreen';
  const EditProductScreen({required Key key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocus = FocusNode();
  final discriptionFocus = FocusNode();
  final imageUrl = TextEditingController();
  final imageUrlFocus = FocusNode();
  final _form = GlobalKey<FormState>();

var editingProduct = Product(
  id: '', 
  description: '', 
  image: '', 
  price: 0.0, 
  title: '',

);

  @override
  void initState() {
    imageUrlFocus.addListener(updateImage);
    super.initState();
  }
var _isinitValue = {
  'title': '',
  'description': '',
  'price':'',
  'image':''

};
var _isinit = true;
  @override
  void didChangeDependencies() {
   if(_isinit){
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    if(productId != null ){
    editingProduct = Provider.of<Products>(context, listen: false).findById(productId);
   
  _isinitValue = {
'title': editingProduct.title,
'description': editingProduct.description,
'price': editingProduct.price.toString(),
'image': ''
};
imageUrl.text = editingProduct.image;
    }
   }

   _isinit = false;
  }

  @override
  void dispose() {
   
    imageUrlFocus.removeListener(updateImage);
    priceFocus.dispose();
    discriptionFocus.dispose();
    imageUrl.dispose();
    imageUrlFocus.dispose();
    super.dispose();
  }

  void updateImage(){
    if(!imageUrlFocus.hasFocus){
      if((!imageUrl.text.startsWith('http') &&
         !imageUrl.text.startsWith('https')) ||
         (!imageUrl.text.endsWith('.png') &&
         !imageUrl.text.endsWith('jpg') &&
         !imageUrl.text.endsWith('jpeg'))){
        return ;
         }
      }
    
    }
  
var isLoading = false;
  Future<void> saveForm() async {
   final isValid = _form.currentState?.validate();
   if(isValid == null || isValid == false){
    return;
   }
        _form.currentState!.save();
        setState(() {
          isLoading = true;
        });
         if(editingProduct.id != ''){
          await Provider.of<Products>(context, listen: false)
          .updateProduct(editingProduct.id, editingProduct);
        }
        else{
          try {
        await Provider.of<Products>(context, listen: false)
        .addProduct(editingProduct);
          } catch(error){
          await showDialog(context: context, 
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occured'),
            content: Text('Something Went Wrong!'),
            actions: [
              TextButton(
                onPressed: (){
                    Navigator.of(ctx).pop();
              }, 
              child: const Text('Ok')
              )
            ],
          ),
          );
          } 
        } 
         setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: saveForm,
             icon: Icon(Icons.save))
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(

        ),
      ) : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
               TextFormField(
      initialValue: _isinitValue['title'],
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(priceFocus);
              },
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'Please Enter The Product Title';
                }
                return null;
              },
              onSaved: (value){
                editingProduct = Product(
                  description: editingProduct.description,
                  price: editingProduct.price,
                  id: editingProduct.id,
                  isFavorite: editingProduct.isFavorite,
                  title: value as String,
                  image: editingProduct.image
                  );
              },
            ),
  TextFormField(
    initialValue: _isinitValue['price'],
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: priceFocus,
              onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(discriptionFocus);
              },
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Please Enter The Product Price';
                }
                if(double.tryParse(value) == null){
                  return 'Please Enter a Valid Number';
                }
                if(double.parse(value) <= 0){
                  return 'Please Enter The Number Greater Than Zero';
                }
                return null;
              },
              onSaved: (value){
                editingProduct = Product(
                  description: editingProduct.description, 
                  id: editingProduct.id, 
                  image: editingProduct.image, 
                  price: double.parse(value as String),
                  title: editingProduct.title,
                  isFavorite: editingProduct.isFavorite
                  );
              },
            ),
  TextFormField(
    initialValue: _isinitValue['description'],
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              focusNode: discriptionFocus,
              onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(imageUrlFocus);
              },
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Please Enter The Product Description';
                }
                if(value.length < 10){
                  return 'Should be at least 10 characters';
                }
                return null;
              },
              onSaved: (value){
                editingProduct = Product(
                  description: value.toString(), 
                  id: editingProduct.id, 
                  image: editingProduct.image, 
                  price: editingProduct.price,
                  title: editingProduct.title,
                isFavorite: editingProduct.isFavorite
                  );
              }
            ),
Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1
                      )
                    ),
                    margin: EdgeInsets.all(8),
                    child: imageUrl.text.isEmpty ? Center(child: Text('Enter the Url')) : FittedBox(
                      child: Image.network(imageUrl.text,
                      fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'image',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageUrl,
                      focusNode: imageUrlFocus,
                      onFieldSubmitted: (_){
                        saveForm();
                      },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Please Enter The Product ImageUrl';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Please Enter The Valid URL';
                        }
                        if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                          return 'Please Enter The Valid URL';
                        }
                        return null;
                      },
                      onSaved: (value){
                editingProduct = Product(
                  description: editingProduct.description, 
                  id: editingProduct.id,
                  isFavorite: editingProduct.isFavorite, 
                  image: value as String, 
                  price: editingProduct.price,
                  title: editingProduct.title
                  );
                      }
                    ),
                  )
                ],
              )
              
            ],
          )
        ),
      )
    );
    

}
}

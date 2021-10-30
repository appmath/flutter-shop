import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shop/providers/product.dart';
import 'package:flutter_shop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  // Don't forget to add this route in your main.dart file (or whatever you are using to define your routes)
  static const routeName = '/edit-product-screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // TODO Add to widgets
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var _editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0.0);

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  // TODO Add to Live T
  final _form = GlobalKey<FormState>();

  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      print('productId: $productId');

      if (productId != null) {
        var _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    if (_editedProduct != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return // Probably need SafeArea()
        Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        // backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        // TODO Add to Live Templates
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    print('onSaved title: $value');
                    _editedProduct = buildProduct(
                        _editedProduct.id,
                        value,
                        _editedProduct.description,
                        _editedProduct.imageUrl,
                        _editedProduct.price);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    buildProduct(
                        _editedProduct.id,
                        _editedProduct.title,
                        _editedProduct.description,
                        _editedProduct.imageUrl,
                        double.tryParse(value!));
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a price.';
                    }
                    print('value: $value');
                    print('double.tryParse(value): ${double.tryParse(value)}');

                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }

                    if (double.parse(value) <= 0) {
                      return 'Please enter a number greater than 0.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _editedProduct = buildProduct(
                        _editedProduct.id,
                        _editedProduct.title,
                        value,
                        _editedProduct.imageUrl,
                        _editedProduct.price);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description.';
                    }
                    if (value.length < 10) {
                      return 'Please enter a description with a least 10 characters.';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blueGrey),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Text('Enter a URL')
                          : FittedBox(
                              // child: Image.network(_imageUrlController.text),
                              //   child: Image.network(_imageUrlController
                              //           .text.isEmpty
                              //       ? _imageUrlController.text
                              //       : 'https://upload.wikimedia.org/wikipedia/commons/8/84/Prunus_flower.jpg'),
                              //   fit: BoxFit.scaleDown,
                              // )
                              // child: Image.network(_imageUrlController.text),
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.scaleDown,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = buildProduct(
                              _editedProduct.id,
                              _editedProduct.title,
                              _editedProduct.description,
                              value,
                              _editedProduct.price);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an image URL.';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL.';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please enter a valid image URL.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Product buildProduct(String? id, String? title, String? description,
      String? imageUrl, double? price) {
    return Product(
        id: id ?? _editedProduct.id,
        title: title ?? _editedProduct.title,
        description: description ?? _editedProduct.description,
        imageUrl: imageUrl ?? _editedProduct.imageUrl,
        price: _editedProduct.price,
        isFavorite: _editedProduct.isFavorite);
  }
}
// TODO
// For short forms
// Form(
//             child: ListView(
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Title',
//               ),
//               textInputAction: TextInputAction.next,
//             )
//           ],
//         ))

// For long forms and landscape mode
//     Form(
//         child: SingleChildScrollView(
//             child: Column(
//                 children: [ ... ],
//             ),
//         ),
//     ),

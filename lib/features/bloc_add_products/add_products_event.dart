part of 'add_products_bloc.dart';

sealed class AddProductsEvent extends Equatable {
  const AddProductsEvent();
}

class LoadAddProductsEvent extends AddProductsEvent {
  const LoadAddProductsEvent({
    required this.token,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.phone,
    required this.photos,
    required this.name,
    required this.description,
    required this.price,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.address,
    required this.category,
  });

  final String token;
  final String email;
  final String firstName;
  final String lastName;
  final String middleName;
  final String phone;
  final List<File>  photos;
  final String name;
  final String description;
  final String price;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final String address;
  final int category;

  @override
  List<Object?> get props => [
        token,
        email,
        firstName,
        lastName,
        middleName,
        phone,
        photos,
        name,
        description,
        price,
        ownerName,
        ownerPhone,
        ownerEmail,
        address,
        category,
      ];
}

import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:russsia_carrot/data/event_bus.dart';
import 'package:russsia_carrot/features/bloc_add_products/add_products_bloc.dart';
import 'package:russsia_carrot/features/bloc_category/category_product_bloc.dart';
import 'package:russsia_carrot/features/bloc_profile/profile_bloc.dart';
import 'package:russsia_carrot/features/cubit_save_token/save_token_cubit.dart';
import 'package:russsia_carrot/generated/assets.dart';
import 'package:russsia_carrot/repository/abstract_repository.dart';
import 'package:russsia_carrot/theme/color_res.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import "package:auto_size_text/auto_size_text.dart";
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/cubit_save_email/save_eamail_cubit.dart';
import '../../features/cubit_save_name/save_number_cubit.dart';
import '../../features/cubit_save_number/save_name_cubit.dart';
import '../../router/router.dart';

@RoutePage()
class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final limitCategory = ValueNotifier(100);
  final _blocCategory = CategoryProductBloc(GetIt.I<AbstractRepository>());
  final _blocProfile = ProfileBloc(GetIt.I<AbstractRepository>());
  final _blocProducts = AddProductsBloc(GetIt.I<AbstractRepository>());
  String? selectedCategory;
  final TextEditingController _controllerNameProduct = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  int categoryId = 0;
  late String token;
  bool loadingAdd = false;
  final eventBus = GetIt.I<EventBus>();
  final ValueNotifier<List<File>> _image = ValueNotifier<List<File>>([]);
  final picker = ImagePicker();

  final isNotPusto = ValueNotifier(false);

  bool _updateIsActive() {
    return _controllerNameProduct.text.isNotEmpty &&
        categoryId != 0 &&
        _controllerPrice.text.isNotEmpty &&
        _controllerDesc.text.isNotEmpty &&
        _image.value.isNotEmpty &&
        _controllerAddress.text.isNotEmpty &&
        (context.read<SaveNameCubit>().state.name.isEmpty
            ? _controllerName.text.isNotEmpty
            : context.read<SaveNameCubit>().state.name.isNotEmpty) &&
        (context.read<SaveEamailCubit>().state.email.isEmpty
            ? _controllerEmail.text.isNotEmpty
            : context.read<SaveEamailCubit>().state.email.isNotEmpty) &&
        (context.read<SaveNumberCubit>().state.number.isEmpty
            ? _controllerPhone.text.isNotEmpty
            : context.read<SaveNumberCubit>().state.number.isNotEmpty);
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _image.value.addAll(
              pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
        });
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  void checkTextField() {
    if (_controllerNameProduct.text.isNotEmpty &&
        _controllerPrice.text.isNotEmpty &&
        _controllerDesc.text.isNotEmpty &&
        _controllerAddress.text.isNotEmpty &&
        (context.read<SaveNameCubit>().state.name.isEmpty
            ? _controllerName.text.isNotEmpty
            : context.read<SaveNameCubit>().state.name.isNotEmpty) &&
        (context.read<SaveEamailCubit>().state.email.isEmpty
            ? _controllerEmail.text.isNotEmpty
            : context.read<SaveEamailCubit>().state.email.isNotEmpty) &&
        (context.read<SaveNumberCubit>().state.number.isEmpty
            ? _controllerPhone.text.isNotEmpty
            : context.read<SaveNumberCubit>().state.number.isNotEmpty)) {
      isNotPusto.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      token = context.read<SaveTokenCubit>().state.token;
      if (token.isEmpty) {
        Navigator.of(context).pop();
        AutoRouter.of(context)
            .replaceAll([const MainRoute(), const MainAuthRoute()]);
      } else {
        eventBus.on<UpdateCreate>().listen((event) {
          loadData();
        });
        loadData();
      }
    });
  }

  void loadData() {
    _blocCategory.add(LoadCategoryProductEvent(limit: limitCategory.value));
    _blocProfile.add(LoadProfileEvent(token: token));
  }

  @override
  Widget build(BuildContext context) {
    token = context.read<SaveTokenCubit>().state.token;
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: _blocProfile,
          builder: (context, stateProfile) {
            if (stateProfile is LoadedProfileState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      const Text(
                        "Создать объявление",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Для успешной продажи укажите как можно больше подробностей",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 17),
                      requiredText("Наименование"),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _controllerNameProduct,
                        onChanged: (value) {
                          checkTextField();
                        },
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: ColorRes.grey,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Пример: Samsung Galaxy S23",
                            hintStyle: TextStyle(
                              color: ColorRes.greyHint,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 17)),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 21),
                      requiredText("Категория"),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: ColorRes.grey,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        width: double.infinity,
                        child: BlocBuilder<CategoryProductBloc,
                            CategoryProductState>(
                          bloc: _blocCategory,
                          builder: (context, state) {
                            if (state is CategoryProductLoaded) {
                              final categories = [
                                'Выберите категорию',
                                ...state.categoryModel.results
                                    .map((e) => e.name)
                              ];
                              return DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  value: selectedCategory,
                                  iconStyleData: IconStyleData(
                                    icon:
                                        SvgPicture.asset(Assets.iconsArrowDown),
                                    iconSize: 24,
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                  dropdownStyleData: DropdownStyleData(
                                    useSafeArea: false,
                                    decoration: BoxDecoration(
                                      color: ColorRes.grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    maxHeight: 200,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCategory = newValue;
                                    });

                                    checkTextField();
                                  },
                                  items: categories
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      onTap: () {
                                        var resultList =
                                            state.categoryModel.results;
                                        for (int i = 0;
                                            resultList.length > i;
                                            i++) {
                                          if (resultList[i].name == value) {
                                            categoryId = state
                                                .categoryModel.results[i].id;
                                            break;
                                          }
                                        }
                                      },
                                      value: value == 'Выберите категорию'
                                          ? null
                                          : value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  selectedItemBuilder: (BuildContext context) {
                                    return categories
                                        .map<Widget>((String value) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          selectedCategory ??
                                              'Выберите категорию',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: ColorRes.grey,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (state is CategoryProductErrorState) {
                              return Center(
                                child: Text(state.exception.toString()),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      requiredText("Цена"),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _controllerPrice,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          checkTextField();
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: ColorRes.grey,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 17)),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Фото",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      ValueListenableBuilder(
                          valueListenable: _image,
                          builder: (context, value, child) {
                            return GestureDetector(
                              onTap: () {
                                _pickImages();
                                checkTextField();
                              },
                              child: _image.value.isEmpty
                                  ? Container(
                                      height: 110,
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: ColorRes.grey),
                                      child: Center(
                                        child: SvgPicture.asset(
                                            Assets.iconsImageAdd),
                                      ))
                                  : Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: ColorRes.grey),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 110,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _image.value.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0,
                                                          bottom: 24.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.file(
                                                      _image.value[index],
                                                      height: 90,
                                                      width: 90,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const Text(
                                            "Добавить еще",
                                            style: TextStyle(
                                                color: ColorRes.orange,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    ColorRes.orange),
                                          )
                                        ],
                                      ),
                                    ),
                            );
                          }),
                      const SizedBox(height: 24),
                      requiredText("Описание"),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorRes.grey),
                        constraints: const BoxConstraints(maxHeight: 110),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          onChanged: (value) {
                            checkTextField();
                          },
                          controller: _controllerDesc,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 17),
                              counterStyle: TextStyle(color: Colors.white)),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          maxLength: 9000,
                          maxLines: null,
                          minLines: 1,
                        ),
                      ),
                      const SizedBox(height: 13),
                      const Text(
                        "Введите не менее 30 символов",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Контактные данные",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _controllerAddress,
                        onChanged: (value) {
                          checkTextField();
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorRes.grey,
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Ваш город",
                            hintStyle:
                                const TextStyle(color: ColorRes.greyHint),
                            prefixIcon: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(Assets.iconsLocation)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 17)),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 14),
                      // Row(
                      //   children: [
                      //     SvgPicture.asset(Assets.iconsGeoPosition),
                      //     const SizedBox(width: 7),
                      //     const Expanded(
                      //       child: AutoSizeText(
                      //         "Ваше местоположение будет определено автоматически. Если данные неверны, введите их вручную.",
                      //         maxLines: 2,
                      //         minFontSize: 10,
                      //         style: TextStyle(
                      //             fontSize: 10,
                      //             fontWeight: FontWeight.w400,
                      //             color: Colors.white),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      const SizedBox(height: 23),
                      Visibility(
                        visible:
                            context.read<SaveNameCubit>().state.name.isEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            requiredText("Ваше имя"),
                            const SizedBox(height: 10),
                            TextField(
                              onChanged: (value) {
                                checkTextField();
                              },
                              controller: _controllerName,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: ColorRes.grey,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 17)),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),

                      Visibility(
                        visible:
                            context.read<SaveEamailCubit>().state.email.isEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            requiredText("Email"),
                            const SizedBox(height: 10),
                            TextField(
                              onChanged: (value) {
                                checkTextField();
                              },
                              controller: _controllerEmail,
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: ColorRes.grey,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 17)),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: context
                            .read<SaveNumberCubit>()
                            .state
                            .number
                            .isEmpty,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              requiredText("Телефон"),
                              const SizedBox(height: 10),
                              TextField(
                                onChanged: (value) {
                                  checkTextField();
                                },
                                controller: _controllerPhone,
                                decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: ColorRes.grey,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 17)),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                      ),
                      const SizedBox(height: 31),
                      BlocBuilder<AddProductsBloc, AddProductsState>(
                        bloc: _blocProducts,
                        builder: (context, state) {
                          if (state is LoadedAddProductsState) {
                            Future.delayed(Duration.zero, () async {
                              _controllerEmail.clear();
                              _controllerPhone.clear();
                              _controllerName.clear();
                              _controllerDesc.clear();
                              _controllerAddress.clear();
                              _controllerNameProduct.clear();
                              _controllerPrice.clear();
                              _image.value = [];
                              eventBus.fire(UpdateMainList());
                              loadingAdd = false;
                              isNotPusto.value = false;
                              _blocCategory.add(LoadCategoryProductEvent(
                                  limit: limitCategory.value));
                              _blocCategory.add(LoadCategoryProductEvent(
                                  limit: limitCategory.value));
                              Navigator.of(context).pop();
                              AutoRouter.of(context).replaceAll(
                                  [CreateRoute(), AllProductRoute()]);
                            });
                          }
                          if (state is LoadingAddProductsState) {
                            loadingAdd = true;
                          }
                          if (state is ErrorAddProductsState) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(state.exception.toString())),
                              );
                            });
                          }
                          return GestureDetector(
                            onTap: () {
                              if (_updateIsActive()) {
                                if (context
                                    .read<SaveNumberCubit>()
                                    .state
                                    .number
                                    .isEmpty) {
                                  context
                                      .read<SaveNumberCubit>()
                                      .saveNumber(_controllerPhone.text);
                                }
                                if (context
                                    .read<SaveNameCubit>()
                                    .state
                                    .name
                                    .isEmpty) {
                                  context
                                      .read<SaveNameCubit>()
                                      .saveNumber(_controllerName.text);
                                }
                                if (context
                                    .read<SaveEamailCubit>()
                                    .state
                                    .email
                                    .isEmpty) {
                                  context
                                      .read<SaveEamailCubit>()
                                      .saveEmail(_controllerEmail.text);
                                }

                                _blocProducts.add(LoadAddProductsEvent(
                                  token: token,
                                  price: _controllerPrice.text,
                                  category: categoryId,
                                  address: _controllerAddress.text,
                                  description: _controllerDesc.text,
                                  email: context
                                          .read<SaveEamailCubit>()
                                          .state
                                          .email
                                          .isEmpty
                                      ? _controllerEmail.text
                                      : context
                                          .read<SaveEamailCubit>()
                                          .state
                                          .email,
                                  firstName: stateProfile.owner.firstName,
                                  ownerEmail: stateProfile.owner.email,
                                  lastName: stateProfile.owner.lastName,
                                  middleName: stateProfile.owner.middleName,
                                  name: _controllerNameProduct.text,
                                  ownerName: context
                                          .read<SaveNameCubit>()
                                          .state
                                          .name
                                          .isEmpty
                                      ? _controllerName.text
                                      : context
                                          .read<SaveNameCubit>()
                                          .state
                                          .name,
                                  ownerPhone: context
                                          .read<SaveNumberCubit>()
                                          .state
                                          .number
                                          .isEmpty
                                      ? _controllerPhone.text
                                      : context
                                          .read<SaveNumberCubit>()
                                          .state
                                          .number,
                                  phone: stateProfile.owner.phone,
                                  photos: _image.value,
                                ));
                                // setState(() {});
                              }
                            },
                            child: ValueListenableBuilder(
                              valueListenable: isNotPusto,
                              builder: (context, value, child) => Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: isNotPusto.value
                                        ? ColorRes.orange
                                        : ColorRes.greyHint),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                child: loadingAdd
                                    ? const CupertinoActivityIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        "Опубликовать",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 34),
                    ],
                  ),
                ),
              );
            }
            if (stateProfile is ErrorProfileState) {
              return Center(
                child: Text(stateProfile.exception.toString()),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget requiredText(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$text ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const TextSpan(
            text: "*",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorRes.red,
            ),
          ),
        ],
      ),
    );
  }
}

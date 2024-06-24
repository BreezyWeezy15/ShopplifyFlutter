import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniture_flutter_app/auth_bloc/furniture_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/payment_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_event.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_state.dart';
import 'package:furniture_flutter_app/models/CartModel.dart';
import 'package:furniture_flutter_app/storage/storage_helper.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:furniture_flutter_app/widgets/bookmark_info.dart';
import 'package:furniture_flutter_app/widgets/custom_container.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../auth_bloc/shop_bloc.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String bookMarkImage = "assets/images/bookmark_unfilled.png";
  late String itemID;
  late String route = "";
  bool isAdded = false;
  @override
  void initState() {
    super.initState();
    itemID = Get.arguments;
    BlocProvider.of<FurnitureBloc>(context).add(GetUserFavItemsEvent());
    BlocProvider.of<FurnitureBloc>(context).add(GetItemEvent(itemID));
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<PaymentBloc,ShopBlocState>(
              listener: (context,state){
                if(state is GetCreateItemState){
                  if(state.result.contains("Successfully")){
                    Fluttertoast.showToast(msg: "Item successfully added");
                    Get.toNamed(Utils.cartRoute);
                  }
                  else {
                    Fluttertoast.showToast(msg: "Failed to add item in cart");
                  }
                }
              }),
          BlocListener<FurnitureBloc,ShopBlocState>(
              listener: (context,state){
                if(state is GetUserFavItemsState){
                  if(state.list.isNotEmpty){
                    for (var element in state.list) {
                      if(element?.id == itemID){
                        setState(() {
                          isAdded = true;
                          bookMarkImage = "assets/images/bookmark_filled.png";
                        });
                      }
                    }
                  }
                }
                else if(state is GetRemoveItemState){
                  Fluttertoast.showToast(msg: state.message);
                }
                else if(state is UploadFavItemState){
                  Fluttertoast.showToast(msg: state.message);
                }
              })
        ],
        child: SafeArea(
          child: Scaffold(
            body: BlocBuilder<FurnitureBloc,ShopBlocState>(
                buildWhen: (context,state){
                  return state is GetItemState;
                },
                builder: (context,state){
                  if(state is LOADING){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  else if (state is ERROR){
                    return Center(
                      child: Text(state.e,style: getArimoBold().copyWith(fontSize: 20),),
                    );
                  }
                  else if (state is GetItemState){
                    var data = state.furnitureModel;
                    return Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                FadeInImage(
                                  placeholder: const AssetImage("assets/images/no_image.png"),
                                  image: NetworkImage(data!.image!),
                                  width: double.maxFinite,height: 300,
                                  fit: BoxFit.fill,
                                  filterQuality: FilterQuality.high,),
                                Positioned(
                                  top: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: ()  {
                                      if(StorageHelper.getPosition() == 0){
                                        BlocProvider.of<ShopBloc>(context).add(GetUserDataEvent());
                                        BlocProvider.of<ShopBloc>(context).add(GetFurnitureEvent("Lamp"));
                                      } else if (StorageHelper.getPosition() == 1){
                                        BlocProvider.of<FurnitureBloc>(context).add(SearchFurnitureEvent(""));
                                      } else if (StorageHelper.getPosition() == 2){
                                        BlocProvider.of<PaymentBloc>(context).add(GetUserFavItemsEvent());
                                      } else if (StorageHelper.getPosition() == 3){
                                        BlocProvider.of<ShopBloc>(context).add(GetFurnitureEvent("All"));
                                      }
                                      Get.back();
                                    },
                                    child: Image.asset("assets/images/arrow_back.png",width: 30,height: 30,),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Text(data.title!,style: getArimoBold().copyWith(fontSize: 25),)),
                                  const Gap(20),
                                  BookmarkIcon(isAdded: isAdded, onTap: (){
                                    if(isAdded){
                                      setState(() {
                                        isAdded = false;
                                      });
                                      BlocProvider.of<FurnitureBloc>(context).add(GeRemoveItemEvent(itemID));
                                    } else {
                                      setState(() {
                                        isAdded = true;
                                      });
                                      BlocProvider.of<FurnitureBloc>(context).add(UploadFavItemEvent(data));
                                    }
                                  })
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                              child: Text("Unit: ${data.price!}\$",style: getArimoRegular().copyWith(fontSize: 30),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                              child: Text("Product Details",style: getArimoRegular().copyWith(fontSize: 22),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                              child: Text(data.description!,style: getArimoRegular().copyWith(fontSize: 20),),
                            )
                          ],
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: CustomContainer(text: "Add To Cart", onClick: (){
                            CartModel cartModel = CartModel(
                                image: data.image!,
                                title: data.title!,
                                description: data.description!,
                                reviews: data.reviews!,
                                furnitureID: data.id!,
                                price: data.price!,
                                totalPrice: 0.0,
                                quantity: 0,
                                category: data.category!);
                            BlocProvider.of<PaymentBloc>(context).add(GetCreateItemEvent(cartModel));
                          }, color: Colors.blueGrey),
                        )
                      ],
                    );
                  }
                  else {
                    return const Center(
                        child: SpinKitFadingFour(size: 50,color: Colors.black54));
                  }
                }),
          ),
        ));
  }
}

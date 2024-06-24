import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniture_flutter_app/auth_bloc/furniture_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/payment_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_event.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_state.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:furniture_flutter_app/widgets/custom_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../storage/storage_helper.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FurnitureBloc>(context).add(GetUserFavItemsEvent());
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<FurnitureBloc,ShopBlocState>(
        listenWhen: (context,state){
          return state is GetRemoveItemState;
        },
        listener: (context,state){
          BlocProvider.of<FurnitureBloc>(context).add(GetUserFavItemsEvent());
          Fluttertoast.showToast(msg: (state as GetRemoveItemState).message);
        },
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16),bottomLeft: Radius.circular(16)),
                        color: Colors.grey.shade200
                    ),
                    child: Center(
                      child: Text("Favourites",style: getArimoRegular().copyWith(fontSize: 25),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: BlocBuilder<FurnitureBloc,ShopBlocState>(
                      builder: (context,state){
                        if(state is LOADING){
                          return const CustomWidget(height : 1.2,widget: "progressBar", message: null);
                        }
                        else if (state is ERROR){
                          return  CustomWidget(height: 1.2, widget: "text", message: state.e.toString());
                        }
                        else if (state is GetUserFavItemsState){
                          var data = state.list;
                          if(data.isNotEmpty){
                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.8, // Adjust the aspect ratio to ensure cards are not too tall
                              ),
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: const EdgeInsets.all(10),
                                  color: Colors.grey.shade200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: FadeInImage(
                                                image: NetworkImage(data[index]!.image!),
                                                placeholder: const AssetImage("assets/images/no_image.png"),
                                                filterQuality: FilterQuality.high,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 180,
                                                fadeInDuration: const Duration(milliseconds: 500),
                                              ),
                                            ),
                                            Positioned(
                                              right: 10,
                                              top: 10,
                                              child: GestureDetector(
                                                onTap: (){
                                                  showDialog(
                                                      context: context,
                                                      builder: (_){
                                                        return AlertDialog(
                                                          title: Text("Delete Item",style: getArimoBold().copyWith(fontSize: 20),),
                                                          content: Text("Are you sure you want to delete this item?",style: getArimoBold().copyWith(fontSize: 18),),
                                                          actions: [
                                                            ElevatedButton(onPressed: (){
                                                              BlocProvider.of<FurnitureBloc>(context).add(GeRemoveItemEvent(data[index]!.id!));
                                                              Navigator.pop(context);
                                                            }, child: Text("Yes",style: getArimoBold().copyWith(fontSize: 20),)),
                                                            ElevatedButton(onPressed: (){
                                                              Navigator.pop(context);
                                                            }, child: Text("No",style: getArimoRegular().copyWith(fontSize: 20),))
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Image.asset("assets/images/delete.png",width: 25,height: 25,),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child:  Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data[index]!.title!,
                                                      style: getArimoBold().copyWith(fontSize: 15),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      "${data[index]?.price}\$",
                                                      style: getArimoRegular().copyWith(fontSize: 15),
                                                    ),
                                                  ],
                                                )),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    StorageHelper.setPosition(2);
                                                    Get.toNamed(Utils.detailsRoute,arguments: data[index]?.id!);
                                                  },
                                                  child: Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                    child: Center(
                                                      child: Image.asset(
                                                        "assets/images/arrow.png",
                                                        width: 15,
                                                        height: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          else {
                            return  const CustomWidget(height: 1.2, widget: "text", message: "No Fav Items");
                          }
                        }
                        else {
                          return  const CustomWidget(height: 1.2, widget: "text", message: "No Fav Items");
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),);
  }
}

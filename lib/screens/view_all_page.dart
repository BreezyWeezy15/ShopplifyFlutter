import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/payment_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_event.dart';
import 'package:furniture_flutter_app/storage/storage_helper.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:furniture_flutter_app/widgets/custom_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../auth_bloc/furniture_bloc.dart';
import '../auth_bloc/shop_bloc_state.dart';

class ViewAllPage extends StatefulWidget {
  const ViewAllPage({super.key});

  @override
  State<ViewAllPage> createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShopBloc>(context).add(GetFurnitureEvent("All"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              child: Text("All Items",style: getArimoRegular().copyWith(fontSize: 25),),
            ),
          ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: BlocBuilder<ShopBloc,ShopBlocState>(
                  builder: (context,state){
                    if(state is LOADING){
                      return const CustomWidget(height : 1.5,widget: "progressBar", message: null);
                    }
                    else if (state is ERROR){
                      return CustomWidget(height: 1.5,widget: "text", message: state.e.toString());
                    }
                    else if(state is GetFurnitureState){
                      var data = state.furniture;
                      if(data.isNotEmpty){
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: FadeInImage(
                                        image: NetworkImage(data[index]!.image!),
                                        placeholder: const AssetImage("assets/images/no_image.png"),
                                        fit: BoxFit.cover,
                                        width: double.maxFinite,
                                        height: 180,
                                        filterQuality: FilterQuality.high,
                                        fadeInDuration: const Duration(milliseconds: 500),
                                      ),
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
                                                  "${data[index]!.price} %36s",
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
                                                StorageHelper.setPosition(3);
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
                        return  const CustomWidget(height: 1.5,widget: "text", message: "No Furniture Found");
                      }
                    }
                    else {
                      return  const CustomWidget(height: 1.5,widget: "text", message: "No Furniture Found");
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

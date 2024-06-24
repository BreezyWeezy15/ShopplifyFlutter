
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/furniture_bloc.dart';
import 'package:furniture_flutter_app/storage/storage_helper.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../auth_bloc/shop_bloc.dart';
import '../auth_bloc/shop_bloc_event.dart';
import '../auth_bloc/shop_bloc_state.dart';
import '../utils.dart';
import '../widgets/custom_widget.dart';

class FurniturePage extends StatefulWidget {
  const FurniturePage({super.key});

  @override
  State<FurniturePage> createState() => _FurniturePageState();
}

class _FurniturePageState extends State<FurniturePage> {
  String userImage = "";
  final List<String> _titles = ["Lamp","Chair","Table","Sofa","Bed"];
  final List<String> _images = [
    "assets/images/lamp.png",
    "assets/images/chair.png",
    "assets/images/table.png",
    "assets/images/sofa.png",
    "assets/images/bed.png"
  ];
  late int selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShopBloc>(context).add(GetUserDataEvent());
    BlocProvider.of<ShopBloc>(context).add(GetFurnitureEvent(_titles[0]));
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc,ShopBlocState>(
        listener: (context,state){
           if(state is GetUserDataState){
              setState(() {
                 userImage =  state.userModel.userImage!;
              });
              StorageHelper.saveInfo(state.userModel.name!, state.userModel.email!, state.userModel.phone!);
           }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_setDayTime(),style: getArimoBold().copyWith(fontSize: 34),),
                        Text("Welcome back",style: getArimoRegular().copyWith(fontSize: 20),)
                      ],
                    )),
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(Utils.cartRoute);
                      },
                      child : Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.grey.shade200
                        ),
                        child: const Center(child: Icon(Icons.add_shopping_cart,size: 20,),),
                      ),
                    ),
                    const Gap(10),
                    Center(
                      child: CircleAvatar(
                        radius: 20,
                        foregroundImage: NetworkImage(userImage),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset("assets/images/banner.png",fit: BoxFit.cover,
                    height: 200,width: double.maxFinite,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25,right: 20,top: 20),
                child: Row(
                  children: [
                    Expanded(flex: 2,child: Text("Choose Category",style: getArimoBold().copyWith(fontSize: 25),),),
                    Expanded(child: GestureDetector(
                      onTap: (){
                        Get.toNamed(Utils.viewAllRoute);
                      },
                      child: Text("View All",style: getArimoRegular().copyWith(fontSize: 18),
                        textAlign: TextAlign.end,),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  height: 130,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _titles.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedCategory = index;
                            });
                            BlocProvider.of<ShopBloc>(context).add(GetFurnitureEvent(_titles[index]));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: selectedCategory == index ? Colors.black : Colors.grey.shade200,
                                ),
                                child: Center(child: Image.asset(_images[index],filterQuality: FilterQuality.high,
                                  width: 40,height: 40,color: Colors.grey.shade500,),),
                              ),
                              const SizedBox(height: 5,),
                              Center(child: Text(_titles[index],style: getArimoRegular().copyWith(fontSize: 16),),)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: BlocBuilder<ShopBloc,ShopBlocState>(
                  builder: (context,state){
                    if(state is LOADING){
                      return const CustomWidget(height : 3,widget: "progressBar", message: null);
                    }
                    else if (state is ERROR){
                      return  CustomWidget(height: 3, widget: "text", message: state.e.toString());
                    }
                    else if(state is GetFurnitureState){
                      var data = state.furniture;
                      if(data.isNotEmpty){
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
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
                                    child:  ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        imageUrl : data[index]!.image!,
                                        placeholder: (context, url) => Image.asset("assets/images/no_image.png"),
                                        width : double.maxFinite,
                                        height: 180,
                                        fit: BoxFit.cover,
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
                                                  "${data[index]!.price}\$",
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
                                              onTap: () {
                                                StorageHelper.setPosition(0);
                                                Get.toNamed(Utils.detailsRoute,arguments:data[index]?.id!);
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
                        return  const CustomWidget(height: 3, widget: "text", message: "No Furniture Found");
                      }
                    }
                    else {
                      return  const CustomWidget(height: 3, widget: "text", message: "No Furniture Found");
                    }
                  },
                ),
              )
            ],
          ),
        ),);
  }
  String _setDayTime(){
    DateFormat dateFormat = DateFormat("hh a");
    DateTime dateTime = DateTime.now();
    String formattedString = dateFormat.format(dateTime);
    if(formattedString.contains("AM")){
      return "Good Morning";
    } else {
      return "Good Evening";
    }
  }

}

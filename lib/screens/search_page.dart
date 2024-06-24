import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../auth_bloc/furniture_bloc.dart';
import '../auth_bloc/shop_bloc_event.dart';
import '../auth_bloc/shop_bloc_state.dart';
import '../storage/storage_helper.dart';
import '../utils.dart';
import '../widgets/custom_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FurnitureBloc>(context).add(SearchFurnitureEvent(""));
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
              child: Text("Search an item",style: getArimoRegular().copyWith(fontSize: 25),),
            ),
          ),
              Padding(
                padding:  const EdgeInsets.all(20),
                child: TextField(
                  controller: _searchController,
                  style: getArimoBold().copyWith(fontSize: 18),
                  onChanged: (value){
                     if(value.isEmpty){
                       BlocProvider.of<FurnitureBloc>(context).add(SearchFurnitureEvent(""));
                     }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      contentPadding:  const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      hintText: "Search..",
                      hintStyle: getArimoRegular().copyWith(fontSize: 18),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          String query = _searchController.text.toString();
                          if(query.isEmpty){
                            Fluttertoast.showToast(msg: "Query cannot be empty");
                            return;
                          }
                          BlocProvider.of<FurnitureBloc>(context).add(SearchFurnitureEvent(query));
                        },
                        child: const Icon(Icons.search,size: 20,),
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: BlocBuilder<FurnitureBloc,ShopBlocState>(
                  builder: (context,state){
                    if(state is LOADING){
                      return const CustomWidget(height : 1.5,widget: "progressBar", message: null);
                    }
                    else if (state is ERROR){
                      return  CustomWidget(height: 1.5, widget: "text", message: state.e.toString());
                    }
                    else if(state is SearchFurnitureState){
                      var data = state.furniture;
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
                                    child: ClipRRect(
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
                                              onTap: (){
                                                StorageHelper.setPosition(1);
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
                        return  const CustomWidget(height: 1.5, widget: "text", message: "No Furniture Found");
                      }
                    }
                    else {
                      return  const CustomWidget(height: 1.5, widget: "text", message: "No Furniture Found");
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

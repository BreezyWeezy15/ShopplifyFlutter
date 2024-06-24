
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniture_flutter_app/auth_bloc/furniture_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/payment_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_event.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_state.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../stripe/stripe_payment_handler.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int quantity = 0;
  double totalPrice = 0.0;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PaymentBloc>(context).add(GetDuesEvent());
    BlocProvider.of<PaymentBloc>(context).add(GetCartItemsEvent());
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc,ShopBlocState>(
        listener: (context,state){
           if(state is GetDeleteItemState){
              if(state.result.contains("Successfully")){
                 BlocProvider.of<PaymentBloc>(context).add(GetDuesEvent());
                 BlocProvider.of<PaymentBloc>(context).add(GetCartItemsEvent());
                 Fluttertoast.showToast(msg: "Item successfully removed");
              } else {
                 Fluttertoast.showToast(msg: "Failed to remove item");
              }
           }
           if(state is GetDeleteCartState){
             // done
             if(state.result.contains("Successfully")){
               BlocProvider.of<PaymentBloc>(context).add(GetDuesEvent());
               BlocProvider.of<PaymentBloc>(context).add(GetCartItemsEvent());
               Fluttertoast.showToast(msg: "Cart successfully cleared");
             } else {
               Fluttertoast.showToast(msg: "Failed to clear cart");
             }
           }
           if(state is GetUpdateItemState){
             if(state.result.contains("Successfully")){
               BlocProvider.of<PaymentBloc>(context).add(GetDuesEvent());
               BlocProvider.of<PaymentBloc>(context).add(GetCartItemsEvent());
             } else {
               Fluttertoast.showToast(msg: "Failed to clear cart item");
             }
           }
        },
        child: SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: ()  {
                              Get.offNamed(Utils.homeRoute);
                            },
                            child: Image.asset("assets/images/arrow_back.png",width: 30,height: 30,),
                          ),
                          const Gap(10),
                          Expanded(child: Text("Cart Items",style: getArimoBold().copyWith(fontSize: 20),)),
                          GestureDetector(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (_){
                                    return AlertDialog(
                                      title: Text("Erase Cart Items",style: getArimoBold().copyWith(fontSize: 18),),
                                      content: Text("Are you sure you want to erase all items?",style: getArimoRegular().copyWith(fontSize: 16),),
                                      actions: [
                                        ElevatedButton(onPressed: (){
                                          BlocProvider.of<PaymentBloc>(context).add(GetDeleteCartEvent());
                                          Navigator.pop(context);
                                        }, child: Text("Yes",style: getArimoBold(),)),
                                        ElevatedButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child: Text("No",style: getArimoBold(),))
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(Icons.delete,size: 30,),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<PaymentBloc,ShopBlocState>(
                        buildWhen: (context,state){
                          return state is GetCartItemsState;
                        },
                        builder: (context,state){
                          if(state is LOADING){
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          else if (state is Error){
                            return Center(child: Text(state.toString(),style: getArimoBold().copyWith(fontSize: 18),));
                          }
                          else if(state is GetCartItemsState){
                            var data = state.list;
                            if(data.isNotEmpty){
                              return Stack(
                                children: [
                                  ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context,index){
                                      return SizedBox(
                                        height: 220,
                                        child: Dismissible(
                                          key: UniqueKey(),
                                          direction: DismissDirection.startToEnd,
                                          onDismissed: (direction){
                                            BlocProvider.of<PaymentBloc>(context).add(GetDeleteItemEvent(data[index]));
                                            setState(() {
                                              quantity = data[index].quantity - 1;
                                              totalPrice = data[index].totalPrice - data[index].price;
                                            });
                                            BlocProvider.of<PaymentBloc>(context).add(GetUpdateItemEvent(
                                                data[index].furnitureID, quantity, totalPrice));
                                          },
                                          child: Card(
                                            margin: const EdgeInsets.all(20),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(16),
                                                    child: Image.network(data[index].image,width: 100,height: 150,fit: BoxFit.cover,
                                                      filterQuality: FilterQuality.high,),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(20),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(data[index].title,style: getArimoBold().copyWith(fontSize: 15),
                                                          maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                        const Gap(10),
                                                        Text("Unit : ${data[index].price}\$",style: getArimoRegular().copyWith(fontSize: 17),),
                                                        const Gap(10),
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: (){
                                                                if(data[index].quantity > 0){
                                                                  setState(() {
                                                                    quantity = data[index].quantity - 1;
                                                                    totalPrice = data[index].totalPrice - data[index].price;
                                                                  });
                                                                  BlocProvider.of<PaymentBloc>(context).add(GetUpdateItemEvent(
                                                                      data[index].furnitureID, quantity, totalPrice));
                                                                }
                                                              },
                                                              child: Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(60),
                                                                    color: Colors.grey.shade300
                                                                ),
                                                                child: const Center(
                                                                  child: Text("-"),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 20,),
                                                            Text(data[index].quantity.toString(),style: getArimoBold().copyWith(fontSize: 20),),
                                                            const SizedBox(width: 20,),
                                                            GestureDetector(
                                                              onTap: (){
                                                                // increase quantity
                                                                setState(() {
                                                                  quantity = data[index].quantity + 1;
                                                                  totalPrice = data[index].totalPrice + data[index].price;
                                                                });
                                                                BlocProvider.of<PaymentBloc>(context).add(GetUpdateItemEvent(
                                                                    data[index].furnitureID, quantity, totalPrice));
                                                              },
                                                              child: Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(60),
                                                                    color: Colors.grey.shade300
                                                                ),
                                                                child: const Center(
                                                                  child: Text("+"),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                            else {
                              return Center(child: Text("No Items In Cart",style: getArimoBold().copyWith(fontSize: 18),));
                            }
                          }
                          else {
                            return Center(child: Text("No Items In Cart",style: getArimoBold().copyWith(fontSize: 18),));
                          }
                        },
                      ),
                    )
                  ],
                )),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.maxFinite,
                  height: 70,
                  decoration:  BoxDecoration(
                      color: Colors.grey.shade200
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text("Due :",style: getArimoBold().copyWith(fontSize: 20),),),
                      BlocBuilder<PaymentBloc,ShopBlocState>(
                         buildWhen: (context,state){
                           return state is GetDuesState;
                         },
                          builder: (context,state){
                            if(state is GetDuesState){
                              return GestureDetector(
                                onTap: () async {
                                  if(state.total == 0){
                                    Fluttertoast.showToast(msg: "Total cannot be 0");
                                    return;
                                  }
                                  await StripePaymentHandler.stripeMakePayment(state.total);
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.blueGrey
                                    ),
                                    child: Text("Pay ${state.total}",style: getArimoBold().copyWith(fontSize: 14,color: Colors.white))),
                              );
                            }
                            return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.blueGrey
                                ),
                                child: Text("Pay 0.0",style: getArimoBold().copyWith(fontSize: 14,color: Colors.white)));
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
     );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/payment_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_event.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:furniture_flutter_app/widgets/custom_button_container.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PaymentBloc>(context).add(GetDeleteCartEvent());
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Expanded(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/success.png",width: 150,height: 150,fit: BoxFit.cover,),
                const Gap(30),
                Text("Item Bought Successfully",style: getArimoBold().copyWith(fontSize: 20)),
                const Gap(30),
                CustomButtonContainer(text: "Finish", onTap: (){Get.offNamed(Utils.homeRoute);},
                    color: Colors.deepOrange,marginTop: 30, isLoading: false,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:furniture_flutter_app/storage/storage_helper.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StripePaymentHandler {
  static Map<String, dynamic>? _paymentIntent;
  static Future<void> stripeMakePayment(double total) async {
    try {
      _paymentIntent = await _createPaymentIntent(total, 'EUR');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              billingDetails: BillingDetails(
                  name: StorageHelper.getName(),
                  email: StorageHelper.getEmail(),
                  phone: StorageHelper.getPhone(),
                  address: const Address(
                      city: 'Paris',
                      country: 'France',
                      line1: 'Rue de Marseille 150',
                      line2: 'Rue de Paris 10/57',
                      postalCode: '75000',
                      state: 'Paris')),
              paymentIntentClientSecret: _paymentIntent!['client_secret'], //Gotten from payment intent
              style: ThemeMode.dark,
              merchantDisplayName: 'Taki Eddine Gastalli'))
          .then((value) {  _displayPaymentSheet(); });

    } catch (e) {
      print("Stripe $e");
    }
  }
  static _displayPaymentSheet() async {
    try {
      var result = await Stripe.instance.presentPaymentSheet();
      print("Result : " + result.toString());
      Get.offNamed(Utils.successRoute);
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Stripe $e");
      } else {
        print("Stripe $e");
      }
    }
  }
  static _createPaymentIntent(double amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': _calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'), headers: {
          'Authorization': 'Bearer ${Utils.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        }, body: body,);
      return json.decode(response.body);
    } catch (err) {
      print("Stripe $err");
      throw Exception(err.toString());
    }
  }
  static String _calculateAmount(double amount) {
    final calculatedAmount = (amount * 100).toInt();
    return calculatedAmount.toString();
  }
}

import 'package:bitcoin_ticker/crypto_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'crypto_card.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropDownButton() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    //using for-in loops
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
            getRate();
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getRate();
        });
      },
      children: pickerItems,
    );
  }

  //store all the values of the cryptocurrencies into a Map
  Map<String, String> coinValues = {};

  //display '?' whilst we wait for the rate data to get come back.
  bool isWaiting = false;

  void getRate() async {
    isWaiting = true;

    try {
      var data = await CoinData().getCoinData(selectedCurrency);

      isWaiting = false;

      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    getRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CrytoCard(
            crytoCurrency: 'BTC',
            selectedCurrency: selectedCurrency,
            value: isWaiting ? '?' : coinValues['BTC'],
          ),
          CrytoCard(
            crytoCurrency: 'ETH',
            selectedCurrency: selectedCurrency,
            value: isWaiting ? '?' : coinValues['ETH'],
          ),
          CrytoCard(
            crytoCurrency: 'LTC',
            selectedCurrency: selectedCurrency,
            value: isWaiting ? '?' : coinValues['LTC'],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDownButton(),
          ),
        ],
      ),
    );
  }
}

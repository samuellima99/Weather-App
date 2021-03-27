import 'dart:convert';

import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tempo APP',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: MyHomePage(),
    );
  }
}

// Future<Map> getData() async {
//   var response = await http.get(Uri.parse(
//       'https://api.hgbrasil.com/weather?key=18dd4bc7&city_name=Fortaleza'));

//   return json.decode(response.body);
// }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  int temp;
  List<dynamic> forecast;
  bool show = false;
  String conditionCode;

  var cityController = TextEditingController();

  Future<Map> fecthData() async {
    String city;

    setState(() {
      city = cityController.text;
    });

    var response = await http.get(Uri.parse(
        'https://api.hgbrasil.com/weather?key=77486243&city_name=$city'));

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      show = true;
    }

    return data;
  }

  void _incrementCounter() {
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(conditionCode);
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Image.asset('images/logo.png'),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 16, top: 60.0)),
              GradientText(
                text: 'Bem-vindo(a),',
                colors: <Color>[
                  Color.fromRGBO(98, 98, 98, 1),
                  Color.fromRGBO(98, 98, 98, 1)
                ],
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              GradientText(
                text: ' ao weather',
                colors: <Color>[
                  Color.fromRGBO(255, 101, 58, 1),
                  Color.fromRGBO(236, 3, 87, 1)
                ],
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Form(
              child: Row(
                children: [
                  Flexible(
                      child: TextFormField(
                          controller: cityController,
                          validator: (valor) {
                            if (valor.isEmpty) {
                              return 'Informe a primeira nota!';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Color.fromRGBO(156, 156, 156, 1),
                              fontSize: 18.0),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(243, 243, 243, 1),
                              hintText: 'Informe uma cidade',
                              hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromRGBO(168, 168, 179, 1)),
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(41, 41, 46, 1)),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.red, width: 0.0),
                              ),
                              focusedErrorBorder: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.red, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(197, 197, 197, 1)),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: "Cidade",
                              labelStyle: TextStyle(
                                  fontSize: 20.0,
                                  color: Color.fromRGBO(156, 156, 156, 1))))),
                  Container(
                    margin: EdgeInsets.only(left: 8.0),
                    width: 60,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 101, 58, 1),
                          Color.fromRGBO(236, 3, 87, 1)
                        ],
                        begin: FractionalOffset.centerLeft,
                        end: FractionalOffset.centerRight,
                      ),
                    ),
                    child: TextButton(
                      child: Icon(
                        Icons.search,
                        size: 32.0,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        fecthData();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 30.0)),
          Column(
            children: [
              FutureBuilder<Map>(
                  future: fecthData(),
                  builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('Sem dados!');
                        break;
                      case ConnectionState.waiting:
                        return SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        );
                        break;
                      default:
                        if (snapshot.hasData) {
                          temp = snapshot.data['results']['temp'];
                          conditionCode =
                              snapshot.data['results']['condition_code'];
                          forecast = snapshot.data['results']['forecast'];

                          return Column(children: [
                            Text(
                              snapshot.data['results']['city'],
                              style: TextStyle(
                                  fontSize: 48.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(45, 45, 45, 1)),
                            ),
                            Text(
                              snapshot.data['results']['description'],
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color.fromRGBO(156, 156, 156, 1)),
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            GradientText(
                              text: '$tempº',
                              colors: <Color>[
                                Color.fromRGBO(255, 101, 58, 1),
                                Color.fromRGBO(236, 3, 87, 1)
                              ],
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold),
                            ),
                            Padding(padding: EdgeInsets.only(top: 30.0)),
                            Container(
                                height: 260,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24.0),
                                    topRight: Radius.circular(24.0),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromRGBO(255, 101, 58, 1),
                                      Color.fromRGBO(236, 3, 87, 1)
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: 50.0)),
                                        Text(
                                          'Previsão do tempo para os próximos dias.',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: ListView(
                                          padding: EdgeInsets.only(
                                              top: 10.0,
                                              bottom: 32.0,
                                              left: 32.0,
                                              right: 32.0),
                                          scrollDirection: Axis.horizontal,
                                          children: <Widget>[
                                            for (var i = 0;
                                                i < forecast.length;
                                                i++)
                                              Container(
                                                padding: EdgeInsets.all(16.0),
                                                width: 140.0,
                                                height: 80.0,
                                                color: Colors.white,
                                                margin: EdgeInsets.only(
                                                    right: 16.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 4.0)),
                                                    Text(forecast[i]['weekday'],
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromRGBO(
                                                                    45,
                                                                    45,
                                                                    45,
                                                                    1))),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 4.0)),
                                                    Text(
                                                        forecast[i]
                                                            ['description'],
                                                        style: TextStyle(
                                                            fontSize: 11.0,
                                                            color:
                                                                Color.fromRGBO(
                                                                    98,
                                                                    98,
                                                                    98,
                                                                    1))),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 4.0)),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Max',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          45,
                                                                          45,
                                                                          45,
                                                                          1))),
                                                          Text('Min',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          45,
                                                                          45,
                                                                          45,
                                                                          1)))
                                                        ]),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Row(children: [
                                                                Text(forecast[i]
                                                                        ['max']
                                                                    .toString()),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_upward,
                                                                  size: 14.0,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          255,
                                                                          101,
                                                                          58,
                                                                          1),
                                                                )
                                                              ]),
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(forecast[
                                                                              i]
                                                                          [
                                                                          'min']
                                                                      .toString()),
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_downward,
                                                                    size: 14.0,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            5,
                                                                            127,
                                                                            239,
                                                                            1),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ]),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ]);
                        } else if (snapshot.hasError) {
                          Text('Erro ao carregar dados...');
                        }
                    }
                  })
            ],
          )
        ],
      ),
    )));
  }
}

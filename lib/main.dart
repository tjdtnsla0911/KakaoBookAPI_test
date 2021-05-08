
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http; //#요놈이 pubspec.yaml에 저장한놈 쓰게함
import 'dart:convert'; // JSON 쓸려면 써야함
void main() {
  print('main 실행 ^^');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  _HttpApp createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> {
  String result = '';
  List data;


  @override
  void initState() {
    print('initState에 왔다능');
    super.initState();
    data = new List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Http Example'),
      ),

      body: Container(
        child: Center(
          child: data.length == 0 ?
          Text('데이터가 없습니다.',
          style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ) : ListView.builder(itemBuilder: (context , index){
              return Card(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text(data[index]['title'].toString()),
                      Text(data[index]['authors'].toString()),
                      Text(data[index]['sale_price'].toString()),
                      Text(data[index]['status'].toString()),

                      Image.network(
                        data[index]['thumbnail'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              );
          },
          itemCount: data.length,),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: ()  { //async도 지웠음

          print('버튼클릭!');
          getJSONData();
          // var url = Uri.parse('https://www.google.com/');
          // var response = await http.get(url);
          // print('response $response');
          // setState(() {
          //   print('setState에옴');
          //     result = response.body;
          // });

        },
        child: Icon(Icons.file_download), //내려받는 모양의 아이콘표시
      ),
    );
  }

  Future<String> getJSONData() async{ //Future는 비동기에서 데이터를 바로 처리할수없을때 사용한다함
    print('getJSONData에 왔어염 ^^');

    var url = Uri.parse('https://dapi.kakao.com/v3/search/book?target=title&query=doit');
    var response = await http.get(url,
        headers: {
          "Authorization" : "KakaoAK 너의kakao RestAPI를 쳐적으시오" //##보안을위해 git갈땐 지우셈
        });
    print('response.body = ${response.body}');
    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      print('dataConvertedToJSON : $dataConvertedToJSON');
      List result = dataConvertedToJSON['documents'];
      data.addAll(result);
    });
    return response.body;
  }
}







import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
  TextEditingController _editingController; //텍스트필드에서 값가져올려면 이거써야함


  @override
  void initState() {
    print('initState에 왔다능');
    super.initState();
    data = new List();
    _editingController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('김스프링의 서점'),
        title: TextField(
          controller: _editingController,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: '검색어입력 ㄱㄱ'),
        ),
      ),

      body: Container(
        child: Center(
          child: data.length == 0 ?
          Text('데이터가 없습니다.',
          style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ) : ListView.builder(itemBuilder: (context , index){
              print('context : $context');
              print('index $index');
            return Card(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      // Text(data[index]['title'].toString()),
                      // Text(data[index]['authors'].toString()),
                      // Text(data[index]['sale_price'].toString()),
                      // Text(data[index]['status'].toString()),

                      Image.network(
                        data[index]['thumbnail'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 150, 
                            //MediaQuery.of(content).size 는 지금 스마트폰의 화면크기
                            child: Text(
                              data[index]['title'].toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text('저자 : ${data[index]['authors'].toString()}'),
                          Text('가격 : ${data[index]['sale_price'].toString()}'),
                          Text('판매중 : ${data[index]['status'].toString()}'),
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start, //Row일땐 가로축기준으로 왼쪽으로정렬,
                    //Column일땐 세로축기준으로 위쪽으로 정렬
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

    var url = Uri.parse('https://dapi.kakao.com/v3/search/book?target=title&query=${_editingController.value.text}');
    var response = await http.get(url,
        headers: {
          "Authorization" : "KakaoAK 니 RestAPI 키" //##보안을위해 git갈땐 지우셈
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






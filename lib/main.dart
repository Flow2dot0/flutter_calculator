import 'package:flutter/material.dart';
import 'package:flutter_calculator/widgets/display.dart';
import 'package:flutter_calculator/widgets/key_pad.dart';
import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Pad(title: 'Calculator'),
    );
  }
}

class Pad extends StatefulWidget {
  final String title;

  Pad({@required this.title});

  @override
  _PadState createState() => _PadState();
}

class _PadState extends State<Pad> {



  handleCaseZeroKeyPad(){
    for(int i = 16 ; i < 20; i++){
      if(myKeyList[i]=='0'){
        KeyPad(
          onPressed: (){},
          label: myKeyList[i],
        );
      }else if(myKeyList[i]==''){
        continue;
      }else{
        KeyPad(
          onPressed: (){},
          label: myKeyList[i],
          backgroundColor: (myKeyList[i] != '='? Colors.blueAccent[200] : Colors.orange),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Display(),
          SizedBox(height: 20.0,),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    for(int i = 0 ; i < 4; i++)
                      KeyPad(
                        onPressed: (){},
                        label: myKeyList[i],
                        backgroundColor: (myKeyList[i] != '/'? Colors.black87 : Colors.orange),
                      )
                  ],
                ),
                SizedBox(height: 5.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    for(int i = 4 ; i < 8; i++)
                      KeyPad(
                        onPressed: (){},
                        label: myKeyList[i],
                        backgroundColor: (myKeyList[i] != 'x'? Colors.blueAccent[200] : Colors.orange),
                      )
                  ],
                ),
                SizedBox(height: 5.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    for(int i = 8 ; i < 12; i++)
                      KeyPad(
                        onPressed: (){},
                        label: myKeyList[i],
                        backgroundColor: (myKeyList[i] != '-'? Colors.blueAccent[200] : Colors.orange),
                      )
                  ],
                ),
                SizedBox(height: 5.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    for(int i = 12 ; i < 16; i++)
                      KeyPad(
                        onPressed: (){},
                        label: myKeyList[i],
                        backgroundColor: (myKeyList[i] != '+'? Colors.blueAccent[200] : Colors.orange),
                      )
                  ],
                ),
                SizedBox(height: 5.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    for(int i = 16 ; i < 20; i++)
                      myKeyList[i] == ''?
                        KeyPad(onPressed: (){}, label: '', backgroundColor: Colors.black87,)
                            :
                        KeyPad(
                          onPressed: (){},
                          label: myKeyList[i],
                          backgroundColor: (myKeyList[i] != '='? Colors.blueAccent[200] : Colors.orange),
                        )
                  ],
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}

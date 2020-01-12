import 'package:flutter/material.dart';
import 'package:flutter_calculator/models/my_number.dart';
import 'package:flutter_calculator/models/operations.dart';
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
      home: Calculator(title: 'Calculator'),
    );
  }
}

class Calculator extends StatefulWidget {

  final String title;

  Calculator({@required this.title});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  bool processingIsActive = false;
  List logs = <String>[];
  List<dynamic> sequences = [null, null, null];
  List<dynamic> previousSequences;
  var index;
  bool didOperation = false;
  double textScaleFactor = 4;


  void allClear(){
    setState(() {
      textScaleFactor = 4;
      index = null;
      processingIsActive = false;
      sequences = [null, null, null];
    });
    previousSequences = null;
    didOperation = false;
  }

  void clear(){
    if(previousSequences!=null){
      setState(() {
        textScaleFactor = 4;
        sequences = [...previousSequences];
        index = sequences[2];
      });
      didOperation = false;
    }else{
      allClear();
    }
    previousSequences = null;
  }

  void resultOperation(){
    if(sequences[2]==null)
      return;

    num res;
    switch(sequences[1]){
      case 'divide' :
        res = Operations.divide(nbLeft: sequences[0].number, nbRight: sequences[2].number);
        break;
      case 'multiply':
        res = Operations.multiply(nbLeft: sequences[0].number, nbRight: sequences[2].number);
        break;
      case 'substract':
        res = Operations.substract(nbLeft: sequences[0].number, nbRight: sequences[2].number);
        break;
      case 'addition':
        res = Operations.addition(nbLeft: sequences[0].number, nbRight: sequences[2].number);
        break;
    }

    if(res!=null){
      previousSequences = [...sequences];
      setState(() {
        sequences = [MyNumber(numberStr: res.toString()), null, null];
        index = sequences[0];
        textScaleFactor = 4;
      });
      didOperation = true;
    }
  }

  void getValuePressed(String string){

    switch(string){
      case 'AC':
        allClear();
        break;
      case 'C':
        clear();
        break;
      case '+/-':
        if(index == null){
          return;
        }else{
          if(sequences[0] != null && sequences[2] == null){
            setState(() {
              index.posNeg();
              textScaleFactor = 4;
            });
          }else if(sequences[2] != null){
            setState(() {
              index.posNeg();
              textScaleFactor = 4;
            });
          }
        }
        break;
      case '%':
        if(index == null){
          return;
        }else{
          if(sequences[0] != null && sequences[2] == null){
            setState(() {
              var operation = Operations.pourcentage(nb: index.number);
              sequences[0] = MyNumber(numberStr: operation.toString());
              index = sequences[0];
              textScaleFactor = 4;
            });
          }else if(sequences[2] != null){
            resultOperation();
          }
        }
        break;
      case '/':
        if(index == sequences[0]){
          setState(() {
            sequences[1] = 'divide';
          });
        }else if(index == sequences[2]){
          resultOperation();
          setState(() {
            sequences[1] = 'divide';
          });
        }
        break;
      case 'x':
        if(index == sequences[0]){
          setState(() {
            sequences[1] = 'multiply';
          });
        }else if(index == sequences[2]){
          resultOperation();
          setState(() {
            sequences[1] = 'multiply';
          });
        }
        break;
      case '-':
        if(index == sequences[0]){
          setState(() {
            sequences[1] = 'substract';
          });
        }else if(index == sequences[2]){
          resultOperation();
          setState(() {
            sequences[1] = 'substract';
          });
        }
        break;
      case '+':
        if(index == sequences[0]){
          setState(() {
            sequences[1] = 'addition';
          });
        }else if(index == sequences[2]){
          resultOperation();
          setState(() {
            sequences[1] = 'addition';
          });
        }
        break;
      case '=':
        resultOperation();
        break;
      case ',':
        if(sequences[0]!=null && sequences[1] == null){
          if(!sequences[0].modeDecimal){
            setState(() {
              index.toDecimal();
            });
          }
        }else if(sequences[0] == null && sequences[1] == null){
          setState(() {
            sequences[0] = MyNumber(numberStr: '0');
            index = sequences[0];
            index.toDecimal();
          });
        }else if(sequences[2]!=null && sequences[1] != null){
          if(!sequences[2].modeDecimal){
            setState(() {
              index.toDecimal();
            });
          }
        }else if(sequences[2] == null && sequences[1] != null){
          setState(() {
            sequences[2] = MyNumber(numberStr: '0');
            index = sequences[2];
            index.toDecimal();
          });
        }
        break;
      default: {
        processingIsActive = true;
        // si ya rien encore de tapé
        if(sequences[0] == null) {
          setState(() {
            sequences[0] = MyNumber(numberStr: string);
            index = sequences[0];
          });
          // si l index est 0
        }else if(sequences[0] == index && sequences[1] == null && sequences[2] == null){
          if(index.modeDecimal){
            setState(() {
              index.addToTheRightAsDecimals(string);
            });
          }else{
            setState(() {
              index.addToTheLeftAsInts(string);
            });
          }
        }else if(sequences[1] != null){
          if(sequences[2] == null){
            setState(() {
              sequences[2] = MyNumber(numberStr: string);
              index = sequences[2];
            });
          }else if(index.modeDecimal){
            setState(() {
              index.addToTheRightAsDecimals(string);
            });
          }else{
            setState(() {
              index.addToTheLeftAsInts(string);
            });
          }

        }
      }
    }
  }

  String applyIndex(){

    if(index == null){
      return '0';
    }else if(index == sequences[0]){
      return formattedDisplay(index.numberStr);
    }else if(index == sequences[1]){
      return formattedDisplay(index.numberStr);
    }else if(index == sequences[2]){
      return formattedDisplay(index.numberStr);
    }
  }

  String removeZeroOnLeft(String str){
    if(str[0]=='0'){
      str[0].replaceRange(0, 0, '');
    }
    return str;
  }

  String toIntIfPossible(String str){
    if(str.contains('.')){
      List<String> edition = str.split('.');
      if(edition[1].length == 1 && edition[1] == '0'){
        str = edition[0];
      }
    }
    return str;
  }

  String handleChangeFontSizeIfOperationExceed3(String str){
    int size = str.length;
    if(size > 8){
      int extraSize = size-8;
      textScaleFactor = textScaleFactor / (extraSize*0.20);
    }
    return str;
  }

  String formattedDisplay(String str){

    if(!didOperation){
      removeZeroOnLeft(str);
      toIntIfPossible(str);
      return str.length > 8 ? 'ERR' : str;
    }else{
      List<String> evaluate = str.contains('.') ? str.split('.') : null;
      if(evaluate!=null){
        handleChangeFontSizeIfOperationExceed3(str);
        return str;
      }else{
        if(str.length > 8){
          return 'ERR';
        }else{
          return str;
        }
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
          Display(currentNumber: applyIndex(), textScaleFactor: textScaleFactor,),
          SizedBox(height: 20.0,),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    for(int i = 0 ; i < 4; i++)
                      myKeyList[i] == 'AC'?
                        KeyPad(
                          onPressed: () => getValuePressed((processingIsActive? 'C' : 'AC')),
                          label: (processingIsActive? 'C' : 'AC'),
                          backgroundColor: Colors.orange,
                        )
                        :
                        KeyPad(
                          onPressed: () => getValuePressed(myKeyList[i]),
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
                        onPressed: () => getValuePressed(myKeyList[i]),
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
                        onPressed: () => getValuePressed(myKeyList[i]),
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
                        onPressed: () => getValuePressed(myKeyList[i]),
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
                          onPressed: () => getValuePressed(myKeyList[i]),
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

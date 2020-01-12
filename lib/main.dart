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
      debugShowCheckedModeBanner: false,
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
  int didOperationSteps = 0;
  double textScaleFactor = 4;


  void getValuePressed(String string){
    if(index == null){
      if(string.contains('+/-') ||
          string.contains('%') ||
          string.contains('/') ||
          string.contains('x') ||
          string.contains('-') ||
          string.contains('+') ||
          string.contains('=')){
        return;
      }
    }

    switch(string){
      case 'AC':
        allClear();
        break;
      case 'C':
        clear();
        break;
      case '+/-':
        handleIndexes(
          firstIndex: () => {
            setState(() {
            index.posNeg();
            })
          },
          lastIndex: () => {
            setState(() {
            index.posNeg();
            })
          }
        );
        break;
      case '%':
        handleIndexes(
        firstIndex: () => {
              setState(() {
                num operation = Operations.pourcentage(nb: index.number);
                sequences[0] = MyNumber(numberStr: operation.toString());
                index = sequences[0];
                didOperationSteps = 3;
              })
            },
            lastIndex: () => {
              resultOperation()
            }
        );
        break;
      case '/':
        handleIndexes(
            firstIndex: () => {
              setState(() {
                didOperationSteps = 2;
                sequences[1] = Actions.divide;
              })
            },
            lastIndex: () => {
              resultOperation(),
            }
        );
        break;
      case 'x':
        handleIndexes(
            firstIndex: () => {
              setState(() {
                didOperationSteps = 2;
                sequences[1] = Actions.multiply;
              })
            },
            lastIndex: () => {
              resultOperation(),
            }
        );
        break;
      case '-':
        handleIndexes(
            firstIndex: () => {
              setState(() {
                didOperationSteps = 2;
                sequences[1] = Actions.substract;
              })
            },
            lastIndex: () => {
              resultOperation(),
            }
        );
        break;
      case '+':
        handleIndexes(
            firstIndex: () => {
              setState(() {
                didOperationSteps = 2;
                sequences[1] = Actions.addition;
              })
            },
            lastIndex: () => {
              resultOperation(),
            }
        );
        break;
      case '=':
        resultOperation();
        break;
      case ',':
        handleIndexes(
          indexIsNull: () => {
            setState(() {
              sequences[0] = MyNumber(numberStr: '0');
              index = sequences[0];
              index.toDecimal();
            })
          },
          firstIndex: () => {
            if(!index.modeDecimal){
              setState(() {
                index.toDecimal();
              })
            }
          },
          lastIndex: () => {
          if(!index.modeDecimal){
              setState(() {
                index.toDecimal();
              })
            }
          },
          operationIndex: () => {
            setState(() {
              sequences[2] = MyNumber(numberStr: '0');
              index = sequences[2];
              index.toDecimal();
            })
          }
        );
        break;
      default: {
        processingIsActive = true;
        if(sequences[0] == null) {
          setState(() {
            didOperationSteps = 1;
            sequences[0] = MyNumber(numberStr: string);
            index = sequences[0];
          });
        }else if(sequences[0] == index && sequences[1] == null && sequences[2] == null){
          if(index.modeDecimal){
            setState(() {
              didOperationSteps = 1;
              index.addToTheRightAsDecimals(string);
            });
          }else{
            setState(() {
              didOperationSteps = 1;
              index.addToTheLeftAsInts(string);
            });
          }
        }else if(sequences[1] != null){
          if(sequences[2] == null){
            setState(() {
              didOperationSteps = 1;
              sequences[2] = MyNumber(numberStr: string);
              index = sequences[2];
            });
          }else if(index.modeDecimal){
            setState(() {
              didOperationSteps = 1;
              index.addToTheRightAsDecimals(string);
            });
          }else{
            setState(() {
              didOperationSteps = 1;
              index.addToTheLeftAsInts(string);
            });
          }
        }
      }
    }
  }

  void allClear(){
    setState(() {
      didOperationSteps = 0;
      index = null;
      processingIsActive = false;
      sequences = [null, null, null];
    });
    previousSequences = null;
  }

  void clear(){
    if(previousSequences!=null){
      setState(() {
        didOperationSteps = 0;
        sequences = [...previousSequences];
        index = sequences[2];
      });
    }else{
      allClear();
    }
    previousSequences = null;
  }

  void resultOperation(){
    if(sequences[2]==null){
      return;
    }

    num res;
    Actions action;
    switch(sequences[1]){
      case Actions.divide:
        res = Operations.divide(nbLeft: sequences[0].number, nbRight: sequences[2].number);
        action = Actions.divide;
        break;
      case Actions.multiply:
        res = Operations.multiply(nbLeft: sequences[0].number, nbRight: sequences[2].number);
        action = Actions.multiply;
        break;
      case Actions.substract:
        res = Operations.substract(nbLeft: sequences[0].number, nbRight: sequences[2].number);
        action = Actions.substract;
        break;
      case Actions.addition:
        res = Operations.addition(nbLeft: sequences[0].number, nbRight: sequences[2].number);
        action = Actions.addition;
        break;
    }

    if(res!=null){
      previousSequences = [...sequences];
      setState(() {
        sequences = [MyNumber(numberStr: res.toString()), null, null];
        index = sequences[0];
        sequences[1] = action;
        didOperationSteps = 3;
      });
    }
  }

  handleIndexes({Function indexIsNull, Function firstIndex, Function lastIndex, Function operationIndex}){
    // return in case of index unsetted
    // if index is first : do things
    // if index is last : do things
    // otherwise : do things
    if(index == null){
      if(indexIsNull()){
        indexIsNull();
      }else{
        return;
      }
    }else if(index == sequences[0]){
      firstIndex();
    }else if(index == sequences[2]){
      lastIndex();
    }else if(sequences[2] == null && sequences[1] != null && sequences[0] != null){
      operationIndex();
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

  String removeZeroOnLeft(String str) => str[0]=='0' ? str[0].replaceRange(0, 0, '') : str;


  String toIntIfPossible(String str){
    if(str.contains('.')){
      List<String> edition = str.split('.');
      if(edition[1].length == 1 && edition[1] == '0'){
        str = edition[0];
      }
    }
    return str;
  }

  void handleChangeFontSizeIfOperationExceed3(String str){
    if(str.length > 8){
      int extraSize = str.length-8;
      setState(() {
        textScaleFactor = textScaleFactor - (extraSize*0.20);
      });
    }
  }

  String formattedDisplay(String str){

    if(didOperationSteps == 0){
      setState(() {
        textScaleFactor = 4;
      });
      str = removeZeroOnLeft(str);
      str = toIntIfPossible(str);
      return str.length > 8 ? 'ERR' : str;
    }else if(didOperationSteps == 1){
      setState(() {
        textScaleFactor = 4;
      });
      str = removeZeroOnLeft(str);
      return str.length > 8 ? 'ERR' : str;
    }else if(didOperationSteps == 3){
      List<String> evaluate = str.contains('.') ? str.split('.') : null;
      if(evaluate!=null){
        str = toIntIfPossible(str);
        handleChangeFontSizeIfOperationExceed3(str);
        return str;
      }else{
        if(str.length > 8){
          return 'ERR';
        }else{
          return str;
        }
      }
    }else if(didOperationSteps==2){
      return str;
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

enum Actions{
  multiply,
  divide,
  substract,
  addition
}
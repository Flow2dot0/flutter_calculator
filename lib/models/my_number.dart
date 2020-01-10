class MyNumber{

  String numberStr;
  num number;
  bool modeDecimal;

  MyNumber({String numberStr}){
    this.numberStr = numberStr;
    this.number = num.parse(numberStr);
    this.modeDecimal = false;
  }

  convertStringToNum() => number = num.parse(numberStr);

  num rulesOfMaxDigitsTo8(){
    return numberStr.contains('-')? 9 : 8;
  }

  bool rulesOfMaxDigitsTo3AsDecimals(){
    List<String> evaluate = numberStr.split('.');
    return evaluate[1].length < 4 ? true : false;
  }

  posNeg(){
    number *= -1;
    numberStr = number.toString();
  }

  toDecimal(){
    modeDecimal = true;
    numberStr = '$numberStr.';
  }

  addToTheRightAsDecimals(String nb){
    if(!modeDecimal || numberStr.length == rulesOfMaxDigitsTo8() || !rulesOfMaxDigitsTo3AsDecimals())
      return;

    numberStr = '$numberStr$nb';
    convertStringToNum();
  }

  addToTheLeftAsInts(String nb){
    if(modeDecimal || numberStr.length == rulesOfMaxDigitsTo8())
      return;

    numberStr = '$numberStr$nb';
    convertStringToNum();
  }


}
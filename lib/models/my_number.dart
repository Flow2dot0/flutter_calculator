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
  
  rulesOfMaxDigitsTo8(){}

  posNeg(){
    number *= -1;
    numberStr = number.toString();
  }

  toDecimal(){
    modeDecimal = true;
    numberStr = '$numberStr.';
  }

  addToTheRightAsDecimals(String nb){
    if(!modeDecimal)
      return;

    numberStr = '$numberStr$nb';
    convertStringToNum();
  }

  addToTheLeftAsInts(String nb){
    if(modeDecimal)
      return;

    numberStr = '$numberStr$nb';
    convertStringToNum();
  }


}
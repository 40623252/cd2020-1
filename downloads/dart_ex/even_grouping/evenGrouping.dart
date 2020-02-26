import 'dart:html';

  InputElement studListUrl = querySelector("#studListUrl");
  String studUrl;
  // 將 Label 改為 Textarea, 避免產生過程結果嵌入所在頁面
  TextAreaElement output = querySelector("#output");

main() {
  querySelector("#submit").onClick.listen((e) => grouping());
}

grouping() {
  output.innerHtml = "";

  if (studListUrl.value != "") {
    studUrl = studListUrl.value;
  } else {
    studUrl = 'https://mde.tw/cp2019/downloads/2019fall_cp_1a_list.txt';
  }

  // 組序由 1 開始
  int gth = 1;
  // 迴圈序號變數
  int i;
  int j;
  int total;
  int inc;
  // 每組學員暫存數列
  var gpList = [];
  // 全班分組數列
  var cp2019 = [];
  // 各組人數數列
  var numList = [];

  HttpRequest.getString(studUrl).then((String resp) {
    // 利用 trim() 去除字串最後的跳行符號, 之後再利用 split() 根據 \n 轉為數列
    var studList = resp.trim().split("\n");
    // 數列利用 shuffle() 方法以隨機方法弄亂順序
    studList.shuffle();
    total = studList.length;
    output.text += "全班總計" + total.toString() + " 人\n";
    numList = getNumList(studList.length);
    inc = 0;
    for (i in numList){
      // 列印區隔符號
      output.text += '=' * 20 + "\n";
      output.text += "group $gth 有 " + i.toString() + " 人: \n";
      gpList = [];
      for (j = 0; j < i; j++){
        output.text += studList[j+inc] + "\n";
        // 在各分組數列中加入將對應的學員學號
        gpList.add(studList[j+inc]);
      }
      gth = gth + 1;
      inc = inc + j;
        //output.text += studList[j] + "\n";
        // 逐步將各組暫存的分組數列加入全班分組數列中
      cp2019.add(gpList);
    }
    // 列出全班分組數列
    output.text += cp2019.toString() + "\n";
  });
}

List getNumList(int total){
  // total student number
  // int total = 65;
  // initial each group expect to be "eachGrp" number of people
  int eachGrp = 10;
  // may divide into "grpNum" number of group
  int grpNum = total ~/ eachGrp;
  // vacant list
  var splits = [];
  // find remainder when total number divid into "grpNum" number of group
  int remainder = total % grpNum;
  // number of people in one group by calculation
  int calGrp = total ~/ grpNum;

  for (int i = 0; i < grpNum; i++) {
    splits.add(calGrp);
  }
  //print(splits);

  for (int i = 0; i < remainder; i++) {
    splits[i] += 1;
  }
  //print(splits);
  return splits;
 }
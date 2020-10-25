import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Exchange extends StatefulWidget {
  static const String id = "Exchange";
  @override
  _ExchangeState createState() => _ExchangeState();
}
TextEditingController amountController = TextEditingController();
TextEditingController resultController = TextEditingController();
int groupValue;
int result =0;
int dEx =0;
int shEx =0 ;
int adEx = 0;
int num = 0 ;
QuerySnapshot querySnapshotEx ;
bool showData=false;
List<dynamic> zones = [];
List<String> dropItemsArea = [];
String dropSelectItemArea= '';
class _ExchangeState extends State<Exchange> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
getData()async{
  var firestore = Firestore.instance;
  querySnapshotEx = await firestore.collection('exchange').getDocuments();
  setState(() {
    dropSelectItemArea = querySnapshotEx.documents[0]['d'];
    showData= true;
    dEx = querySnapshotEx.documents[0]['dEx'];
    shEx = querySnapshotEx.documents[0]['shEx'];
    adEx = querySnapshotEx.documents[0]['adEx'];
    zones =querySnapshotEx.documents[0]['zones'];
    for(int i =0 ; i<zones.length;i++){
      dropItemsArea.add(zones[i]);
    }

  });
}

calculate(select){
    if(select == zones[0]){
      result = num * dEx;
    }else if(select == zones[1]){
      result = num * shEx;
    }else if(select == zones[2]){
      result = num * adEx;
    }
    setState(() {
      resultController.text = result.toString();
    });

}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سعر الصرف اليومي',textAlign: TextAlign.center,
            style: TextStyle(
              height: 1,
              fontFamily: 'AmiriQuran',)),
      ),
      body:showData? ListView(
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(querySnapshotEx.documents[0]['dEx'].toString(),style: TextStyle(
                      fontSize: 22
                    ),),
                    SizedBox(width: 50,),
                    Icon(Icons.arrow_back_ios_rounded),
                    SizedBox(width: 10,),
                    Column(
                      children: [
                        Text('دولار أمريكي',textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1,
                              fontFamily: 'AmiriQuran',)),
                        SizedBox(height: 7,),
                        Text(querySnapshotEx.documents[0]['d'],textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1,
                              fontSize: 17,
                              color: Colors.deepOrange,
                              fontFamily: 'AmiriQuran',))
                      ],
                    ),
                    SizedBox(width: 16,),
                    Center(
                      child: Icon(Icons.monetization_on_outlined,
                        color: Colors.green[700],
                        size: 33,
                      ),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: Colors.grey[400]
            ),
          ),
          SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(querySnapshotEx.documents[0]['shEx'].toString(),style: TextStyle(
                        fontSize: 22
                    ),),
                    SizedBox(width: 50,),
                    Icon(Icons.arrow_back_ios_rounded),
                    SizedBox(width: 10,),
                    Column(
                      children: [
                        Text('دولار أمريكي',textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1,
                              fontFamily: 'AmiriQuran',)),
                        SizedBox(height: 7,),
                        Text(querySnapshotEx.documents[0]['sh'],textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1,
                            fontSize: 17,
                            color: Colors.deepOrange,
                            fontFamily: 'AmiriQuran',))
                      ],
                    ),
                    SizedBox(width: 16,),
                    Center(
                      child: Icon(Icons.monetization_on_outlined,
                        color: Colors.green[700],
                        size: 33,
                      ),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Container(
            height: 2,
            decoration: BoxDecoration(
                color: Colors.grey[400]
            ),
          ),
          SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(querySnapshotEx.documents[0]['adEx'].toString(),style: TextStyle(
                        fontSize: 22
                    ),),
                    SizedBox(width: 50,),
                    Icon(Icons.arrow_back_ios_rounded),
                    SizedBox(width: 10,),
                    Column(
                      children: [
                        Text('دولار أمريكي',textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1,
                              fontFamily: 'AmiriQuran',)),
                        SizedBox(height: 7,),
                        Text(querySnapshotEx.documents[0]['ad'],textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1,
                              fontSize: 17,
                              color: Colors.deepOrange,
                              fontFamily: 'AmiriQuran',))
                      ],
                    ),
                    SizedBox(width: 16,),
                    Center(
                      child: Icon(Icons.monetization_on_outlined,
                        color: Colors.green[700],
                        size: 33,
                      ),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 10,),
          Container(
            height: 2,
            decoration: BoxDecoration(
                color: Colors.grey[400]
            ),
          ),
          SizedBox(height: 40,),

          Card(
            color: Colors.grey[200],
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                child: Column(
                  children: [
                    Center(
                      child: Text('الحاسبة',textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1,
                            fontSize: 22,
                            fontFamily: 'AmiriQuran',))
                    ),
                    SizedBox(height: 4,),
                    Container(
                      height: 2,
                      decoration: BoxDecoration(
                          color: Colors.grey[400]
                      ),
                    ),
                    SizedBox(height: 4,),

                    SizedBox(height: 20,),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                      SizedBox(
                        width: 160,
                        child: Container(
                          child: SizedBox(
                            height: 38,
                            child: TextFormField(
                              controller:amountController ,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                hintText: '!... ادخل المبلغ بالدولار',
                                fillColor: Colors.white,
                                hoverColor: Colors.white,
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              onChanged: (val){
                                num =int.parse(val);
                                print(querySnapshotEx.documents[0]['dEx']);
                                calculate(dropSelectItemArea);

                              },

                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text('دولار',textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1,
                            fontSize: 19,
                            fontFamily: 'AmiriQuran',))
                    ],),
                    Center(child: 
                      Icon(Icons.arrow_drop_down_sharp,size: 30,color: Colors.blueAccent,),),
                    Center(child:
                    Icon(Icons.arrow_drop_down_sharp,size: 30,color: Colors.blueAccent,),),
                    Center(child:
                    Icon(Icons.arrow_drop_down_sharp,size: 30,color: Colors.blueAccent,),),
                    SizedBox(height: 5,),

                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 175,
                          height: 31,
                          child: Container(
                            child:TextFormField(
                              readOnly: true,
                              controller: resultController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                fillColor: Colors.white,
                                hoverColor: Colors.white,
                              ),
                            )
                            //Text(result.toString())
                          ),

                        ),
                        SizedBox(width: 3,),
                        DropdownButton<String>(
                          iconSize: 30,
                          style: TextStyle(color: Colors.green[800]),
                          items: dropItemsArea.map((String selectItem) {
                            return DropdownMenuItem(
                                value: selectItem, child: Text(selectItem));
                          }).toList(),
                          isExpanded: false,
                          dropdownColor: Colors.grey[200],
                          iconDisabledColor: Colors.green[800],
                          iconEnabledColor: Colors.green[800],
                          icon: Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(
                                Icons.menu,
                                size: 22,
                              )),
                          onChanged: (String theDate) {
                            setState(() {
                              dropSelectItemArea = theDate;
                            });
                            calculate(theDate);
                          },
                          value: dropSelectItemArea,
                          elevation: 7,
                        ),
                        Text(querySnapshotEx.documents[0]['txtamount'],textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1,
                              fontSize: 17,
                              fontFamily: 'AmiriQuran',))
                      ],),

                  ],
                ),
              ),
            ),
          ),

        ],
      ):Container(),
    );
  }
}

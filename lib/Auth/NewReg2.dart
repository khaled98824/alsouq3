import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NewLogin.dart';

class NewReg extends StatefulWidget {
  @override
  _NewRegState createState() => _NewRegState();
}
bool equalName ;
List<String> _namesList =[];
bool showTextTerms =true ;
bool acceptTerms =false ;
bool checkboxVal = false ;
class _NewRegState extends State<NewReg> {
  void initState() {
    getUsersNames();
    super.initState();
  }
  getUsersNames()async{
    var firestore = Firestore.instance;
    QuerySnapshot qus = await firestore.collection('users').getDocuments();
    if(qus!=null){
      for (int i=0; qus.documents.length>_namesList.length;  i ++){
        setState(() {
          _namesList.add(qus.documents[i]['user_uid']);

        });

      }
    }
    print(_namesList);

  }
  final _formkey = GlobalKey<FormState>();

  TextEditingController _namecontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();

  TextEditingController _countrycontroller = TextEditingController();

  @override
  void dispose() {
    _namecontroller.dispose();

    _passwordcontroller.dispose();

    _countrycontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'تسجيل مستخدم جديد',
            style: TextStyle(fontSize: 22, fontFamily: 'AmiriQuran', height: 1),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Padding(
                      padding: EdgeInsets.only(right: 40,left: 40),
                      child: TextFormField(
                        controller: _namecontroller,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: '... الإسم',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Fill name Input';
                          }
                          // return 'Valid Name';
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Padding(
                      padding: EdgeInsets.only(right: 40,left: 40),
                      child: TextFormField(
                        controller: _passwordcontroller,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: '... كلمة المرور',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Fill Password Input';
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 40,left: 40),

                      child: TextFormField(
                        controller: _countrycontroller,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: '... المنطقة',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Fill Country Input';
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'قرأت شروط وأحكام الإستخدام وانا أوافق عليها',
                          style: TextStyle(
                              color: Colors.green[900],
                              fontSize: 15,
                              fontFamily: 'AmiriQuran',
                              height: 1),
                        ),
                        Checkbox(
                          value: checkboxVal,
                          onChanged: (bool val) {
                            setState(() {
                              checkboxVal = val ;
                              acceptTerms = val ;
                              print(acceptTerms);
                            });
                          },
                        ),
                        SizedBox(width: 20,)
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 6,
                      height: 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 40),
                        child: Text(
                          'تسجيل',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'AmiriQuran',
                              color: Colors.white,
                              height: 1),
                        ),
                      ),
                      onPressed: () async {
                       if (checkboxVal){
                         if (_formkey.currentState.validate()) {
                           doSaveName();

                         }
                       }else{
                         showMessage('يجب الموافقة على شروط واحكام الإستخدام');
                       }
                      },
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width - 6,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[600]),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        if (showTextTerms){
                          setState(() {
                            showTextTerms = false ;
                          });
                        }else{
                          setState(() {
                            showTextTerms = true ;
                          });
                        }

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '.... قراءة الشروط',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontFamily: 'AmiriQuran',
                                height: 1),
                          ),
                          SizedBox(width: 30,)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    showTextTerms ? Container(
                      child:Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical:3,horizontal:8),
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              text:': شروط الاستخدام\n',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    //fontFamily: 'AmiriQuran',
                                    letterSpacing: 1,
                                    wordSpacing: 0.5,
                                    height: 1.2),
                              children: [
                                TextSpan(
                                  text: ' مرحباً بكم في سوق الفرات اون لاين , وهو احدى منصات الإعلانات المبوبة الإلكترونية ,يقدم سوق الفرات اون لاين الفرصة للبائعين واصحاب الخدمات من عرض سلعهم ومنتجاتهم وخدماتهم تحت عدد كبير من الأقسام وبشكل مجاني , وكذلك يقدم للمشترين وطالبي الخدمات فرصة البحث عن ما يهمهم من الخدمات والسلع والمنتجات بشكل مجاني .شروط الاستخدام هذه تحدد طبيعة الاتفاقية بينك وبين سوق الفرات حيث تحكم استخدامك لخدمات سوق الفرات اون لاين .\n\n',
                                  style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                //fontFamily: 'AmiriQuran',
                                letterSpacing: 1,
                                wordSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                                height: 1.2),
                                ),
                                TextSpan(
                                  text: 'هذه الاتفاقية تبين لك معلومات مهمة حول مسؤوليتك عن المحتوى الخاص بك ,\n وايضاً تبين مسؤوليتنا تجاهك وموافقتك على تسوية الخلافات عن طريق التحكيم الفردي , والتنازل عن حق المشاركة في اي دعوة صنف ضد سوق الفرات اون لاين  \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),
                              TextSpan(
                                text: 'واعلم عزيزي المستخدم بانك في دخولك منصة سوق الفرات اون لاين\n: فانك توافق على الشروط التالية\n\n',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    //fontFamily: 'AmiriQuran',
                                    letterSpacing: 1,
                                    wordSpacing: 0.5,
                                    height: 1.2),
                              ),
                                TextSpan(
                                  text: 'النسخة الانجليزية من شروط الاستخدام هي المرجع الساسي للشروط\n . في حال وجود تضارب في اللغات الاخرى \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),
                                TextSpan(
                                  text: ': الحساب الخاص بك  \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: '  يتطلب استخدام تطبيق سوق الفرات اون لاين تسجيل حساب خاص بك من خلال البريد الإلكتروني وكلمة مرور تقوم بوضعها , وسيكون هذا البريد هو المعتمد من قبل السوق وانت كمستخدم تكون مسؤول عن جميع نشاطات هذا الحساب , لذا  يجب وضع بريد \n. إلكتروني صالح وخاص بك واختيار كلمة مرور قوية   \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                              TextSpan(
                                text: ': استخدام سوق الفرات اون لاين\n\n',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    //fontFamily: 'AmiriQuran',
                                    letterSpacing: 1,
                                    wordSpacing: 0.5,
                                    height: 1.2),
                              ),

                                TextSpan(
                                  text: '. انتهاك أي من القوانين والمحظورات وسياسة المحتوى لدينا -  \n - نشر إعلانات غير حقيقية أو مضللة .\n - انتهاك حقوق الأطراف الأخرى .\n - نشر أي بريد مؤذي أو رسائل تسلسلية أو مخطط تسويق هرمي .\n - نشر الفيروسات والبرمجيات الخبيثة التي تضر بالمستخدمين والتطبيق والاطراف الأخرى .\n - الأعمال التخريبية لسوق الفرات وبنيته التحتية .\n - نسخ او تعديل أو نشر محتوى لشخص آخر .\n - استخدام أي وسيلة ممنوعة للوصول لقاعدة بينات التطبيق وتقنياته وجمع البيانات لأي غرض كان .\n - جمع معلومات المستخدمين واستخدامها في اغراض اخرى . \n- تجاوز إجراءات الدخول للتطبيق المعتمدة .\n - استخدام معلومات خاصة بأشخاص آخرين دون موافقتهم .\n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ': المحتوى المحظور\n\n',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: 'سيتم حذف اي منشور مخالف او على اي بند من الامور المحضورة ادناه , وتحتفظ إدارة التطبيق بحق الحذف للمستخدم او تنبيهه ,او ابلاغ السلطات المحلية\n : المختصة لتطبيق القانون اللازم\n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: '  المشروبات الكحولية والخمور ومنتجات التبغ والمخدرات والمؤثرات العقلية والمسكرات والأدوية والمسكنات، أو حتى وضع روابط سواء كانت مباشرة أم غير مباشرة لمواد ومنتجات أو خدمات يحظر القانون تداولها (للمكملات الغذائية ومنتجات التنحيف والكريمات التجميلية يجب أن يتم تزويدنا بصورة عن موافقة من مؤسسة الغذاء والدواء) \n\n- الأعضاء البشرية الطبيعية أو الصناعية بما في ذلك الدم وسوائل الجسم أيضاً.\n\n- الدعارة أو أي خدمات أخرى من ضمنها، تنتهك أحكام القانون بشكل غير أخلاقي أو التمثيل غير اللائق بالمرأة والذي من شأنه أن ينتهك الشريعة الاسلامي والمعايير المعاصرة للأخلاق والآداب في المجتمعات العربية. \n\n - المواد الدينية بما في ذلك الكتب والتحف... إلخ أو أي معلومات أو وصف لأي من هذه المواد يمس المشاعر الدينية لأي شخص أو مجموعة.\n\n- الأدوات والإيحاءات الجنسية (وتضم: إيحاءات العبودية والأصنام) أو تصوير الأعضاء التناسلية وما إلى ذلك.  \n\n- الآثار أو الكنوز الممنوع تداولها تحت أي قانون معمول به.- معلومات ومواد تشير إلى القذف أو التشهير أو التهديد أو حتى الإساءة- معلومات مزورة لطبيعة أو طريقة استخدام المنتجات والخدمات\n\n- السلع المزيفة أو المسروقة أو الخدمات غير القانونية والمصرّح بها.\n\n- السلع والمواد والخدمات التي تنتهك حقوق وملكية فكرية خاصة بأي طرف ثالث، أو حتى خصوصية أي شخص. \n\n - نقل فيروسات الكمبيوتر الإلكترونية أو أي برنامج من شأنه أن يقوم بقرصنة أنظمة الكمبيوتر وإتلافها وسحب البيانات الشخصية.\n\n- يجب ألا تضم المعلومات الخاصة بك أي محتوى فيه إهانة للمستخدمين و/أو الحيوانات\n\n- المواد الكيميائية والمبيدات الخطرة \n\n - الألعاب النارية والمتفجرات والعبوات الناسفة وما إلى ذلك من مواد مشتعلة وخطيرة \n\n - الوثائق الشخصية والسجلات المالية وأي معلومات شخصية بما في ذلك القوائم البريدية\n\n- تذاكر اليانصيب ومراهنات سباق الخيل وماكينات القمار \n\n - المعدات الخاصة بالشرطة والجيش من شارات وزي رسمي ومعاطف وأسلحة وما إلى ذلك من مواد يمنع تداولها \n\n - نشر إعلانات لمواقع او شركات منافسة سوق الفرات اون لاين \n\n- الأسلحة والأدوات ذات الصلة (مثل: الأسلحة النارية والذخائر والغاز المسيل للدموع والنادق والأدوات الحادة)  \n\n- خدمات ومخططات التسويق الهرمي للاحتيال على المستخدمين .\n\n- الحيوانات المهددة بالانقراض أو الحيوانات الشرسة(GTA , God of War....الخ)\n\n- نشر إعلانات العاب فيديو مصنفة +18 مثل\n\n- اختيار الأقسام والأقسام الفرعية الخاطئة (مثل: الإعلان عن طاولة طعام في قسم أثاث المكاتب)\n\n  - إعلانات القروض والتمويل وشركات التسهيلات التجارية\n\n- السيارات الغير مخصصة للإيجار (السيارات الخصوصية)\n\n- الوشم (التاتو) ومستلزماته.\n\n- وكل ما يتعارض مع الشريعة الإسلامية .\n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ': سوء استخدام تطبيق سوق الفرات اون لاين \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: 'نحن إدارة التطبيق نطلب منك كمستخدم ابلاغنا باي مخالفة او محتوى غير اخلاقي او تجاوز لشريعة ديننا الحنيف الاسلام او مشاكل اخرى , لكي يستمر التطبيق في تقديم الخدمة المفيدة والملائمة للجميع , والتطبيق غير مسئول عن ما تقدمة من محتوى غير لائق او مخالف , وبتسجيلك فيه انت توافق على الالتزام بالأحكام والشروط لاستخدام هذا التطبيق .\n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ' يتم حضر الممارسات التالية عند استخدام تطبيق\n :  سوق الفرات اون لاين \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: '	إنشاء أكثر من حساب.\n\n•	نشر الإعلانات المكررة.\n\n•	حذف الإعلانات وإعادة نشرها بشكل متكرر.\n\n•	نشر الإعلانات ذات العناوين والمحتوى والصور المضلّلة.\n\n•	نشر إعلانات مع صور خاطئة أو غير لائقة.\n\n•	نشر الإعلانات في أقسام خاطئة.\n\n•	نشر إعلانات مع أسعار غير منطقية.\n\n•	نشر الإعلانات مع روابط إعادة توجيه إلى مواقع أخرى.\n\n•	تحميل صور تحتوي على أسماء وأرقام هواتف و أي كلمات أخرى.\n\n•	نشر إعلانات تحتوي على خيار الدفع المسبق أو تحويل للبنوك.\n\n•	نشر إعلانات ذات محتوى عام أو محتوى دعائي عام .\n\n•	نشر إعلانات تحتوي على عدة سلع.\n\n•	نشر سلع يمكن ارتداؤها دون تحميل صور لها.\n\n•	نشر إعلانات احتيال وإعلانات وهمية.•	تحميل صور تحتوي على نفس نص الإعلان أو على صور لشعارات شركات أخرى داخل الصور للإعلان.\n\n•	لا يسمح بتعديل الإعلان المميز لبيع سلعة/منتج أو خدمة أخرى \n. ويمكن تعديل الإعلان المميز ٣ مرات فقط \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ': المحتوى \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ' يحتوي سوق الفرات على أمور تعود للمستخدمين والسوق نفسه , وانت كمستخدم للسوق لا يحق لك نسخ حقوق الملكية لاي من تلك الأمور , وفي حال تم التعدي\n. على حقوقك انت كمستخدم يرجى ابلاغنا لمعالجة الامر \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ': نصائح التعامل الامن\n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: 'يمكنك البيع والشراء عبر سوق الفرات اون لاين من خلال إيجاد السلعة التي ترغب بشرائها أولاً ، ثم التواصل مع المعلن من خلال طرق التواصل المتوفرة والاستفسار عن ما ترغب به ، والاتفاق على عملية البيع والتسليم, ليكون البيع آمن دون وجود احتيال نرجو منك التأكد من وجود سلعة حقيقية ، معاينتها ، عدم إرسال أية مبالغ نقدية لأي جهة دون التأكد من المعلن والسلعة ، ويفضل التواصل مع المعلن ومقابلته على أرض الواقع، وتفادي عمليات الدفع المسبق والشحن التي تتم,يمكنك إتباع النصائح والخطوات التالية\n : عند البيع والشراء في موقع السوق المفتوح  \n\n1.اختيار البائع بحكمة.\n\n2. لا تقم بتسليم أي مبالغ مالية قبل الحصول على الخدمة المقدمة من قبل البائع.\n\n3. اطلب صور المنتج الفعلي.\n\n4. معرفة حالة المنتج. (اطلب منهم جميع الاستفسارات الرئيسية والثانوية الخاصة بالإعلان مثل (حالة المنتج و سبب بيعها وتفاصيل المنتج).\n\n5. تأكد من سعر المنتج بحيث أن يكون بحدود المعقول (إذا كان لديك أي فكرة عن كيفية تسعير المنتج يمكنك إجراء بحث سريع لأخذ فكرة عن السعر).\n\n6. استخدام طرق دفع آمنة. \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ' يمكنك تذكر المعلومات التالية قبل لقاء البائع \n: أو المشتري \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: '- معاينة المنتج قبل الشراء والتأكد من سلامته وعدم  وجود أي خلل فيه.\n\n- لا تقم بتسليم أي مبالغ مالية قبل الحصول على الخدمة المقدمة من قبل البائع.\n\n- التأكيد على مكان اللقاء لتسليم أو استلام المنتج.\n\n- الاستفسار بشكل كامل عن المنتج من البائع قبل الشراء.\n\n  ملاحظة: سوق الفرات اون لاين غير مسؤول عن عمليات البيع والشراء التي تتم بين المعلنين ، حيث أننا مجرد وسيط بين البائع والمشتري لعرض الإعلانات المبوبة المجانية. \n\n يمكنك معرفة الأشخاص المحتالين، من خلال الشك بأي محاولات بيع غير آمنة أو من قبل أشخاص محتالين في حال:\n\n- كانت اعلانات السلعة المعروضة تتضمن صور معروضة من الانترنت ( غير حقيقية ).\n\n- في حال كان السعر قليل جداً ( مقارنة بأسعار السوق المحلي ).\n\n- عندما تسأل عن صور إضافية عن المنتج فإنها لا تتوفر لدى البائع.\n\n- عند الاستفسار عن تفاصيل حول اي بند من الإعلان، يعطي الكثير من الإجابات غير متناسقة.\n\n- عند طلب اللقاء منهم لمعاينة المنتج أو تسليمه، فإنهم يقدمون أعذارا كثيرة جدا.\n\n- يتم الإصرار على تحويل أموالك ... بسرعة!  \n\n يمكنك التبليغ عن المحتالين من خلال التواصل معنا فوراً، في حال شككت بمصداقية إعلان أحد المستخدمين على سوق الفرات .\n\n بالإضافة إلى ذلك، نحثّك على التوجه إلى الشرطة إن وقعت في فخ الاحتيال.\n\nنحن مستعدون لتزويد الشرطة بأي معلومات تخدم التحقيق، بناءً على طلب رسمي منهم.سارع إلى تعبئة طلب لنتمكن من إيقاف حساب الشخص بعد القيام بالتحرّيات اللازمة.\n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ': الإبلاغ عن انتهاكات حقوق الملكية الفكرية \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: 'يحظر على المستخدمين نشر أي محتوى فيه انتهاك لحقوق الملكية الخاصة بالأطراف الثالثة؛ وهذا يشمل وليس على سبيل الحصر؛ انتهاك حقوق الملكية الفكرية والعلامات التجارية (مثل: الإعلان عن مواد وهمية للبيع).  \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),
                                TextSpan(
                                  text: 'ولدينا الحق في إزالة أي محتوى مخالف لشروط سياسة النشر لدينا وحماية حقوق الآخرين.وفي حال شعرت بأن أحد الإعلانات لدينا تنتهك حقوق الملكية والعلامة التجارية الخاصة بك، كل ما عليك فعله حينها هو إبلاغ قسم خدمة العملاء لدينا، وصاحب هذه الحقوق هو فقط من يستطيع أن يقدم بلاغ ضد الشروط والإعلانات التي من المحتمل أنها تمسه. \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ': الرسوم والخدمات  \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: 'بشكل عام ان نشر الإعلانات على سوق الفرات اون لاين مجاني , ولكن قد تكون هناك مميزات واضافات مدفوعة . \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: 'ان سوق الفرات اون لاين يقوم بتقديم المحتوى المنشور فيه كما هو بطبيعته , والسوق غير مسؤول تجاهك عن ما ينشر في هذا السوق وعن دقة المعلومات التي تحويها المنشورات والمعروضات كالرسائل المباشرة لك كمستخدم من مستخدم آخر او أي طرف غير إدارة التطبيق , وتطبيق سوق الفرات يخلي مسؤوليته من تأكيد المعلومات حول الجودة والسعر والتفاصيل الأخرى التي تخص المعروضات والخدمات التي تقدمها الأطراف الأخرى . \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ': التعويض \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ' انت كمستخدم للتطبيق مطالب في تقديم تعويض لاي طرف يقدم شكوى بحقك وهو صاحب حق فعلاً عند ارتكابك لمخالفة ما , او دفع مبالغ مستحقه عليك , وليس لسوق الفرات او موظفيه أي مسؤوليه في تعاملاتك ومخالفاتك . \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ': المعلومات الشخصية \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ' عند استخدامك لسوق الفرات اون لاين  فأنت توافق على جمع ونقل وتخزين واستخدام المعلومات الشخصية الخاصة بك من قبل السوق. \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ' إن مجمل هذه الشروط والسياسات المعلن عنها على سوق الفرات اون لاين تشكّل اتفاقية بينك وبين التطبيق لتحل محل أي اتفاقية سابقة، فيما تخضع هذه الاتفاقية للقوانين المعمول بها في إنجلترا.\n\nوهذا لن يؤثر أبداً على حقوقك القانونية إذا كنت مستهلكاً ويتطلب تطبيق ذلك قانونا آخر(مثل قانون بلد الإقامة) على أمور معينة، وفي حال لم نشترط بنود معينة لن نقوم بالتنازل عن حقوقنا بالقيام بذلك في وقت لاحق. وإذا ألغت المحكمة أياً من هذه الشروط، فإن بقية الشروط الأخرى ستبقى موجودة، وبدورنا نحتفظ بحق التعيين أو إعادة التعيين لهذه الإتفاقية تلقائياً وفقاً لبنود الإشعار أدناه.    \n\n  يحق لسوق الفرات اون لاين  في أي وقت و حسب تقدير إدارة التطبيق الخاص و المطلق رفض أو نقل أو حذف أي محتوى أو عضوية.\n\nويحق لسوق الفرات اون لاين  التحقق من محتوى أي إعلان من خلال طلب أوراق رسمية (سجل تجاري, رخص مهن, مزاولة مهن, هوية شخصية) لإثبات الجهة المعنية وتوثيق الحساب.   \n\n سنقوم بإرسال إشعارات على بريدك الإلكتروني الذي وضعته، أو ذلك الذي قمت بالتسجيل من خلاله مسبقاً. تتطلب الإشعارات المرسلة عبر البريد الرسمي خمس أيام عمل بعد تاريخ الإرسال.   \n\n  يحق لسوق الفرات تحديث اتفاقية الاستخدام في أي وقت و التي ستكون فاعلة عند أول مرة دخول لك لسوق الفرات بعد تحديث الاتفاقية أو مرور30 يوما من تحديث الاتفاقية, أيهما أقرب. يمكنك إرسال الاستفسارات أو التعليقات أو الشكاوى إلى فريق خدمة العملاء لدينا. \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ': استخدام التطبيق \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: 'ان سوق الفرات اون لاين يمنحك حق الاستخدام الشخصي للتطبيق , وكذلك يجب عليك الامتثال لكل بنود الاتفاقيات.   \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      //fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: ': الملكية الفكرية – التطبيق \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                                TextSpan(
                                  text: 'يمتلك سوق الفرات اون لاين جميع حقوق ملكية مصالح التطبيق واجزائه والملكية الفكرية , ولا يجوز لاي شخص تعديل او تفكيك او هندسة برمجيات التطبيق او استخدام الرموز , كما لا يجوز اخذ المحتوى المعروض واستخدامه في مكان اخر .  \n\n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                     // fontWeight: FontWeight.bold,
                                      //fontFamily: 'AmiriQuran',
                                      letterSpacing: 1,
                                      wordSpacing: 0.5,
                                      height: 1.2),
                                ),

                              ]
                            ),
                          ),
                        ),
                      ) ,
                    ):Container(),

                  ],
                ),
              ),
            ),
          ],
        ));
  }
  doSaveName()async{
    equalName=false;
    for(int i=0;i<_namesList.length;i++){
      if(_namecontroller.text.toLowerCase().trimLeft()==_namesList[i]){
        equalName=true;
        showMessage('إسم المستخدم موجود مسبقاً رجاءاٌ اختر غيره');
      }
    }
    print(equalName);
    if(equalName==false){
      print('done');
      Firestore.instance.collection('users').document(_namecontroller.text,)
          .setData({
        'name': _namecontroller.text,
        'user_uid': _namecontroller.text,
        'area': _countrycontroller.text,
        'password': _passwordcontroller.text,
        "time": DateFormat('yyyy-MM-dd-HH:mm')
            .format(DateTime.now()),
      });
      SharedPreferences sharedPref =
          await SharedPreferences.getInstance();
      sharedPref
          .setString('password', _passwordcontroller.text);
      sharedPref
          .setString('myArea', _countrycontroller.text);
      sharedPref
          .setString('name', _namecontroller.text)
          .then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NewLogin()));
      });
    }else{
      print('notDone');
    }
  }
  showMessage(String msg) {
    Fluttertoast.showToast(
        msg:msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 15,
        textColor: Colors.white);
  }
}

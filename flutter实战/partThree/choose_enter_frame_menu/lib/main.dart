import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String titleStr = '单选框和复选框、输入框和表单';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: titleStr,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyAppPage(title: titleStr),
    );
  }
}

class MyAppPage extends StatefulWidget {
  final String title;
  MyAppPage({Key key, this.title}) : super(key: key);

  @override
  MyAppPageState createState() => MyAppPageState();
}

class MyAppPageState extends State<MyAppPage> {
  bool _switchSelected = true; //维护单选开关状态
  bool _checkboxSelected = true; //维护复选框状态

  //通过controller来获取输入框的值，另一种方式是通过TextField自带属性onchange回调来进行
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();

  //表单，通过globalkey获取FormState类对Form的子孙FormField进行统一操作
  GlobalKey _formKey = new GlobalKey<FormState>();

  /*控制焦点
  
  焦点可以通过FocusNode和FocusScopeNode来控制，默认情况下，焦点由FocusScope来管理，它代表焦点控制范围，可以在这个范围内
  可以通过FocusScopeNode在输入框之间移动焦点、设置默认焦点等。我们可以通过FocusScope.of(context) 来获取Widget树中默认
  的FocusScopeNode
  */
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  FocusScopeNode focusScopeNode;

  @override
  void initState() {
    super.initState();
    //设置默认值，并从第三个字符开始选中后面的字符
    _unameController.text = "hello world!";
    _unameController.selection = TextSelection(
        baseOffset: 2, extentOffset: _unameController.text.length);

    // 监听焦点变化获得焦点时focusNode.hasFocus值为true，失去焦点时为false。
    focusNode1.addListener(() {
      print('focusNode1的焦点：${focusNode1.hasFocus}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          //单选开关和复选框
          Column(
            children: <Widget>[
              //Switch只能定义宽度，高度也是固定的
              Switch(
                value: _switchSelected, //当前状态
                onChanged: (value) {
                  //重新构建页面
                  setState(() {
                    _switchSelected = value;
                  });
                },
              ),
              //Checkbox的大小是固定的，无法自定义
              /*
               * Checkbox有一个属性tristate ，表示是否为三态，
               * 其默认值为false ，这时Checkbox有两种状态即“选中”和“不选中”，对应的value值为true和false 。
               * 如果tristate值为true时，value的值会增加一个状态null
               */
              Checkbox(
                value: _checkboxSelected,
                activeColor: Colors.red, //选中时的颜色
                onChanged: (value) {
                  setState(() {
                    _checkboxSelected = value;
                  });
                },
              )
            ],
          ),

/*
 * TextField在绘制下划线时使用的颜色是主题色里面的hintColor，但提示文本颜色也是用的hintColor， 如果我们直接修改hintColor，那么下划线和提示文本的颜色都会变。
 * 值得高兴的是decoration中可以设置hintStyle，它可以覆盖hintColor，并且主题中可以通过inputDecorationTheme来设置输入框默认的decoration。
 */
          Theme(
              data: Theme.of(context).copyWith(
                  hintColor: Colors.grey[200], //定义下划线颜色
                  inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(color: Colors.grey), //定义label字体样式
                      hintStyle: TextStyle(
                          color: Colors.grey, fontSize: 14.0) //定义提示文本样式
                      )),
              child: //登陆输入框
                  Column(
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "用户名",
                        hintText: "用户名或邮箱",
                        //自定义样式
                        // 未获得焦点下划线设为灰色
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        //获得焦点下划线设为蓝色
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(Icons.person)),
                    onChanged: (value) {
                      print('输入内容结果：$value');
                    },
                    focusNode: focusNode1,
                    //onChanged是专门用于监听文本变化，而controller的功能却多一些，除了能监听文本变化外，它还可以设置默认值、选择文本，
                    controller: _unameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "密码",
                        hintText: "您的登录密码",

                        //自定义样式
                        // 未获得焦点下划线设为灰色
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        //获得焦点下划线设为蓝色
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 13.0),
                        prefixIcon: Icon(Icons.lock)),
                    focusNode: focusNode2,
                    controller: _pwdController,
                    obscureText: true,
                  ),
                  //切换焦点按钮
                  Builder(
                    builder: (ctx) {
                      return Column(
                        children: <Widget>[
                          RaisedButton(
                            child: Text("移动焦点"),
                            onPressed: () {
                              //将焦点从第一个TextField移到第二个TextField
                              // 这是一种写法 FocusScope.of(context).requestFocus(focusNode2);
                              // 这是第二种写法
                              if (null == focusScopeNode) {
                                focusScopeNode = FocusScope.of(context);
                              }
                              focusScopeNode.requestFocus(focusNode2);
                            },
                          ),
                          RaisedButton(
                            child: Text("隐藏键盘"),
                            onPressed: () {
                              // 当所有编辑框都失去焦点时键盘就会收起
                              focusNode1.unfocus();
                              focusNode2.unfocus();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              )),
          /*
           *我们成功的自定义了下划线颜色和提问文字样式，细心的读者可能已经发现，通过这种方式自定义后，输入框在获取焦点时，labelText不会高亮显示了，
           正如上图中的"用户名"本应该显示蓝色，但现在却显示为灰色，并且我们还是无法定义下划线宽度。另一种灵活的方式是直接隐藏掉TextField本身的下划线，
           然后通过Container去嵌套定义样式，如: 
           */
          Container(
            child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "电子邮件地址",
                    prefixIcon: Icon(Icons.email),
                    border: InputBorder.none //隐藏下划线
                    )),
            decoration: BoxDecoration(
                // 下滑线浅灰色，宽度1像素
                border: Border(
                    bottom: BorderSide(color: Colors.grey[200], width: 1.0))),
          ),
          //通过这种组件组合的方式，也可以定义背景圆角等。一般来说，优先通过decoration来自定义样式，如果decoration实现不了，再用widget组合的方式。

          //表单Form
          /*Form的三个参数解析：
           *autovalidate：是否自动校验输入内容；当为true时，每一个子FormField内容发生变化时都会自动校验合法性，并直接显示错误信息。
               否则，需要通过调用FormState.validate()来手动校验。
            onWillPop：决定Form所在的路由是否可以直接返回（如点击返回按钮），该回调返回一个Future对象，如果Future的最终结果是false，
               则当前路由不会返回；如果为true，则会返回到上一个路由。此属性通常用于拦截返回按钮。
            onChanged：Form的任意一个子FormField内容发生变化时会触发此回调。 
           */
          /*
           * FormState

FormState为Form的State类，可以通过Form.of()或GlobalKey获得。我们可以通过它来对Form的子孙FormField进行统一操作。我们看看其常用的三个方法：

FormState.validate()：调用此方法后，会调用Form子孙FormField的validate回调，如果有一个校验失败，则返回false，所有校验失败项都会返回用户返回的错误提示。
FormState.save()：调用此方法后，会调用Form子孙FormField的save回调，用于保存表单内容
FormState.reset()：调用此方法后，会将子孙FormField的内容清空。
           */

          /**
           * 示例
我们修改一下上面用户登录的示例，在提交之前校验：

用户名不能为空，如果为空则提示“用户名不能为空”。
密码不能小于6位，如果小于6为则提示“密码不能少于6位”。
           */
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Form(
              key: _formKey, //设置globalKey，用于后面获取FormState
              autovalidate: true, //开启自动校验
              child: Column(
                children: <Widget>[
                  //Form的子孙元素必须是FormField类型，
                  /*
                   * const FormField({
                      ...
                      FormFieldSetter<T> onSaved, //保存回调
                      FormFieldValidator<T>  validator, //验证回调
                      T initialValue, //初始值
                      bool autovalidate = false, //是否自动校验。
                    })
                   */
                  //Flutter提供了一个TextFormField组件，它继承自FormField类，也是TextField的一个包装类，所以除了FormField定义的属性之外，它还包括TextField的属性。
                  TextFormField(
                      autofocus: true,
                      controller: _unameController,
                      decoration: InputDecoration(
                          labelText: "用户名",
                          hintText: "用户名或邮箱",
                          icon: Icon(Icons.person)),
                      // 校验用户名
                      validator: (v) {
                        return v.trim().length > 0 ? null : "用户名不能为空";
                      }),
                  TextFormField(
                      controller: _pwdController,
                      decoration: InputDecoration(
                          labelText: "密码",
                          hintText: "您的登录密码",
                          icon: Icon(Icons.lock)),
                      obscureText: true,
                      //校验密码
                      validator: (v) {
                        return v.trim().length > 5 ? null : "密码不能少于6位";
                      }),
                  // 登录按钮
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.all(15.0),
                            child: Text("登录"),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              //在这里不能通过此方式获取FormState，context不对
                              //print(Form.of(context));

                              // 1.通过_formKey.currentState 获取FormState后，
                              // 调用validate()方法校验用户名密码是否合法，校验
                              // 通过后再提交数据。
                              //另外这里不能通过Form.of(context)来获取，原因是，此处的context为FormTestRoute的context，而Form.of(context)是根据所指定context向根去查找，而FormState是在FormTestRoute的子树中，所以不行
                              if ((_formKey.currentState as FormState)
                                  .validate()) {
                                //验证通过提交数据
                              }
                            },
                          ),
                        ),

                        //2.下面通过Builder来构建登录按钮，Builder会将widget节点的context作为回调参数：其实context正是操作Widget所对应的Element的一个接口，由于Widget树对应的Element都是不同的，所以context也都是不同的。
                        Expanded(
                            // 通过Builder来获取RaisedButton所在widget树的真正context(Element)
                            child: Builder(builder: (context) {
                          return RaisedButton(
                            padding: EdgeInsets.all(15.0),
                            child: Text("登录"),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              //由于本widget也是Form的子代widget，所以可以通过下面方式获取FormState
                              if (Form.of(context).validate()) {
                                //验证通过提交数据
                              }
                            },
                          );
                        }))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

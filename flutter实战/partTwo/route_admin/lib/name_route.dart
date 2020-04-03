import 'package:flutter/material.dart';

// void main() => runApp(NameRoute());

class NameRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "路由命名",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: NameRoutePage(title:"路由命名"),

      //也可以将主页面通过路由的形式设置如下：
      initialRoute:"/", //名为"/"的路由作为应用的home(首页)
      routes: {
        "new_route" : (context) => NewRoute(),
        "/":(context) => NameRoutePage(title: "路由命名"),
        "argument_route" : (context) => EchoRoute(),
        //....类似的其他注册信息
      },
    );
  }
}

class NameRoutePage extends StatefulWidget {
  NameRoutePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _NameRouteState createState() => _NameRouteState();
}

class _NameRouteState extends State <NameRoutePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.pushNamed(context, "new_route");
          }, 
          child: Text("路由命名跳转"), 
          textColor: Colors.blue,
        ),
        FlatButton(
          onPressed: (){
            //在打开路由的时候传递参数
            Navigator.of(context).pushNamed("argument_route", arguments: "hi");
          }, 
          child: Text("路由命名跳转传参"), 
          textColor: Colors.blue,
        ),
      ],
    );
  }
}


class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新路由"),
      ),
      body: Text("内容"),
    );
  }
}


class EchoRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新路由"),
      ),
      body: Column(
        children: <Widget>[
          Text("接收路由传过来的参数："),
          Text(ModalRoute.of(context).settings.arguments),
        ],
      )
    );
  }
}


/**
 * 适配

假设我们也想将上面路由传参示例中的TipRoute路由页注册到路由表中，以便也可以通过路由名来打开它。但是，由于TipRoute接受一个text 参数，我们如何在不改变TipRoute源码的前提下适配这种情况？其实很简单：

MaterialApp(
  ... //省略无关代码
  routes: {
   "tip2": (context){
     return TipRoute(text: ModalRoute.of(context).settings.arguments);
   },
 }, 
);


路由生成钩子

假设我们要开发一个电商APP，当用户没有登录时可以看店铺、商品等信息，但交易记录、购物车、用户个人信息等页面需要登录后才能看。为了实现上述功能，我们需要在打开每一个路由页前判断用户登录状态！如果每次打开路由前我们都需要去判断一下将会非常麻烦，那有什么更好的办法吗？答案是有！

MaterialApp有一个onGenerateRoute属性，它在打开命名路由时可能会被调用，之所以说可能，是因为当调用Navigator.pushNamed(...)打开命名路由时，如果指定的路由名在路由表中已注册，则会调用路由表中的builder函数来生成路由组件；如果路由表中没有注册，才会调用onGenerateRoute来生成路由。onGenerateRoute回调签名如下：

Route<dynamic> Function(RouteSettings settings)
有了onGenerateRoute回调，要实现上面控制页面权限的功能就非常容易：我们放弃使用路由表，取而代之的是提供一个onGenerateRoute回调，然后在该回调中进行统一的权限控制，如：

MaterialApp(
  ... //省略无关代码
  onGenerateRoute:(RouteSettings settings){
      return MaterialPageRoute(builder: (context){
           String routeName = settings.name;
       // 如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
       // 引导用户登录；其它情况则正常打开路由。
     }
   );
  }
);
注意，onGenerateRoute只会对命名路由生效。
 */
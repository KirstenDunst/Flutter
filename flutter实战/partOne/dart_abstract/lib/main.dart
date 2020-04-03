import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "dart语言简介",
      theme: ThemeData(primaryColor: Colors.blue),
      home: AbstractDart(),
    );
  }
}

class AbstractDart extends StatefulWidget {
  @override
  AbstractDartState createState() => AbstractDartState();
}

/*
 * Object 是Dart所有对象的根基类，也就是说所有类型都是Object的子类(包括Function和Null)，
 * 所以任何类型的数据都可以赋值给Object声明的对象. dynamic与var一样都是关键词,声明的变量可以赋值任意对象。
 *  而dynamic与Object相同之处在于,他们声明的变量可以在后期改变赋值类型。
 * 
 * dynamic与Object不同的是,dynamic声明的对象编译器会提供所有可能的组合, 而Object声明的对象只能使用Object的属性与方法, 
 * 否则编译器会报错。
 * 
 * dynamic的这个特性与Objective-C中的id作用很像. dynamic的这个特点使得我们在使用它时需要格外注意,这很容易引入一个运行时错误.
 */

/*
 *final和const
 *如果您从未打算更改一个变量，那么使用 final 或 const，不是var，也不是一个类型。 一个 final 变量只能被设置一次，
 *两者区别在于：const 变量是一个编译时常量，final变量在第一次使用时被初始化。被final或者const修饰的变量，变量类型可以省略，
 */

/*
 * Dart是一种真正的面向对象的语言，所以即使是函数也是对象，并且有一个类型Function。这意味着函数可以赋值给变量或作为参数传
 * 递给其他函数，这是函数式编程的典型特征。Dart函数声明如果没有显式声明返回值类型时会默认当做dynamic处理，注意，函数返回值没有类型推断：
 */

class AbstractDartState extends State<AbstractDart> {
  @override
  Widget build(BuildContext context) {
    return null;
  }

/*
 * 可选的位置参数
包装一组函数参数，用[]标记为可选的位置参数，并放在参数列表的最后面：


say('Bob', 'Howdy'); //结果是： Bob says Howdy
say('Bob', 'Howdy', 'smoke signal'); //结果是：Bob says Howdy with a smoke signal
 */
  String say(String from, String msg, [String device]) {
    var result = '$from says $msg';
    if (device != null) {
      result = '$result with a $device';
    }
    return result;
  }

  /*
   * 可选的命名参数
定义函数时，使用{param1, param2, …}，放在参数列表的最后面，用于指定命名参数。例如：
*/
//设置[bold]和[hidden]标志
  void enableFlags({bool bold, bool hidden}) {
    // ...
  }

/*调用函数时，可以使用指定命名参数。例如：paramName: value
enableFlags(bold: true, hidden: false);
可选命名参数在Flutter中使用非常多。

注意，不能同时使用可选的位置参数和可选的命名参数
   */



/*Dart类库有非常多的返回Future或者Stream对象的函数。 这些函数被称为异步函数：它们只会在设置好一些耗时操作之后返回，比如像 IO操作。而不是等到这个操作完成。
*async和await关键词支持了异步编程，允许您写出和同步代码很像的异步代码
stream于future :(且看lib目录下相应名字的dart文件)
*/






}



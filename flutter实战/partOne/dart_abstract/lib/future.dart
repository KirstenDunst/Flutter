/*
 * Future
 * 简单来说，它就是用于处理异步操作的，异步处理成功了就执行成功的操作，异步处理失败了就捕获错误或者停止后续操作。一个Future只会对应一个结果，要么成功，要么失败。

由于本身功能较多，这里我们只介绍其常用的API及特性。还有，请记住，Future 的所有API的返回值仍然是一个Future对象，所以可以很方便的进行链式调用。
 */

main(List<String> args) {
  Future.delayed(new Duration(seconds: 2), () {
    // return "hi world!";
    throw AssertionError("Error");
  }).then((data) {
    //then执行成功的结果返回
    print(data);
  }).catchError((e) {
    //执行失败会走到这里
    print(e);
  });
//同上捕获异常：then的一个onError也可以捕获异常
  Future.delayed(new Duration(seconds: 2), () {
    //return "hi world!";
    throw AssertionError("Error");
  }).then((data) {
    print("success");
  }, onError: (e) {
    print(e);
  });

//Future.whenComplete ：结束之后无论成功或失败都会走到这里
Future.delayed(new Duration(seconds: 2),(){
   //return "hi world!";
   throw AssertionError("Error");
}).then((data){
   //执行成功会走到这里 
   print(data);
}).catchError((e){
   //执行失败会走到这里   
   print(e);
}).whenComplete((){
   //无论成功或失败都会走到这里
});


//Future.wait将内部多个信号进行一个合并操作
Future.wait([
  // 2秒后返回结果  
  Future.delayed(new Duration(seconds: 2), () {
    return "hello";
  }),
  // 4秒后返回结果  
  Future.delayed(new Duration(seconds: 4), () {
    return " world";
  })
]).then((results){
  //都成功才会执行
  print(results[0]+results[1]);
}).catchError((e){
  //只要有异常就会触发
  print(e);
});


//避免嵌套地狱(回掉中执行方法之后再次回调中响应其他事件)
/*
 *例如： 登陆之后根据id获取用户信息，然后在进行本地信息存储 （其中login()是登陆的请求方法，getUserInfo()是获取用户信息方法，saveUserInfo()是本地存储用户信息方法）
 嵌套地狱写法：
 login("alice","******").then((id){
   //登录成功后通过，id获取用户信息    
   getUserInfo(id).then((userInfo){
      //获取用户信息后保存 
      saveUserInfo(userInfo).then((){
         //保存用户信息，接下来执行其它操作
          ...
      });
    });
  })

  使用Future消除Callback Hell写法：
  login("alice","******").then((id){
      return getUserInfo(id);
  }).then((userInfo){
    return saveUserInfo(userInfo);
  }).then((e){
    //执行接下来的操作 
  }).catchError((e){
    //错误处理  
    print(e);
  });

  使用async/await消除callback hell写法：
  task() async {
    try{
      String id = await login("alice","******");
      String userInfo = await getUserInfo(id);
      await saveUserInfo(userInfo);
      //执行接下来的操作   
    } catch(e){
      //错误处理   
      print(e);   
    }  
  }
 */
}

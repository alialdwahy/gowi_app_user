import 'package:flutter/material.dart';
import 'package:gowi_app/account/forgetPassword.dart';
import 'package:gowi_app/account/register.dart';
import 'package:gowi_app/component/progress.dart';
import 'package:gowi_app/home/home.dart';
import 'package:gowi_app/provider/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../config.dart';
import '../function.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isloading = false;

  var _formKey = GlobalKey<FormState>();

  TextEditingController txtcus_pwd = new TextEditingController();
  TextEditingController txtcus_mobile = new TextEditingController();

  loginDataCustomer(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    bool myvalid = _formKey.currentState!.validate();
    load.add_loading();
    if (myvalid) {
      isloading = true;
      load.add_loading();
      Map arr = {
        "cus_pwd": txtcus_pwd.text,
        "cus_mobile": txtcus_mobile.text,
      };

      Map? resArray =
          await SaveDataList(arr, "customer/login.php", context, "select");
      isloading = resArray != null ? true : false;
      if (isloading) {
        SharedPreferences sh = await SharedPreferences.getInstance();
        sh.setString(G_cus_id, resArray!["cus_id"]);
        sh.setString(G_cus_name, resArray["cus_name"]);
        sh.setString(G_cus_image, resArray["cus_image"]);
        sh.setString(G_cus_mobile, resArray["cus_mobile"]);
        sh.setString(G_cus_email, resArray["cus_email"]);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
      /*await createData(
          arr, "delivery/insert_delivery.php", context, () => Delivery());*/

      load.add_loading();
    } else {
      Toast.show("Information is not true", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<LoadingControl>(context);
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 35.0),
                        child: Text(
                          "Sign in to your account here ",
                          style: TextStyle(fontSize: 25.0, color: Colors.red),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0)),
                        child: TextFormField(
                          controller: txtcus_mobile,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Number Phone",
                              border: InputBorder.none),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return "Peales Enter Number Phone";
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: txtcus_pwd,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Passowrd",
                                    border: InputBorder.none),
                                validator: (String? value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return "Peales Enter Password";
                                  }
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgetPassword()));
                              },
                              child: Text(
                                "Forgot ؟",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      ),
                      isloading
                          ? circularProgress()
                          : MaterialButton(
                              onPressed: () {
                                loginDataCustomer(context, myProvider);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                                margin:
                                    EdgeInsets.only(bottom: 10.0, top: 30.0),
                                padding: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(25.0)),
                              )),
                    ],
                  ),
                )),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "If you have an account, register here ",
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        child: Text("SIGN UP",
                            style:
                                TextStyle(color: Colors.red, fontSize: 16.0)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

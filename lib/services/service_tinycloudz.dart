part of 'services.dart';

class TinyCloudzService{
  static Future<http.Response> postMail(String email){
    return http.post(Uri.https(Const.baseUrl, "/week06/api/mailer/sendmail"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
        })
    );
  }
}
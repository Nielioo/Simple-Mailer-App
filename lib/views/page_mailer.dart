part of 'pages.dart';

class MailerPage extends StatefulWidget {
  const MailerPage({Key? key}) : super(key: key);
  static const String routeName = "/";

  @override
  State<MailerPage> createState() => _MailerPageState();
}

class _MailerPageState extends State<MailerPage> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final ctrlEmail = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mailer Page"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          hintText: "Enter your email here",
                          prefixIcon: Icon(Icons.mail),
                        ),
                        controller: ctrlEmail,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return !EmailValidator.validate(value.toString())
                              ? "Invalid email"
                              : null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFE9FDFC),
                            // minimumSize: const Size.fromHeight(36),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text(
                                          'Email Confirmation',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(
                                            "Verification mail will be sent to ${ctrlEmail.text}"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async{

                                              await TinyCloudzService.postMail(ctrlEmail.text);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Verification mail already sent! Please check your email')),
                                              );
                                              Navigator.pop(context, 'OK');
                                              ctrlEmail.text = "";
                                              // Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Something wrong!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  fontSize: 14,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white);
                            }
                          },
                          child: Text("Verify")),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

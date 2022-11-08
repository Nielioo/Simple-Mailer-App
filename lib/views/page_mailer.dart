part of 'pages.dart';

bool _initialUriIsHandled = false;

class MailerPage extends StatefulWidget {
  const MailerPage({Key? key}) : super(key: key);
  static const String routeName = "/";

  @override
  State<MailerPage> createState() => _MailerPageState();
}

class _MailerPageState extends State<MailerPage> {

  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  StreamSubscription? _sub;

  final _scaffoldKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final ctrlEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          _latestUri = uri;
          _err = null;
        });

        // Push to another page if verified
        if(uri != null){
          print("Listener is Working");
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AlreadyVerifiedPage(),));
        }
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      _showSnackBar('_handleInitialUri called');
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
          if (!mounted) return;
          setState(() => _initialUri = uri);
        }
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() => _err = err);
      }
    }
  }

  void _showSnackBar(String msg) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final context = _scaffoldKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
        ));
      }
    });
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
              Lottie.asset("assets/lottie/mail.json", width: 300),
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

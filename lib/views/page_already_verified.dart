part of 'pages.dart';

class AlreadyVerifiedPage extends StatefulWidget {
  const AlreadyVerifiedPage({Key? key}) : super(key: key);
  static const String routeName = "/alreadyVerified";

  @override
  State<AlreadyVerifiedPage> createState() => _AlreadyVerifiedPageState();
}

class _AlreadyVerifiedPageState extends State<AlreadyVerifiedPage> {
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  StreamSubscription? _sub;
  final _scaffoldKey = GlobalKey();
  bool _initialUriIsHandled = false;

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
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    _sub = uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;
      print('got uri: $uri');
      setState(() {
        _latestUri = uri;
        _err = null;
      });
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
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
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
        title: Text('Congratulations Page'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Your email already verified!"),],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skate_spots_app/pages/wrapper.dart';
import 'package:skate_spots_app/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Sk8 Map",
            style: TextStyle(
              fontSize: 50,
              color: Colors.black,
            ),
          ),
          ElevatedButton.icon(
              onPressed: () async {
                dynamic result = await _auth.googleLogIn();

                if (result != null) {
                  print(result);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(result.toString()),
                  ));

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Wrapper(
                            currentPage: 2,
                          )));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("[ERROR]: Couldn't sign in with google!"),
                  ));
                }
              },
              icon: const FaIcon(FontAwesomeIcons.google),
              label: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: const [Text("Sign in with Google")],
                  ))),
          // ElevatedButton.icon(
          //     onPressed: () async {
          //       dynamic result = await _auth.signInAnon();

          //       if (result != null) {
          //         print(result);
          //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           content: Text(result.toString()),
          //         ));
          //         Navigator.of(context).pushReplacement(
          //             MaterialPageRoute(builder: (context) => const Wrapper()));
          //       } else {
          //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //           content: Text("[ERROR]: Couldn't sign in anonymously!"),
          //         ));
          //       }
          //     },
          //     icon: const FaIcon(FontAwesomeIcons.bookmark),
          //     label: Padding(
          //         padding: const EdgeInsets.all(6),
          //         child: Wrap(
          //           crossAxisAlignment: WrapCrossAlignment.center,
          //           children: const [Text("Sign in Anonymously")],
          //         )))
        ],
      ),
    ));
  }
}

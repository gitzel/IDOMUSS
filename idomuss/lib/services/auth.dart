import 'package:firebase_auth/firebase_auth.dart';
import 'package:idomuss/models/cliente.dart';
import 'package:idomuss/models/user.dart';
import 'package:idomuss/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

    final FirebaseAuth _auth = FirebaseAuth.instance;

    // create user obj based on FirebaseUser
    User _userFromFirebaUser(FirebaseUser user){
      return user != null? User(uid: user.uid) : null;
    }

    Stream<User> get user{
      return _auth.onAuthStateChanged.map(_userFromFirebaUser);
    }

    // sign in with email & password
    Future signIn(String email, String password, Cliente client) async{
      try{
        var result = await  _auth.signInWithEmailAndPassword(email: email, password: password);
        FirebaseUser user = result.user;

        await DatabaseService(uid: user.uid).updateUserData(client);

        return _userFromFirebaUser(user);
      }
      catch(e){
        print(e.toString());
        return null;
      }
    }

    final GoogleSignIn googleSignIn = GoogleSignIn();

    //register with google
    Future signInWithGoogle(Cliente client)  async {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
    }

    // register with email & password
    Future register(String email, String password, Cliente client) async{
        try{
          var result = await  _auth.createUserWithEmailAndPassword(email: email, password: password);

          FirebaseUser user = result.user;
          await DatabaseService(uid: user.uid).updateUserData(client);

          return _userFromFirebaUser(user);
        }
        catch(e){
            print(e.toString());
            return null;
        }
    }

    //update email
    Future updateEmailUser(String novoEmail) async {

    }


    // sign out
    Future signOut() async{
      try{
          return await _auth.signOut();
      }catch(e){
        print(e.toString());
        return null;
      }
    }

    // sign out with google
    void signOutGoogle() async{
      await googleSignIn.signOut();
    }
}
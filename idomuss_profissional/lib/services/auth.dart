import 'package:firebase_auth/firebase_auth.dart';
import 'package:idomussprofissional/models/profissional.dart';
import 'package:idomussprofissional/models/user.dart';
import 'database.dart';

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
    Future signIn(String email, String password, Profissional profissional) async{
      try{
        var result = await  _auth.signInWithEmailAndPassword(email: email, password: password);
        FirebaseUser user = result.user;

        await DatabaseService(uid: user.uid).updateUserData(profissional);

        return _userFromFirebaUser(user);
      }
      catch(e){
        print(e.toString());
        return null;
      }
    }

    // register with email & password
    Future register(String email, String password, Profissional profissional) async{
        try{
          var result = await  _auth.createUserWithEmailAndPassword(email: email, password: password);

          FirebaseUser user = result.user;
          await DatabaseService(uid: user.uid).updateUserData(profissional);

          return _userFromFirebaUser(user);
        }
        catch(e){
            print(e.toString());
            return null;
        }
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
}
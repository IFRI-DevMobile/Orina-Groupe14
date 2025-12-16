import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'register_page.dart';
import 'accueil_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool passwordVisible = false; // pour toggle visibilité
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    phoneController.text = box.read('mobile') ?? '';
    passwordController.text = box.read('password') ?? '';
  }

  void login() {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Vérification simple avec GetStorage (simulation)
    if (phoneController.text != box.read('mobile') ||
        passwordController.text != box.read('password')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Numéro ou mot de passe incorrect')),
      );
      return;
    }

    box.write('isLogged', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFF2F2F2);
    Color chocolate = const Color(0xFFC98435);

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ évite overflow quand clavier
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double logoHeight = constraints.maxHeight * 0.1;
            double spacing = constraints.maxHeight * 0.02;
            double fontSizeTitle = constraints.maxHeight * 0.03;
            double fontSizeSub = constraints.maxHeight * 0.02;
            double inputHeight = constraints.maxHeight * 0.065;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.08),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: spacing * 2),

                        // Logo
                        Center(
                          child: Image.asset(
                            'assets/images/logo_orina.png',
                            height: logoHeight,
                          ),
                        ),
                        SizedBox(height: spacing),

                        // Titre
                        Center(
                          child: Text(
                            "Connectez-vous à votre compte",
                            style: TextStyle(
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: spacing / 2),

                        // Sous-texte
                        Center(
                          child: Text(
                            "Bon retour ! Veuillez entrer vos informations",
                            style: TextStyle(
                              fontSize: fontSizeSub,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: spacing * 2),

                        // Champ téléphone
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Numéro de téléphone",
                            hintText: "+229-01-45-90-23-91",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: chocolate),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: chocolate, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: spacing),

                        // Champ mot de passe
                        TextField(
                          controller: passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Mot de passe",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: chocolate),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: chocolate, width: 2),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: spacing / 2),

                        // Checkbox et mot de passe oublié
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  activeColor: chocolate,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                const Text("Se souvenir pendant 30 jours"),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Mot de passe oublié ?",
                                style: TextStyle(color: chocolate),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),

                        // Bouton Se connecter
                        SizedBox(
                          width: double.infinity,
                          height: inputHeight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: chocolate,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: login,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Se connecter",
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: spacing),

                        // Bouton Google
                        SizedBox(
                          width: double.infinity,
                          height: inputHeight,
                          child: OutlinedButton.icon(
                            icon: Image.asset(
                              'assets/images/google.png',
                              height: 24,
                              width: 24,
                            ),
                            label: const Text(
                              "Se connecter avec Gmail",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: chocolate, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomePage()),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: spacing * 2),

                        // Lien vers inscription
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Vous n'avez pas de compte ? "),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                                );
                              },
                              child: Text(
                                "S'inscrire",
                                style: TextStyle(color: chocolate),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';  
import 'onboarding_login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool rememberMe = false;
  bool passwordVisible = false;
  String passwordStrength = ''; 

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    nameController.text = box.read('name') ?? '';
    mobileController.text = box.read('mobile') ?? '';
    passwordController.text = box.read('password') ?? '';
  }

  void checkPasswordStrength(String password) {
    if (password.isEmpty) {
      passwordStrength = '';
    } else if (password.length < 6) {
      passwordStrength = 'Faible';
    } else if (password.length < 10) {
      passwordStrength = 'Moyen';
    } else {
      passwordStrength = 'Fort';
    }
    setState(() {});
  }

  void createAccount() {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    box.write('name', nameController.text);
    box.write('mobile', mobileController.text);
    box.write('password', passwordController.text);
    box.write('isLogged', true);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFF2F2F2);
    Color chocolate = const Color(0xFFC98435);

    return Scaffold(
      resizeToAvoidBottomInset: true, 
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
                        SizedBox(height: spacing),

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
                            "Créer un compte",
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
                            "Veuillez entrer vos coordonnées pour commencer votre parcours",
                            style: TextStyle(
                              fontSize: fontSizeSub,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: spacing * 2),

                        // Champ nom
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Nom",
                            hintText: "Entrez votre nom",
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

                        // Champ mobile
                        TextField(
                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Mobile",
                            hintText: "Entrez votre numéro",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: passwordController,
                              obscureText: !passwordVisible,
                              onChanged: (value) {
                                checkPasswordStrength(value);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Mot de passe",
                                hintText: "Créer un mot de passe (8 caractères min.)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(color: chocolate),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                            SizedBox(height: 4),
                            Text(
                              passwordStrength.isEmpty ? '' : 'Force: $passwordStrength',
                              style: TextStyle(
                                color: passwordStrength == 'Faible'
                                    ? Colors.red
                                    : passwordStrength == 'Moyen'
                                        ? Colors.orange
                                        : Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),

                        // Bouton Créer un compte
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
                            onPressed: createAccount,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Créer un compte",
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: spacing),

                        // Boutons Google et Apple
                        SizedBox(
                          width: double.infinity,
                          height: inputHeight,
                          child: OutlinedButton.icon(
                            icon: Image.asset(
                              "assets/images/google.png",
                              height: 24,
                              width: 24,
                            ),
                            label: const Text(
                              "S'inscrire avec Google",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: chocolate, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(height: spacing),

                        SizedBox(
                          width: double.infinity,
                          height: inputHeight,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.apple, color: Colors.black),
                            label: const Text(
                              "S'inscrire avec Apple",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: chocolate, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(height: spacing * 2),

                        // Lien vers connexion
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Vous avez déjà un compte ? "),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              },
                              child: Text(
                                "Se connecter",
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

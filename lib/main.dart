import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class AppCores {
  static const Color amarelo = Color(0xFFFFD700); // Cor semente
  static const Color cinzaEscuro = Color(0xFF1A1A1A);
  static const Color cinzaMedio = Color(0xFF2C2C2C);
  static const Color cinzaTexto = Color(0xFF888888);
  static const Color vermelho = Color(0xFFEF5350);
  static const Color azul = Color(0xFF42A5F5);
  static const Color verde = Color(0xFF66BB6A);
  static const Color roxo = Color(0xFFAB47BC);
  static const Color fundo = Color(0xFF0D0D0D);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lanterna Inteligente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppCores.fundo, // cor de fundo 0D0D0D
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppCores.amarelo,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppCores.cinzaEscuro,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const LanternaScreen(),
    );
  }
}

class LanternaScreen extends StatefulWidget {
  const LanternaScreen({super.key});
  @override
  State<LanternaScreen> createState() => _LanternaScreenState();
}

class _LanternaScreenState extends State<LanternaScreen> {
  bool _ligada = false;
  bool _modoAutomatico = false;
  
  // Variáveis para o Desafio (Modo SOS)
  bool _modoSOS = false;
  Timer? _timerSOS;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timerSOS?.cancel();
    super.dispose();
  }

  void _alternarLanterna() {
    setState(() {
      _ligada = !_ligada;
      if (!_ligada) _desativarSOS(); // Desliga o SOS se a lanterna for desligada
    });
    _controlarLanternaFisica(_ligada);
  }

  void _alternarModoAutomatico(bool valor) {
    setState(() {
      _modoAutomatico = valor;
      // Em um app real, aqui iniciaríamos o ouvinte do sensor de luminosidade
    });
  }

  // DESAFIO: Função para ativar pisca-pisca de emergência
  void _alternarSOS() {
    setState(() {
      _modoSOS = !_modoSOS;
      if (_modoSOS) {
        _timerSOS = Timer.periodic(const Duration(milliseconds: 300), (timer) {
          setState(() {
            _ligada = !_ligada;
            _controlarLanternaFisica(_ligada);
          });
        });
      } else {
        _desativarSOS();
      }
    });
  }

  void _desativarSOS() {
    _timerSOS?.cancel();
    _modoSOS = false;
  }

  // Integração com Hardware (Tratamento de permissões)
  Future<void> _controlarLanternaFisica(bool estado) async {
    // NOTA: O Flutter nativo não controla hardware diretamente.
    // Para ligar o LED real do dispositivo, você deve adicionar 
    // o pacote 'torch_light' ou 'camera' no pubspec.yaml.
    /*
    try {
      if (estado) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
    } catch (e) {
      // Exibe erro se o dispositivo não tiver lanterna ou permissão negada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao acessar a lanterna física.')),
      );
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), //
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, //
                children: [
                  const Text(
                    '🔦 Lanterna',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _ligada ? AppCores.amarelo : AppCores.cinzaMedio,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _ligada ? 'LIGADA' : 'DESLIGADA',
                      style: TextStyle(
                        color: _ligada ? AppCores.fundo : AppCores.cinzaTexto,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Modo Automático
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _modoAutomatico ? AppCores.roxo.withOpacity(0.15) : AppCores.cinzaEscuro,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _modoAutomatico ? AppCores.roxo : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_mode,
                    color: _modoAutomatico ? AppCores.roxo : AppCores.cinzaTexto,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Modo Automático',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Acende a lanterna em ambientes escuros',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppCores.cinzaTexto,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _modoAutomatico,
                    activeColor: AppCores.roxo,
                    onChanged: _alternarModoAutomatico, //[cite: 6]
                  ),
                ],
              ),
            ),

            // Representação Visual da Lanterna (Animada)
            Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400), //[cite: 6]
                  width: _ligada ? 180 : 120, //[cite: 6]
                  height: _ligada ? 180 : 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _ligada ? AppCores.amarelo.withOpacity(0.2) : AppCores.cinzaEscuro,
                    boxShadow: _ligada
                        ? [
                            BoxShadow(
                              color: AppCores.amarelo.withOpacity(0.5),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    _ligada ? Icons.flashlight_on : Icons.flashlight_off,
                    size: _ligada ? 80 : 50,
                    color: _ligada ? AppCores.amarelo : AppCores.cinzaTexto,
                  ),
                ),
              ),
            ),

            // Controles Principais e Desafio (SOS)
            Padding(
              padding: const EdgeInsets.only(bottom: 60), //[cite: 6]
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão de Energia
                  GestureDetector(
                    onTap: _alternarLanterna,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300), //[cite: 6]
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _ligada ? AppCores.amarelo : AppCores.cinzaMedio,
                        boxShadow: _ligada
                            ? [
                                BoxShadow(
                                  color: AppCores.amarelo.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ]
                            : [],
                      ),
                      child: Icon(
                        Icons.power_settings_new,
                        size: 40,
                        color: _ligada ? AppCores.fundo : AppCores.cinzaTexto,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 30),

                  // Botão Desafio: Modo SOS
                  GestureDetector(
                    onTap: _alternarSOS,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _modoSOS ? AppCores.vermelho : AppCores.cinzaMedio,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 30,
                        color: _modoSOS ? Colors.white : AppCores.cinzaTexto,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
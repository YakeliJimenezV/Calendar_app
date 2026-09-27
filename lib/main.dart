import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const CalendarioApp());
}

class CalendarioApp extends StatelessWidget {
  const CalendarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.fondoOscuro,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const PantallaCalendario(),
    );
  }
}

// ==========================================
// PALETA DE COLORES & ESTILOS GLASS
// ==========================================
class AppColors {
  static const fondoOscuro = Color(0xFF0D111D);
  static const fondoInicio = Color(0xFF14192B);
  static const fondoFin = Color(0xFF251A3E);

  // Esferas de luz ambiental
  static const orbRosa = Color(0xFFEC4899);
  static const orbAzul = Color(0xFF3B82F6);
  static const orbMorado = Color(0xFF8B5CF6);

  // Acentos de color
  static const acentoAzul = Color(0xFF38BDF8);
  static const acentoVerde = Color(0xFF34D399);
  static const acentoMorado = Color(0xFFA78BFA);
  static const acentoNaranja = Color(0xFFFBBF24);

  // Textos
  static const textoPrincipal = Colors.white;
  static const textoSecundario = Color(0xFF94A3B8);
  static const textoTenue = Color(0xFF64748B);
}

// ==========================================
// MODELO DE EVENTOS
// ==========================================
class EventoUI {
  final int id;
  final int dia;
  final String mes;
  final String hora;
  final String titulo;
  final String categoria;
  final IconData icono;
  final Color color;

  const EventoUI({
    required this.id,
    required this.dia,
    required this.mes,
    required this.hora,
    required this.titulo,
    required this.categoria,
    required this.icono,
    required this.color,
  });
}

// ==========================================
// PANTALLA PRINCIPAL INTERACTIVA
// ==========================================
class PantallaCalendario extends StatefulWidget {
  const PantallaCalendario({super.key});

  @override
  State<PantallaCalendario> createState() => _PantallaCalendarioState();
}

class _PantallaCalendarioState extends State<PantallaCalendario> {
  int diaSeleccionado = 26; // Día seleccionado por defecto

  final Map<int, Color> diasConEvento = const {
    5: AppColors.acentoAzul,
    12: AppColors.acentoVerde,
    21: AppColors.acentoMorado,
    28: AppColors.acentoNaranja,
  };

  final List<EventoUI> listaEventos = const [
    EventoUI(
      id: 1,
      dia: 5,
      mes: 'septiembre',
      hora: '10:00 a.m. - 11:30 a.m.',
      titulo: 'Reunión de equipo',
      categoria: 'Trabajo',
      icono: Icons.groups_rounded,
      color: AppColors.acentoAzul,
    ),
    EventoUI(
      id: 2,
      dia: 12,
      mes: 'septiembre',
      hora: '09:00 a.m. - 10:30 a.m.',
      titulo: 'Examen de programación',
      categoria: 'Estudios',
      icono: Icons.code_rounded,
      color: AppColors.acentoVerde,
    ),
    EventoUI(
      id: 3,
      dia: 21,
      mes: 'septiembre',
      hora: '02:00 p.m. - 03:30 p.m.',
      titulo: 'Presentación de proyecto',
      categoria: 'Sprint',
      icono: Icons.bar_chart_rounded,
      color: AppColors.acentoMorado,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final eventosFiltrados = listaEventos
        .where((e) => e.dia == diaSeleccionado)
        .toList();

    final eventosAMostrar = eventosFiltrados.isNotEmpty
        ? eventosFiltrados
        : listaEventos;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Fondo Gradiente de Base
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.fondoInicio,
                  AppColors.fondoOscuro,
                  AppColors.fondoFin,
                ],
              ),
            ),
          ),

          // 2. Luces de Fondo (Efecto Glassmorphism)
          Positioned(
            top: -60,
            right: -40,
            child: _EsferaBrillante(
              color: AppColors.orbMorado.withOpacity(0.35),
              tamano: 220,
            ),
          ),
          Positioned(
            top: 250,
            left: -80,
            child: _EsferaBrillante(
              color: AppColors.orbAzul.withOpacity(0.28),
              tamano: 260,
            ),
          ),
          Positioned(
            bottom: 40,
            right: -50,
            child: _EsferaBrillante(
              color: AppColors.orbRosa.withOpacity(0.25),
              tamano: 200,
            ),
          ),

          // 3. Contenido Principal
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ENCABEZADO CON NOMBRE ACTUALIZADO
                  const _EncabezadoPerfil(),
                  const SizedBox(height: 20),

                  const _SelectorMes(),
                  const SizedBox(height: 16),

                  // Tarjeta del Calendario
                  _TarjetaGlass(
                    child: Column(
                      children: [
                        const _DiasSemanaHeader(),
                        const SizedBox(height: 12),
                        const Divider(
                          color: Colors.white10,
                          height: 1,
                          thickness: 1,
                        ),
                        const SizedBox(height: 12),
                        _CuadriculaMes(
                          diaSeleccionado: diaSeleccionado,
                          diasConEvento: diasConEvento,
                          onDiaSeleccionado: (dia) {
                            setState(() {
                              diaSeleccionado = dia;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _TituloSeccion(
                        titulo: eventosFiltrados.isNotEmpty
                            ? 'Eventos del día $diaSeleccionado'
                            : 'Próximas Reservas',
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.acentoAzul.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.acentoAzul.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '${eventosAMostrar.length} eventos',
                          style: const TextStyle(
                            color: AppColors.acentoAzul,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: eventosAMostrar.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _TarjetaEvento(
                        evento: eventosAMostrar[index],
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // Botón Flotante
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        elevation: 8,
        backgroundColor: Colors.transparent,
        focusElevation: 0,
        highlightElevation: 0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.acentoAzul, AppColors.acentoMorado],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.acentoAzul.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.add_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Nuevo Evento',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET DEL ENCABEZADO (CON EL NOMBRE "YAKELI")
// ==========================================
class _EncabezadoPerfil extends StatelessWidget {
  const _EncabezadoPerfil();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.acentoAzul, AppColors.acentoMorado],
                ),
              ),
              child: const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.fondoOscuro,
                child: Icon(Icons.person_rounded, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, Yakeli 👋', // 👈 NOMBRE CAMBIADO AQUÍ
                  style: TextStyle(
                    color: AppColors.textoPrincipal,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Organiza tu agenda',
                  style: TextStyle(
                    color: AppColors.textoSecundario,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        _BotonIconoGlass(
          icono: Icons.notifications_none_rounded,
          onTap: () {},
        ),
      ],
    );
  }
}

// ==========================================
// WIDGETS AUXILIARES
// ==========================================
class _EsferaBrillante extends StatelessWidget {
  final Color color;
  final double tamano;

  const _EsferaBrillante({required this.color, required this.tamano});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class _TarjetaGlass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _TarjetaGlass({
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SelectorMes extends StatelessWidget {
  const _SelectorMes();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SEPTIEMBRE 2026',
              style: TextStyle(
                color: AppColors.textoPrincipal,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
            Text(
              '4 eventos agendados',
              style: TextStyle(
                color: AppColors.textoTenue,
                fontSize: 12,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _BotonIconoGlass(
              icono: Icons.chevron_left_rounded,
              onTap: () {},
            ),
            const SizedBox(width: 8),
            _BotonIconoGlass(
              icono: Icons.chevron_right_rounded,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _BotonIconoGlass extends StatelessWidget {
  final IconData icono;
  final VoidCallback onTap;

  const _BotonIconoGlass({required this.icono, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          child: Icon(icono, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _DiasSemanaHeader extends StatelessWidget {
  const _DiasSemanaHeader();

  static const nombres = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: nombres
          .map(
            (n) => Expanded(
              child: Center(
                child: Text(
                  n,
                  style: const TextStyle(
                    color: AppColors.textoSecundario,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CuadriculaMes extends StatelessWidget {
  final int diaSeleccionado;
  final Map<int, Color> diasConEvento;
  final ValueChanged<int> onDiaSeleccionado;

  const _CuadriculaMes({
    required this.diaSeleccionado,
    required this.diasConEvento,
    required this.onDiaSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    const diaInicioMes = [31];
    const diasDelMes = 30;

    final celdas = <Widget>[];

    for (final d in diaInicioMes) {
      celdas.add(_CeldaDia(numero: d, esDelMes: false));
    }

    for (int dia = 1; dia <= diasDelMes; dia++) {
      celdas.add(
        _CeldaDia(
          numero: dia,
          esDelMes: true,
          esSeleccionado: dia == diaSeleccionado,
          colorEvento: diasConEvento[dia],
          onTap: () => onDiaSeleccionado(dia),
        ),
      );
    }

    int siguiente = 1;
    while (celdas.length % 7 != 0) {
      celdas.add(_CeldaDia(numero: siguiente, esDelMes: false));
      siguiente++;
    }

    final filas = <Widget>[];
    for (int i = 0; i < celdas.length; i += 7) {
      filas.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: celdas.sublist(i, i + 7),
        ),
      );
    }

    return Column(
      children: filas
          .map((fila) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: fila,
              ))
          .toList(),
    );
  }
}

class _CeldaDia extends StatelessWidget {
  final int numero;
  final bool esDelMes;
  final bool esSeleccionado;
  final Color? colorEvento;
  final VoidCallback? onTap;

  const _CeldaDia({
    required this.numero,
    this.esDelMes = true,
    this.esSeleccionado = false,
    this.colorEvento,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: esDelMes ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 38,
          margin: const EdgeInsets.all(2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: esSeleccionado
                ? const LinearGradient(
                    colors: [AppColors.acentoAzul, AppColors.acentoMorado],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: Colors.transparent,
            boxShadow: esSeleccionado
                ? [
                    BoxShadow(
                      color: AppColors.acentoAzul.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$numero',
                style: TextStyle(
                  fontWeight:
                      esSeleccionado ? FontWeight.w800 : FontWeight.w600,
                  color: esSeleccionado
                      ? Colors.white
                      : (esDelMes
                          ? AppColors.textoPrincipal
                          : AppColors.textoTenue.withOpacity(0.3)),
                  fontSize: 13,
                ),
              ),
              if (colorEvento != null && !esSeleccionado)
                Positioned(
                  bottom: 3,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorEvento,
                      boxShadow: [
                        BoxShadow(
                          color: colorEvento!.withOpacity(0.8),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  final String titulo;
  const _TituloSeccion({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.acentoAzul, AppColors.acentoMorado],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          titulo,
          style: const TextStyle(
            color: AppColors.textoPrincipal,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _TarjetaEvento extends StatelessWidget {
  final EventoUI evento;

  const _TarjetaEvento({required this.evento});

  @override
  Widget build(BuildContext context) {
    return _TarjetaGlass(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: evento.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: evento.color.withOpacity(0.4),
                width: 1.2,
              ),
            ),
            child: Icon(
              evento.icono,
              color: evento.color,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        evento.categoria.toUpperCase(),
                        style: TextStyle(
                          color: evento.color,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${evento.dia} de ${evento.mes}',
                      style: const TextStyle(
                        color: AppColors.textoTenue,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  evento.titulo,
                  style: const TextStyle(
                    color: AppColors.textoPrincipal,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: AppColors.textoSecundario,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      evento.hora,
                      style: const TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.white.withOpacity(0.4),
            size: 22,
          ),
        ],
      ),
    );
  }
}
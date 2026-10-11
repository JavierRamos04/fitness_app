// Guía de técnica de cada ejercicio del catálogo.
//
// Son datos de solo lectura (no se guardan en la base de datos): se buscan por
// el nombre exacto del ejercicio. Un test comprueba que todos los ejercicios
// del catálogo tienen guía.

/// Cómo respirar cuando el ejercicio no indica otra cosa.
const String defaultBreathingTip =
    'Exhala al hacer el esfuerzo (al subir o empujar) e inhala al bajar o '
    'regresar. No aguantes la respiración.';

/// Aviso general que acompaña a toda la guía.
const String guideDisclaimer =
    'Esta guía es orientativa y no sustituye a un entrenador. Si sientes dolor '
    'agudo (no la molestia normal del esfuerzo), detente. Si tienes una lesión '
    'o condición médica, consulta antes con un profesional.';

class ExerciseGuide {
  const ExerciseGuide({
    required this.steps,
    required this.cues,
    required this.mistakes,
    this.easier,
    this.harder,
    this.safety,
    this.breathing,
  });

  /// Pasos de ejecución, en orden.
  final List<String> steps;

  /// Puntos clave para hacerlo bien.
  final List<String> cues;

  /// Errores frecuentes.
  final List<String> mistakes;

  /// Cómo hacerlo más fácil, si hace falta.
  final String? easier;

  /// Cómo hacerlo más difícil cuando ya lo domines.
  final String? harder;

  /// Advertencia de seguridad específica.
  final String? safety;

  /// Indicación de respiración propia del ejercicio.
  final String? breathing;
}

/// Busca la guía por el nombre exacto del ejercicio.
ExerciseGuide? guideForExercise(String name) => exerciseGuides[name];

const Map<String, ExerciseGuide> exerciseGuides = {
  // ───────────── Pierna ─────────────
  'Sentadilla con peso corporal': ExerciseGuide(
    steps: [
      'Párate con los pies a la anchura de los hombros y las puntas ligeramente hacia afuera.',
      'Lleva los brazos al frente para equilibrarte y aprieta el abdomen.',
      'Baja llevando la cadera hacia atrás y doblando las rodillas, como si te sentaras en una silla.',
      'Baja hasta donde puedas sin que se redondee la espalda baja; con los muslos paralelos al suelo es una buena meta.',
      'Empuja el suelo con todo el pie para subir y estira cadera y rodillas.',
    ],
    cues: [
      'Peso repartido en todo el pie, con los talones pegados al suelo.',
      'Las rodillas siguen la dirección de las puntas de los pies.',
      'Pecho arriba y mirada al frente.',
    ],
    mistakes: [
      'Que las rodillas se vayan hacia adentro.',
      'Levantar los talones del suelo.',
      'Redondear la espalda baja al llegar abajo.',
    ],
    easier: 'Siéntate y levántate de una silla o banco con control.',
    harder: 'Sentadilla goblet con una mancuerna, o baja en 3 segundos y haz una pausa abajo.',
  ),
  'Sentadilla goblet': ExerciseGuide(
    steps: [
      'Sujeta una mancuerna en vertical contra el pecho con ambas manos y los codos hacia abajo.',
      'Separa los pies un poco más que los hombros, con las puntas ligeramente hacia afuera.',
      'Baja con la espalda recta, llevando la cadera atrás y abajo, entre las rodillas.',
      'Los codos quedan entre las rodillas al llegar abajo, con el pecho alto.',
      'Sube empujando el suelo hasta estirar por completo las piernas.',
    ],
    cues: [
      'La mancuerna pegada al pecho durante todo el movimiento.',
      'Espalda recta y pecho alto.',
      'Controla la bajada, sin rebotar abajo.',
    ],
    mistakes: [
      'Dejar que la mancuerna se aleje del cuerpo y el torso se incline hacia adelante.',
      'Levantar los talones.',
      'Rebotar en la parte baja.',
    ],
    easier: 'Sentadilla con peso corporal.',
    harder: 'Más peso, una pausa de 2 segundos abajo o sentadilla con barra.',
  ),
  'Sentadilla con barra': ExerciseGuide(
    steps: [
      'Coloca la barra sobre la parte alta de la espalda (los trapecios), no sobre el cuello, y sujétala con las manos cerca de los hombros.',
      'Saca la barra del soporte, da un paso atrás y separa los pies a la anchura de los hombros.',
      'Respira hondo, aprieta el abdomen y baja llevando la cadera atrás y las rodillas hacia afuera.',
      'Baja hasta que los muslos queden al menos paralelos al suelo, con la espalda neutra.',
      'Sube empujando el suelo y exhala al pasar la parte más difícil.',
    ],
    cues: [
      'Abdomen firme todo el tiempo, como si fueras a recibir un golpe.',
      'Mirada al frente y espalda neutra.',
      'La barra se mueve en línea vertical sobre la mitad del pie.',
    ],
    mistakes: [
      'Cargar más peso del que puedes controlar.',
      'Que la cadera suba antes que el pecho al levantarte.',
      'Dejar que las rodillas se vayan hacia adentro.',
    ],
    safety: 'Usa los soportes de seguridad del rack o pide a alguien que te cuide. Si no puedes controlar la bajada, baja el peso.',
    easier: 'Sentadilla goblet.',
    harder: 'Sube el peso poco a poco, o añade una pausa abajo.',
  ),
  'Prensa de piernas': ExerciseGuide(
    steps: [
      'Siéntate con la espalda y la cadera totalmente apoyadas en el respaldo.',
      'Coloca los pies en la plataforma a la anchura de los hombros y a media altura.',
      'Quita los seguros y baja la plataforma despacio, doblando las rodillas hacia el pecho.',
      'Baja hasta unos 90° de rodilla, sin que la cadera se despegue del asiento.',
      'Empuja con todo el pie hasta casi estirar las piernas, sin bloquear las rodillas.',
    ],
    cues: [
      'Cadera y espalda baja pegadas al asiento.',
      'Las rodillas quedan alineadas con los pies.',
      'Estira sin bloquear las rodillas.',
    ],
    mistakes: [
      'Bajar tanto que la pelvis se despega y se redondea la espalda baja.',
      'Bloquear las rodillas al estirar.',
      'Rebotar en la parte baja.',
    ],
    safety: 'Al terminar, vuelve a poner los seguros antes de levantarte.',
    easier: 'Menos peso, o sentadilla con peso corporal.',
    harder: 'Más peso, o una pausa de 2 segundos abajo.',
  ),
  'Zancadas': ExerciseGuide(
    steps: [
      'Párate erguido con los pies juntos o a la anchura de la cadera.',
      'Da un paso largo hacia adelante.',
      'Baja la rodilla de atrás hacia el suelo, sin golpearlo, hasta que ambas rodillas formen unos 90°.',
      'Mantén el torso erguido y el peso en el talón de la pierna de adelante.',
      'Empuja con la pierna de adelante para volver al inicio y alterna de pierna.',
    ],
    cues: [
      'Da un paso lo bastante largo para que la rodilla de adelante quede sobre el tobillo.',
      'Torso erguido.',
      'Mira un punto fijo para mantener el equilibrio.',
    ],
    mistakes: [
      'Dar un paso demasiado corto, con la rodilla muy adelante de los dedos.',
      'Inclinar el torso hacia adelante.',
      'Dejar que la rodilla de adelante se vaya hacia adentro.',
    ],
    easier: 'Sentadilla dividida sin moverte, apoyándote en una pared o silla.',
    harder: 'Sostén mancuernas o pasa a la sentadilla búlgara.',
  ),
  'Sentadilla dividida': ExerciseGuide(
    steps: [
      'Colócate con un pie adelante y el otro atrás, separados por un paso largo y a la anchura de la cadera.',
      'Mantén esa posición fija durante toda la serie.',
      'Baja en línea recta, doblando ambas rodillas, hasta que la rodilla de atrás quede cerca del suelo.',
      'Mantén el torso erguido y un poco más de peso sobre la pierna de adelante.',
      'Sube empujando con la pierna de adelante. Al terminar las repeticiones, cambia de pierna.',
    ],
    cues: [
      'El movimiento es vertical, no hacia adelante y atrás.',
      'La rodilla de adelante queda alineada con el pie.',
      'Torso erguido.',
    ],
    mistakes: [
      'Dar un paso demasiado corto.',
      'Inclinar el torso hacia adelante.',
      'Cargar todo el peso en la pierna de atrás.',
    ],
    easier: 'Apóyate con una mano en una pared o en una silla.',
    harder: 'Sostén mancuernas, o pasa a la sentadilla búlgara.',
  ),
  'Step-up': ExerciseGuide(
    steps: [
      'Colócate frente a un escalón, banco o silla firme y estable, de una altura que doble tu rodilla unos 90° al subir el pie.',
      'Apoya todo el pie derecho sobre el escalón.',
      'Empuja con esa pierna (no con la de abajo) hasta quedar de pie arriba.',
      'Baja despacio hasta tocar el suelo con el otro pie.',
      'Completa las repeticiones y cambia de pierna.',
    ],
    cues: [
      'Todo el pie sobre el escalón, con el peso en el talón.',
      'Torso erguido, sin impulsarte con la pierna de atrás.',
      'Baja con control.',
    ],
    mistakes: [
      'Impulsarte con el pie que queda en el suelo.',
      'Usar un escalón inestable o demasiado alto.',
      'Dejarte caer al bajar.',
    ],
    safety: 'Asegúrate de que el escalón o la silla no se muevan.',
    easier: 'Usa un escalón más bajo.',
    harder: 'Usa un escalón más alto o sostén mancuernas.',
  ),
  'Sentadilla búlgara': ExerciseGuide(
    steps: [
      'De espaldas a un banco o silla estable, apoya el empeine de un pie en él; el otro pie queda adelante, a un paso largo.',
      'Mantén el torso erguido.',
      'Baja doblando la rodilla de adelante hasta que el muslo quede casi paralelo al suelo.',
      'La rodilla de atrás baja hacia el suelo.',
      'Empuja con la pierna de adelante para subir. Al terminar las repeticiones, cambia de lado.',
    ],
    cues: [
      'Pon el pie de adelante lo bastante lejos para que la rodilla no se pase mucho de los dedos.',
      'Torso erguido o apenas inclinado.',
      'Peso en el talón de adelante.',
    ],
    mistakes: [
      'Poner el pie de adelante demasiado cerca del banco.',
      'Dejar que la rodilla se vaya hacia adentro.',
      'Empujar con la pierna de atrás en lugar de la de adelante.',
    ],
    safety: 'Usa un banco estable. Empieza sin peso hasta tener buen equilibrio.',
    easier: 'Sentadilla dividida.',
    harder: 'Sostén mancuernas en las manos.',
  ),
  'Extensión de rodilla': ExerciseGuide(
    steps: [
      'Siéntate con la espalda apoyada y ajusta el respaldo para que las rodillas queden en el borde del asiento.',
      'Coloca el rodillo sobre la parte baja de las espinillas, justo encima de los pies.',
      'Estira las piernas hasta casi dejarlas rectas y aprieta los cuádriceps arriba durante un segundo.',
      'Baja despacio hasta unos 90° de rodilla, sin dejar caer el peso.',
    ],
    cues: [
      'Sube sin balanceo ni impulso.',
      'Baja en 2–3 segundos.',
      'Cadera pegada al asiento.',
    ],
    mistakes: [
      'Bloquear las rodillas de golpe arriba.',
      'Soltar el peso al bajar.',
      'Despegar la cadera del asiento.',
    ],
    easier: 'Usa menos peso.',
    harder: 'Más peso o una pausa de 2 segundos arriba.',
  ),
  'Curl femoral': ExerciseGuide(
    steps: [
      'Ajusta la máquina para que el rodillo quede sobre la parte baja de las pantorrillas, justo encima de los talones, y el eje de giro coincida con tu rodilla.',
      'Acomódate y sujeta las asas.',
      'Dobla las rodillas llevando los talones hacia los glúteos.',
      'Aprieta la parte trasera del muslo al final del recorrido.',
      'Regresa despacio, en 2–3 segundos, sin dejar caer el peso.',
    ],
    cues: [
      'Movimiento lento y controlado, sobre todo al regresar.',
      'Cadera pegada al asiento o al banco.',
      'Sin impulso.',
    ],
    mistakes: [
      'Despegar la cadera del banco.',
      'Dejar caer el peso al regresar.',
      'Usar demasiada carga y balancearse.',
    ],
    easier: 'Usa menos peso.',
    harder: 'Más peso o bajar en 3–4 segundos.',
  ),
  'Elevación de pantorrillas': ExerciseGuide(
    steps: [
      'Párate con los pies a la anchura de la cadera y las puntas al frente; apóyate en una pared o silla si necesitas equilibrio.',
      'Para más recorrido, pon la punta de los pies en el borde de un escalón, con los talones al aire.',
      'Sube sobre las puntas de los pies lo más alto que puedas.',
      'Haz una pausa de 1 segundo arriba.',
      'Baja despacio hasta sentir el estiramiento en las pantorrillas.',
    ],
    cues: [
      'Recorrido completo: llega arriba y baja del todo.',
      'Sube sin balancearte.',
      'Baja en 2–3 segundos.',
    ],
    mistakes: [
      'Rebotar sin llegar arriba.',
      'Doblar las rodillas.',
      'Ir demasiado rápido.',
    ],
    easier: 'Apóyate con las manos en una pared.',
    harder: 'Sostén mancuernas o hazla a una pierna.',
  ),
  'Elevación de pantorrillas a una pierna': ExerciseGuide(
    steps: [
      'Párate sobre una pierna, con la otra doblada hacia atrás, y apóyate con una mano en una pared o silla.',
      'Si quieres más recorrido, apoya la punta del pie en el borde de un escalón.',
      'Sube sobre la punta del pie lo más alto que puedas.',
      'Haz una pausa de 1 segundo arriba.',
      'Baja despacio hasta sentir el estiramiento. Al terminar las repeticiones, cambia de pierna.',
    ],
    cues: [
      'Recorrido completo.',
      'Apóyate solo lo necesario para mantener el equilibrio.',
      'Baja en 2–3 segundos.',
    ],
    mistakes: [
      'Rebotar sin llegar arriba.',
      'Empujarte con la pierna que está en el aire.',
      'Ir demasiado rápido.',
    ],
    easier: 'Elevación de pantorrillas con los dos pies.',
    harder: 'Sostén una mancuerna en la mano del mismo lado de la pierna que trabaja.',
  ),

  // ───────────── Cadera y glúteos ─────────────
  'Peso muerto rumano': ExerciseGuide(
    steps: [
      'Sostén una mancuerna en cada mano frente a los muslos; de pie, con los pies a la anchura de la cadera y las rodillas ligeramente flexionadas.',
      'Lleva la cadera hacia atrás, como para cerrar una puerta con el glúteo, y deja que las mancuernas bajen pegadas a las piernas.',
      'Mantén la espalda recta y baja hasta sentir un estiramiento fuerte detrás de los muslos (normalmente por debajo de la rodilla).',
      'Aprieta los glúteos y empuja la cadera hacia adelante para volver a estar de pie.',
    ],
    cues: [
      'Las rodillas casi no cambian de ángulo: el movimiento sale de la cadera.',
      'Las mancuernas pegadas a las piernas.',
      'Espalda neutra todo el tiempo.',
    ],
    mistakes: [
      'Redondear la espalda.',
      'Doblar demasiado las rodillas y convertirlo en una sentadilla.',
      'Dejar las mancuernas lejos de las piernas.',
    ],
    safety: 'Si la espalda se redondea, baja menos o usa menos peso.',
    easier: 'Hazlo con mancuernas muy ligeras o sin peso para aprender el movimiento.',
    harder: 'Más peso o hazlo a una pierna.',
  ),
  'Peso muerto convencional': ExerciseGuide(
    steps: [
      'Colócate con la barra sobre la mitad de los pies y los pies a la anchura de la cadera.',
      'Agáchate y toma la barra justo por fuera de las piernas, con los brazos estirados.',
      'Baja la cadera hasta que las espinillas toquen la barra, con el pecho alto y la espalda recta.',
      'Respira, aprieta el abdomen y empuja el suelo con los pies mientras la barra sube pegada a las piernas.',
      'Termina de pie, con cadera y rodillas estiradas, sin inclinarte hacia atrás.',
      'Baja la barra con control, llevando primero la cadera hacia atrás.',
    ],
    cues: [
      'La barra siempre pegada al cuerpo.',
      'Espalda neutra de principio a fin.',
      'Empuja el suelo; no “jales” la barra con los brazos.',
    ],
    mistakes: [
      'Redondear la espalda baja.',
      'Dejar que la barra se aleje de las piernas.',
      'Dar un tirón al inicio o tirar con los brazos.',
    ],
    safety: 'Empieza con poco peso hasta dominar la técnica. Si no puedes mantener la espalda recta, baja la carga.',
    easier: 'Peso muerto rumano con mancuernas.',
    harder: 'Sube el peso de forma gradual.',
  ),
  'Peso muerto a una pierna': ExerciseGuide(
    steps: [
      'De pie sobre una pierna con la rodilla ligeramente flexionada; apóyate con una mano en una pared si lo necesitas.',
      'Inclina el torso hacia adelante llevando la otra pierna hacia atrás, en línea con la espalda.',
      'Baja hasta que el torso quede casi paralelo al suelo o sientas el estiramiento detrás del muslo.',
      'Aprieta el glúteo de la pierna de apoyo y vuelve a subir.',
      'Al terminar las repeticiones, cambia de pierna.',
    ],
    cues: [
      'Cadera y hombros mirando al suelo, sin girar.',
      'Espalda recta.',
      'Mira un punto fijo para mantener el equilibrio.',
    ],
    mistakes: [
      'Girar la cadera hacia arriba.',
      'Redondear la espalda.',
      'Doblar demasiado la rodilla de apoyo.',
    ],
    easier: 'Apóyate en una pared, o toca el suelo con la punta del pie de atrás.',
    harder: 'Sostén una mancuerna.',
  ),
  'Hip thrust': ExerciseGuide(
    steps: [
      'Siéntate en el suelo con la espalda alta apoyada en un sofá, banco o cama estable y las rodillas dobladas, con los pies apoyados.',
      'Apoya la parte baja de los omóplatos en el borde y coloca los pies cerca de los glúteos, a la anchura de la cadera.',
      'Empuja con los talones y sube la cadera hasta que torso y muslos queden en línea.',
      'Aprieta los glúteos arriba durante 1 segundo, con la barbilla hacia el pecho.',
      'Baja la cadera con control, sin apoyarla del todo en el suelo, y repite.',
    ],
    cues: [
      'Empuja con los talones.',
      'Costillas abajo: no arquees la espalda baja arriba.',
      'Aprieta los glúteos al final.',
    ],
    mistakes: [
      'Subir arqueando la espalda baja en lugar de usar los glúteos.',
      'Poner los pies demasiado lejos o demasiado cerca.',
      'Apoyar el cuello en lugar de la espalda alta.',
    ],
    easier: 'Puente de glúteos en el suelo.',
    harder: 'Pon una mancuerna o una mochila con peso sobre la cadera, o hazlo a una pierna.',
  ),
  'Puente de glúteos': ExerciseGuide(
    steps: [
      'Acuéstate boca arriba con las rodillas dobladas y los pies apoyados en el suelo, a la anchura de la cadera y cerca de los glúteos.',
      'Deja los brazos a los lados, con las palmas en el suelo.',
      'Empuja con los talones y sube la cadera hasta que hombros, cadera y rodillas formen una línea.',
      'Aprieta los glúteos arriba durante 1–2 segundos.',
      'Baja despacio hasta casi tocar el suelo y repite.',
    ],
    cues: [
      'Empuja con los talones.',
      'Costillas abajo: sin arquear la espalda baja.',
      'Aprieta los glúteos arriba.',
    ],
    mistakes: [
      'Arquear la espalda baja al subir.',
      'Empujar con las puntas de los pies.',
      'Subir rápido sin apretar los glúteos.',
    ],
    harder: 'Hip thrust, o puente a una pierna.',
  ),
  'Patada de glúteo en cuadrupedia': ExerciseGuide(
    steps: [
      'Colócate en cuadrupedia: manos bajo los hombros y rodillas bajo la cadera, con la espalda neutra.',
      'Aprieta el abdomen.',
      'Lleva una pierna hacia atrás y arriba, con la rodilla doblada a 90° y la planta del pie hacia el techo.',
      'Sube hasta que el muslo quede en línea con la espalda, sin arquearla.',
      'Aprieta el glúteo arriba y baja con control. Al terminar las repeticiones, cambia de pierna.',
    ],
    cues: [
      'El movimiento sale del glúteo, no de la espalda baja.',
      'Cadera cuadrada al suelo.',
      'Sin balanceo.',
    ],
    mistakes: [
      'Arquear la espalda baja.',
      'Girar la cadera hacia un lado.',
      'Usar impulso.',
    ],
    easier: 'Sube la pierna menos alto.',
    harder: 'Haz una pausa de 2 segundos arriba, o pon una banda elástica sobre las rodillas.',
  ),
  'Caminata lateral con banda': ExerciseGuide(
    steps: [
      'Coloca la banda justo por encima de las rodillas o de los tobillos.',
      'Con los pies a la anchura de la cadera, dobla un poco las rodillas y lleva la cadera atrás (media sentadilla).',
      'Da un paso lateral con una pierna manteniendo la tensión de la banda.',
      'Acerca la otra pierna sin juntar del todo los pies.',
      'Repite en una dirección y luego en la otra.',
    ],
    cues: [
      'Tensión constante en la banda.',
      'Pasos cortos y controlados.',
      'Rodillas alineadas con los pies.',
    ],
    mistakes: [
      'Juntar los pies entre pasos.',
      'Dejar que las rodillas se vayan hacia adentro.',
      'Subir y bajar el cuerpo al caminar.',
    ],
    easier: 'Usa una banda más suave o colócala en los muslos.',
    harder: 'Usa una banda más tensa o colócala más abajo.',
    breathing: 'Respira de forma continua y relajada mientras caminas.',
  ),

  // ───────────── Empuje ─────────────
  'Flexiones': ExerciseGuide(
    steps: [
      'Colócate boca abajo con las manos en el suelo, un poco más abiertas que los hombros, y apoya las puntas de los pies.',
      'Forma una línea recta de la cabeza a los talones, con abdomen y glúteos apretados.',
      'Baja el pecho hacia el suelo doblando los codos, a unos 45° del cuerpo.',
      'Baja hasta casi tocar el suelo con el pecho.',
      'Empuja el suelo hasta estirar los brazos sin perder la línea recta.',
    ],
    cues: [
      'El cuerpo es una tabla: la cadera no se cae ni sube.',
      'Los codos a unos 45° del cuerpo, no abiertos hacia los lados.',
      'Mira al suelo, un poco por delante de las manos.',
    ],
    mistakes: [
      'Dejar caer la cadera o subir los glúteos.',
      'Abrir mucho los codos.',
      'Hacer solo medio recorrido.',
    ],
    easier: 'Flexiones inclinadas, con las manos sobre una mesa o un sofá.',
    harder: 'Baja en 3 segundos o eleva los pies sobre una silla.',
  ),
  'Flexiones inclinadas': ExerciseGuide(
    steps: [
      'Apoya las manos en una superficie firme y estable (mesa, banco o sofá), un poco más abiertas que los hombros.',
      'Da un paso atrás hasta formar una línea recta de la cabeza a los talones.',
      'Baja el pecho hacia la superficie doblando los codos a unos 45° del cuerpo.',
      'Empuja hasta estirar los brazos.',
    ],
    cues: [
      'Cuerpo en línea recta.',
      'Cuanto más baja la superficie, más difícil.',
      'Codos a unos 45° del cuerpo.',
    ],
    mistakes: [
      'Dejar caer la cadera.',
      'Usar una superficie que se mueve.',
      'Hacer solo medio recorrido.',
    ],
    safety: 'Elige una superficie que no se deslice ni se mueva.',
    easier: 'Usa una superficie más alta.',
    harder: 'Baja poco a poco la altura de la superficie hasta llegar a flexiones en el suelo.',
  ),
  'Flexiones en pica': ExerciseGuide(
    steps: [
      'Colócate con las manos en el suelo y la cadera elevada, formando una “V” invertida, con los pies un poco separados.',
      'Manos un poco más abiertas que los hombros y cabeza entre los brazos.',
      'Baja la cabeza hacia el suelo doblando los codos, hacia un punto entre las manos.',
      'Empuja el suelo para volver a subir.',
    ],
    cues: [
      'Cadera alta durante todo el movimiento.',
      'Codos a unos 45° del cuerpo.',
      'Movimiento controlado.',
    ],
    mistakes: [
      'Bajar la cadera y convertirlo en una flexión normal.',
      'Abrir mucho los codos.',
      'Hacer solo medio recorrido.',
    ],
    easier: 'Haz el movimiento con menos recorrido, o apoya las manos en una superficie elevada.',
    harder: 'Eleva los pies sobre una silla.',
  ),
  'Press de banca': ExerciseGuide(
    steps: [
      'Acuéstate en el banco con los ojos bajo la barra, los pies firmes en el suelo y los omóplatos juntos hacia atrás y abajo.',
      'Agarra la barra un poco más abierto que los hombros.',
      'Saca la barra del soporte y llévala sobre el pecho con los brazos estirados.',
      'Baja con control hasta rozar la parte media del pecho, con los codos a unos 45–75° del cuerpo.',
      'Empuja hacia arriba hasta estirar los brazos y exhala.',
    ],
    cues: [
      'Omóplatos juntos y pecho alto durante todo el ejercicio.',
      'Muñecas rectas, sobre los antebrazos.',
      'Pies firmes en el suelo y glúteos en el banco.',
    ],
    mistakes: [
      'Abrir los codos a 90° del cuerpo.',
      'Rebotar la barra en el pecho.',
      'Despegar los glúteos del banco.',
    ],
    safety: 'Usa los soportes de seguridad o pide a alguien que te cuide, sobre todo con cargas altas.',
    easier: 'Press de suelo con mancuernas o flexiones.',
    harder: 'Sube el peso de forma gradual o haz una pausa en el pecho.',
  ),
  'Press inclinado con mancuernas': ExerciseGuide(
    steps: [
      'Ajusta el banco a una inclinación suave, de unos 30–45°, y siéntate con la espalda apoyada.',
      'Sube las mancuernas a la altura del pecho, con las palmas hacia adelante y los codos a unos 45–75° del cuerpo.',
      'Junta los omóplatos y mantén el pecho alto.',
      'Empuja las mancuernas hacia arriba hasta estirar los brazos, sin chocarlas.',
      'Baja con control hasta que las mancuernas queden a la altura del pecho.',
    ],
    cues: [
      'Muñecas rectas y mancuernas sobre los codos.',
      'Omóplatos juntos.',
      'Movimiento controlado.',
    ],
    mistakes: [
      'Inclinar el banco demasiado y convertirlo en un press de hombro.',
      'Abrir demasiado los codos.',
      'Dejar caer las mancuernas.',
    ],
    safety: 'Para sentarte con mancuernas pesadas, apóyalas en los muslos y súbelas con ayuda de las rodillas.',
    easier: 'Press de suelo con mancuernas.',
    harder: 'Más peso o baja en 3 segundos.',
  ),
  'Press de suelo con mancuernas': ExerciseGuide(
    steps: [
      'Acuéstate boca arriba en el suelo con las rodillas dobladas y los pies apoyados, con una mancuerna en cada mano.',
      'Los codos quedan doblados a unos 45–75° del cuerpo, con la parte de atrás del brazo apoyada en el suelo.',
      'Empuja las mancuernas hacia arriba hasta estirar los brazos.',
      'Baja despacio hasta que el brazo toque el suelo, sin dejarlo caer.',
    ],
    cues: [
      'Muñecas rectas, mancuernas sobre los codos.',
      'Haz una pausa breve cuando el brazo toca el suelo.',
      'Abdomen firme, sin arquear la espalda baja.',
    ],
    mistakes: [
      'Abrir los codos a 90° del cuerpo.',
      'Rebotar el brazo contra el suelo.',
      'Arquear la espalda baja.',
    ],
    easier: 'Usa menos peso.',
    harder: 'Más peso, o pasa a un banco con press inclinado.',
  ),
  'Press de pecho con banda': ExerciseGuide(
    steps: [
      'Pasa la banda por detrás de la espalda, por debajo de las axilas, y sujeta los extremos con las manos a la altura del pecho.',
      'Da un paso adelante para crear tensión, con una pierna adelante y la otra atrás.',
      'Empuja las manos al frente hasta estirar los brazos.',
      'Regresa despacio, sin perder la tensión.',
    ],
    cues: [
      'Torso firme, sin inclinarte hacia adelante.',
      'Muñecas rectas.',
      'Controla el regreso.',
    ],
    mistakes: [
      'Dejar que la banda te jale los brazos hacia atrás.',
      'Inclinarte hacia adelante al empujar.',
      'Soltar la tensión de golpe.',
    ],
    safety: 'Revisa que la banda no esté dañada ni agrietada antes de usarla.',
    easier: 'Banda más suave.',
    harder: 'Banda más tensa o más pasos hacia adelante.',
  ),
  'Press militar con mancuernas': ExerciseGuide(
    steps: [
      'De pie, o sentado con la espalda apoyada, sostén una mancuerna en cada mano a la altura de los hombros con las palmas hacia adelante.',
      'Aprieta abdomen y glúteos para no arquear la espalda baja.',
      'Empuja las mancuernas hacia arriba hasta estirar los brazos sobre la cabeza.',
      'Baja con control hasta la altura de las orejas.',
    ],
    cues: [
      'Abdomen firme, costillas hacia abajo.',
      'Antebrazos verticales, con las mancuernas sobre los codos.',
      'Sube en línea recta, sin balancear el cuerpo.',
    ],
    mistakes: [
      'Arquear la espalda baja.',
      'Usar impulso de las piernas.',
      'Dejar los codos muy atrás del cuerpo.',
    ],
    easier: 'Hazlo sentado con respaldo y menos peso.',
    harder: 'De pie con más peso, o con una pausa arriba.',
  ),
  'Elevaciones laterales': ExerciseGuide(
    steps: [
      'De pie, con una mancuerna en cada mano a los lados, las rodillas ligeramente flexionadas y el torso erguido.',
      'Con los codos un poco doblados, sube los brazos hacia los lados.',
      'Sube hasta la altura de los hombros, no más arriba.',
      'Haz una pausa breve y baja despacio.',
    ],
    cues: [
      'Imagina que viertes agua de una jarra: el meñique un poco más alto que el pulgar.',
      'Sube sin balancear el cuerpo.',
      'Usa un peso ligero: aquí manda la técnica.',
    ],
    mistakes: [
      'Usar demasiado peso y balancear el torso.',
      'Subir los hombros hacia las orejas.',
      'Subir los brazos por encima de los hombros.',
    ],
    easier: 'Usa menos peso.',
    harder: 'Haz una pausa de 1–2 segundos arriba.',
  ),
  'Fondos en paralelas': ExerciseGuide(
    steps: [
      'Sujeta las barras paralelas (o las asas de la máquina) con los brazos estirados y el torso ligeramente inclinado hacia adelante; si usas una máquina asistida, ajusta la ayuda a tu nivel.',
      'Baja doblando los codos y manteniéndolos cerca del cuerpo.',
      'Baja hasta unos 90° de codo, o hasta sentir un estiramiento cómodo en el pecho y el hombro, sin forzar.',
      'Empuja hacia arriba hasta estirar los brazos.',
    ],
    cues: [
      'Hombros lejos de las orejas.',
      'Codos cerca del cuerpo para trabajar más el tríceps.',
      'Controla la bajada.',
    ],
    mistakes: [
      'Bajar demasiado y sobrecargar los hombros.',
      'Abrir los codos.',
      'Balancearte con impulso.',
    ],
    safety: 'Si sientes dolor en el hombro, reduce el recorrido o elige otro ejercicio.',
    easier: 'Más ayuda en la máquina, o fondos en silla.',
    harder: 'Menos ayuda, o añade peso.',
  ),
  'Fondos en silla': ExerciseGuide(
    steps: [
      'Siéntate al borde de una silla firme (que no se mueva) y apoya las manos junto a las caderas, con los dedos hacia adelante.',
      'Desliza la cadera fuera del asiento, con las piernas dobladas o estiradas.',
      'Baja el cuerpo doblando los codos hacia atrás, hasta unos 90°.',
      'Empuja con los brazos hasta estirarlos.',
    ],
    cues: [
      'Los codos van hacia atrás, no hacia los lados.',
      'Cadera cerca de la silla.',
      'Hombros lejos de las orejas.',
    ],
    mistakes: [
      'Bajar demasiado y cargar el hombro.',
      'Abrir los codos.',
      'Alejar la cadera de la silla.',
    ],
    safety: 'Comprueba que la silla no se deslice. Si sientes dolor en el hombro, reduce el recorrido.',
    easier: 'Dobla más las rodillas y apoya los pies cerca de la silla.',
    harder: 'Estira las piernas o levanta un pie del suelo.',
  ),
  'Extensión de tríceps en polea': ExerciseGuide(
    steps: [
      'Frente a la polea alta, toma la barra o la cuerda con las manos a la altura del pecho.',
      'Pega los codos a los costados e inclina ligeramente el torso.',
      'Estira los codos hacia abajo hasta extender por completo los brazos.',
      'Aprieta el tríceps abajo durante un instante.',
      'Sube despacio hasta que los codos formen unos 90°.',
    ],
    cues: [
      'Solo se mueven los antebrazos.',
      'Los codos quedan fijos junto al cuerpo.',
      'Controla la subida.',
    ],
    mistakes: [
      'Abrir o mover los codos.',
      'Inclinarte y usar el peso del cuerpo.',
      'Hacer un recorrido incompleto.',
    ],
    easier: 'Extensión de tríceps con banda o menos peso.',
    harder: 'Más peso o baja la subida a 3 segundos.',
  ),
  'Extensión de tríceps por encima de la cabeza': ExerciseGuide(
    steps: [
      'De pie o sentado con la espalda recta, sostén una mancuerna con ambas manos sobre la cabeza, con los brazos estirados.',
      'Mantén los codos apuntando al frente, cerca de la cabeza.',
      'Dobla los codos para bajar la mancuerna por detrás de la cabeza.',
      'Baja hasta sentir un buen estiramiento en el tríceps.',
      'Estira los brazos para volver a subir.',
    ],
    cues: [
      'Solo se mueven los antebrazos.',
      'Abdomen firme para no arquear la espalda baja.',
      'Codos cerrados, sin abrirlos a los lados.',
    ],
    mistakes: [
      'Abrir mucho los codos.',
      'Arquear la espalda baja.',
      'Usar demasiado peso y perder el control.',
    ],
    safety: 'Usa un peso moderado: la mancuerna pasa cerca de tu cabeza.',
    easier: 'Extensión de tríceps con banda.',
    harder: 'Más peso.',
  ),
  'Extensión de tríceps con banda': ExerciseGuide(
    steps: [
      'Ancla la banda en un punto alto y firme, o pisa un extremo y sujeta el otro por encima del hombro.',
      'Pega el codo a la cabeza o al costado, según el anclaje.',
      'Estira el brazo hasta extenderlo por completo.',
      'Vuelve despacio a la posición inicial, sin soltar la tensión.',
    ],
    cues: [
      'El codo se queda fijo; solo se mueve el antebrazo.',
      'Controla el regreso.',
      'Muñeca recta.',
    ],
    mistakes: [
      'Mover el codo para ayudarte.',
      'Soltar la tensión de golpe.',
      'Inclinar el torso para jalar.',
    ],
    safety: 'Revisa que el anclaje sea firme y que la banda no esté dañada.',
    easier: 'Banda más suave.',
    harder: 'Banda más tensa.',
  ),

  // ───────────── Tirón ─────────────
  'Jalón al pecho': ExerciseGuide(
    steps: [
      'Siéntate y ajusta el soporte de los muslos para que te sujete. Toma la barra con un agarre un poco más ancho que los hombros y las palmas hacia adelante.',
      'Inclina el torso ligeramente hacia atrás y saca el pecho.',
      'Jala la barra hacia la parte alta del pecho, llevando los codos hacia abajo y atrás.',
      'Aprieta los omóplatos al final.',
      'Sube la barra de forma controlada hasta estirar los brazos, sin que el peso te levante del asiento.',
    ],
    cues: [
      'Piensa en llevar los codos hacia los bolsillos de atrás, no en jalar con las manos.',
      'Pecho alto y hombros lejos de las orejas.',
      'Controla el regreso.',
    ],
    mistakes: [
      'Jalar la barra por detrás de la nuca.',
      'Balancear el torso con impulso.',
      'Encoger los hombros al jalar.',
    ],
    easier: 'Jalón con banda, o menos peso.',
    harder: 'Más peso, o pasa a las dominadas asistidas.',
  ),
  'Jalón con banda': ExerciseGuide(
    steps: [
      'Ancla la banda en un punto alto y firme (por ejemplo, con un ancla de puerta segura).',
      'Arrodíllate o siéntate frente al ancla y toma la banda con las manos más abiertas que los hombros.',
      'Jala la banda hacia el pecho, llevando los codos hacia abajo y atrás.',
      'Aprieta los omóplatos abajo.',
      'Sube las manos despacio, sin soltar la tensión.',
    ],
    cues: [
      'Los codos van hacia abajo y atrás.',
      'Pecho alto, hombros abajo.',
      'Controla el regreso.',
    ],
    mistakes: [
      'Encoger los hombros.',
      'Inclinarte hacia atrás para ayudarte.',
      'Soltar la banda de golpe.',
    ],
    safety: 'Comprueba que el anclaje sea firme antes de jalar y que la banda no esté dañada.',
    easier: 'Banda más suave.',
    harder: 'Banda más tensa o pausa de 2 segundos abajo.',
  ),
  'Dominadas asistidas': ExerciseGuide(
    steps: [
      'Elige la ayuda en la máquina: más contrapeso es más fácil.',
      'Sube a la plataforma y sujeta las asas con un agarre un poco más ancho que los hombros.',
      'Baja los hombros y jala llevando el pecho hacia las asas.',
      'Sube hasta que la barbilla pase la altura de las manos.',
      'Baja despacio hasta estirar los brazos.',
    ],
    cues: [
      'Empieza bajando los hombros y luego jala con los codos.',
      'Cuerpo firme, sin balancearte.',
      'Baja en 2–3 segundos.',
    ],
    mistakes: [
      'Usar impulso con las piernas o el cuerpo.',
      'Hacer solo medio recorrido.',
      'Encoger los hombros.',
    ],
    easier: 'Más ayuda, o jalón al pecho.',
    harder: 'Menos ayuda hasta llegar a dominadas libres.',
  ),
  'Dominadas': ExerciseGuide(
    steps: [
      'Cuélgate de la barra con las manos un poco más abiertas que los hombros y las palmas hacia adelante.',
      'Baja los hombros lejos de las orejas y aprieta el abdomen.',
      'Jala llevando los codos hacia abajo hasta que la barbilla supere la barra.',
      'Baja de forma controlada hasta estirar los brazos.',
    ],
    cues: [
      'Empieza el movimiento bajando los hombros.',
      'Cuerpo firme, sin balancearte.',
      'Baja con control, en unos 2–3 segundos.',
    ],
    mistakes: [
      'Balancearte para ganar impulso.',
      'Hacer solo medio recorrido.',
      'Encoger los hombros hacia las orejas.',
    ],
    easier: 'Dominadas asistidas o jalón con banda.',
    harder: 'Añade peso o baja en 4 segundos.',
  ),
  'Remo sentado en polea': ExerciseGuide(
    steps: [
      'Siéntate con los pies apoyados en la plataforma, las rodillas ligeramente flexionadas y la espalda recta.',
      'Toma el agarre con los brazos estirados y el pecho alto.',
      'Jala el agarre hacia el abdomen, llevando los codos hacia atrás y cerca del cuerpo.',
      'Junta los omóplatos al final y haz una pausa breve.',
      'Estira los brazos de forma controlada, sin redondear la espalda.',
    ],
    cues: [
      'Torso casi inmóvil: la espalda hace el trabajo.',
      'Pecho alto y hombros abajo.',
      'Codos pegados al cuerpo.',
    ],
    mistakes: [
      'Balancear el torso hacia atrás y hacia adelante.',
      'Encoger los hombros.',
      'Redondear la espalda al estirar los brazos.',
    ],
    easier: 'Remo con banda.',
    harder: 'Más peso, o una pausa de 2 segundos con los omóplatos juntos.',
  ),
  'Remo con mancuerna': ExerciseGuide(
    steps: [
      'Apoya la mano y la rodilla del mismo lado en un banco o una silla firme; el otro pie queda en el suelo.',
      'Mantén la espalda recta y paralela al suelo, con la mancuerna colgando bajo el hombro.',
      'Jala la mancuerna hacia la cadera, llevando el codo hacia atrás y arriba, cerca del cuerpo.',
      'Aprieta la espalda arriba durante un instante.',
      'Baja despacio hasta estirar el brazo. Al terminar las repeticiones, cambia de lado.',
    ],
    cues: [
      'Imagina que guardas la mancuerna en el bolsillo de atrás.',
      'El tronco se queda quieto, sin girar.',
      'Hombro lejos de la oreja.',
    ],
    mistakes: [
      'Girar el torso para subir la mancuerna.',
      'Jalar con el bíceps en vez de con la espalda.',
      'Redondear la espalda.',
    ],
    safety: 'Usa un banco o una silla estable.',
    easier: 'Remo con banda, o menos peso.',
    harder: 'Más peso o una pausa arriba.',
  ),
  'Remo con banda': ExerciseGuide(
    steps: [
      'Siéntate en el suelo con las piernas estiradas y pasa la banda por las plantas de los pies; toma los extremos con las manos.',
      'Mantén la espalda recta y el pecho alto.',
      'Jala las manos hacia el abdomen, llevando los codos hacia atrás.',
      'Junta los omóplatos y haz una pausa breve.',
      'Regresa despacio, sin soltar la tensión.',
    ],
    cues: [
      'Espalda recta durante todo el movimiento.',
      'Codos cerca del cuerpo.',
      'Controla el regreso.',
    ],
    mistakes: [
      'Redondear la espalda.',
      'Encoger los hombros.',
      'Inclinar el torso hacia atrás para jalar.',
    ],
    safety: 'Revisa que la banda no esté dañada ni agrietada antes de usarla.',
    easier: 'Banda más suave.',
    harder: 'Banda más tensa o pausa de 2 segundos al juntar los omóplatos.',
  ),
  'Remo invertido bajo mesa': ExerciseGuide(
    steps: [
      'Acuéstate debajo de una mesa resistente y estable y sujeta el borde con ambas manos, un poco más abiertas que los hombros.',
      'Con los talones apoyados, estira el cuerpo en línea recta con los brazos estirados.',
      'Jala el pecho hacia el borde de la mesa juntando los omóplatos.',
      'Baja despacio hasta estirar los brazos.',
    ],
    cues: [
      'Cuerpo recto de la cabeza a los talones.',
      'Codos hacia atrás y cerca del cuerpo.',
      'Junta los omóplatos arriba.',
    ],
    mistakes: [
      'Dejar caer la cadera.',
      'Jalar solo con los brazos.',
      'Usar una mesa inestable.',
    ],
    safety: 'Usa una mesa pesada y resistente que no se mueva ni se rompa. Prueba primero con poco esfuerzo.',
    easier: 'Dobla las rodillas y apoya los pies cerca del cuerpo.',
    harder: 'Estira las piernas o elévalas sobre una silla.',
  ),
  'Face pull': ExerciseGuide(
    steps: [
      'Coloca la polea a la altura de la cara y toma la cuerda con las palmas hacia ti.',
      'Da un paso atrás con los brazos estirados y las rodillas ligeramente flexionadas.',
      'Jala la cuerda hacia la cara, separando las manos y llevando los codos hacia afuera y atrás.',
      'Termina con las manos a los lados de la cara y los omóplatos juntos.',
      'Regresa despacio.',
    ],
    cues: [
      'Codos altos, a la altura de los hombros o un poco más.',
      'Peso ligero y movimiento limpio.',
      'Pecho alto, sin arquear la espalda.',
    ],
    mistakes: [
      'Usar demasiado peso y echar el cuerpo hacia atrás.',
      'Jalar con los codos bajos.',
      'Encoger los hombros.',
    ],
    easier: 'Face pull con banda.',
    harder: 'Haz una pausa de 1–2 segundos al final.',
  ),
  'Face pull con banda': ExerciseGuide(
    steps: [
      'Ancla la banda a la altura de la cara y toma un extremo con cada mano, con las palmas hacia abajo o hacia adentro.',
      'Da un paso atrás con los brazos estirados para crear tensión.',
      'Jala las manos hacia la cara, separándolas y llevando los codos hacia afuera y atrás.',
      'Junta los omóplatos al final.',
      'Regresa despacio.',
    ],
    cues: [
      'Codos altos.',
      'Pecho alto, sin arquear la espalda.',
      'Controla el regreso.',
    ],
    mistakes: [
      'Jalar con los codos bajos.',
      'Echar el cuerpo hacia atrás.',
      'Encoger los hombros.',
    ],
    safety: 'Comprueba que el anclaje sea firme y que la banda no esté dañada.',
    easier: 'Banda más suave.',
    harder: 'Banda más tensa o pausa de 2 segundos al final.',
  ),
  'Curl de bíceps': ExerciseGuide(
    steps: [
      'De pie, con una mancuerna en cada mano, los brazos estirados a los lados y las palmas hacia adelante.',
      'Pega los codos a las costillas.',
      'Dobla los codos y sube las mancuernas hacia los hombros.',
      'Aprieta el bíceps arriba.',
      'Baja despacio hasta estirar el brazo por completo.',
    ],
    cues: [
      'Codos fijos junto al cuerpo.',
      'Sin balancear el torso.',
      'Baja en 2–3 segundos.',
    ],
    mistakes: [
      'Balancear el cuerpo para subir el peso.',
      'Mover los codos hacia adelante.',
      'No estirar del todo el brazo abajo.',
    ],
    easier: 'Curl con banda, o menos peso.',
    harder: 'Más peso, o baja en 3–4 segundos.',
  ),
  'Curl martillo': ExerciseGuide(
    steps: [
      'De pie, con una mancuerna en cada mano a los lados y las palmas mirando hacia el cuerpo.',
      'Pega los codos a las costillas.',
      'Dobla los codos y sube las mancuernas hacia los hombros, manteniendo las palmas enfrentadas.',
      'Aprieta arriba y baja despacio hasta estirar el brazo.',
    ],
    cues: [
      'Las palmas se mantienen mirando hacia adentro todo el recorrido.',
      'Codos fijos junto al cuerpo.',
      'Sin balancear el torso.',
    ],
    mistakes: [
      'Balancear el cuerpo para subir el peso.',
      'Mover los codos hacia adelante.',
      'Girar las muñecas durante el movimiento.',
    ],
    easier: 'Usa menos peso.',
    harder: 'Más peso, o baja en 3–4 segundos.',
  ),
  'Curl de bíceps con banda': ExerciseGuide(
    steps: [
      'Pisa el centro de la banda con ambos pies y toma los extremos con las manos, con las palmas hacia adelante.',
      'Pega los codos a las costillas.',
      'Dobla los codos y sube las manos hacia los hombros.',
      'Aprieta el bíceps arriba.',
      'Baja despacio sin soltar la tensión.',
    ],
    cues: [
      'Codos fijos junto al cuerpo.',
      'Sin balancear el torso.',
      'Controla el regreso.',
    ],
    mistakes: [
      'Balancear el cuerpo para subir.',
      'Mover los codos hacia adelante.',
      'Soltar la banda de golpe.',
    ],
    safety: 'Revisa que la banda no esté dañada y que tus pies estén bien apoyados sobre ella.',
    easier: 'Banda más suave.',
    harder: 'Banda más tensa, o pisa más lejos para aumentar la tensión.',
  ),

  // ───────────── Core ─────────────
  'Plancha': ExerciseGuide(
    steps: [
      'Apoya los antebrazos en el suelo con los codos justo debajo de los hombros y las puntas de los pies apoyadas.',
      'Eleva el cuerpo formando una línea recta de la cabeza a los talones.',
      'Aprieta abdomen y glúteos, y mantén el cuello neutro mirando al suelo.',
      'Respira con normalidad y sostén la posición el tiempo indicado.',
    ],
    cues: [
      'Cuerpo en línea recta.',
      'Abdomen y glúteos firmes.',
      'Respira, no aguantes el aire.',
    ],
    mistakes: [
      'Dejar caer la cadera.',
      'Subir demasiado la cadera.',
      'Aguantar la respiración.',
    ],
    easier: 'Plancha con las rodillas apoyadas, o con las manos sobre un sofá.',
    harder: 'Más tiempo, o levanta un pie del suelo.',
    breathing: 'Respira de forma lenta y continua; no aguantes el aire.',
  ),
  'Plancha lateral': ExerciseGuide(
    steps: [
      'Acuéstate de lado y apoya el antebrazo en el suelo con el codo bajo el hombro.',
      'Apila los pies, o coloca uno delante del otro.',
      'Eleva la cadera hasta que el cuerpo forme una línea recta de la cabeza a los pies.',
      'Mantén la posición respirando con normalidad. Después cambia de lado.',
    ],
    cues: [
      'Cuerpo en línea recta.',
      'Hombro sobre el codo.',
      'Respira, no aguantes el aire.',
    ],
    mistakes: [
      'Dejar caer la cadera.',
      'Girar el pecho hacia el suelo o hacia el techo.',
      'Aguantar la respiración.',
    ],
    easier: 'Apoya las rodillas en el suelo.',
    harder: 'Levanta el brazo o la pierna de arriba.',
    breathing: 'Respira de forma lenta y continua; no aguantes el aire.',
  ),
  'Dead bug': ExerciseGuide(
    steps: [
      'Acuéstate boca arriba con los brazos estirados hacia el techo y las rodillas dobladas a 90° sobre la cadera.',
      'Pega la espalda baja al suelo apretando el abdomen.',
      'Baja a la vez el brazo derecho y la pierna izquierda, sin que la espalda baja se despegue.',
      'Regresa al inicio y repite con el brazo izquierdo y la pierna derecha.',
    ],
    cues: [
      'La espalda baja siempre pegada al suelo.',
      'Movimiento lento.',
      'Exhala al estirar.',
    ],
    mistakes: [
      'Arquear la espalda baja.',
      'Moverte demasiado rápido.',
      'Aguantar la respiración.',
    ],
    easier: 'Mueve solo las piernas o solo los brazos.',
    harder: 'Sostén una mancuerna ligera o muévete más lento.',
    breathing: 'Exhala al estirar el brazo y la pierna; inhala al regresar.',
  ),
  'Bird dog': ExerciseGuide(
    steps: [
      'Colócate en cuadrupedia: manos bajo los hombros y rodillas bajo la cadera.',
      'Mantén la espalda neutra y el abdomen firme.',
      'Estira a la vez el brazo derecho hacia adelante y la pierna izquierda hacia atrás.',
      'Forma una línea desde la mano hasta el pie, sin girar la cadera.',
      'Haz una pausa de un segundo, regresa con control y cambia de lado.',
    ],
    cues: [
      'Cadera cuadrada al suelo, sin girar.',
      'Movimiento lento.',
      'Cuello neutro, mirando al suelo.',
    ],
    mistakes: [
      'Arquear la espalda baja al levantar la pierna.',
      'Girar la cadera.',
      'Moverte con impulso.',
    ],
    easier: 'Mueve solo un brazo o solo una pierna a la vez.',
    harder: 'Haz una pausa de 3–5 segundos arriba.',
    breathing: 'Exhala al estirar y inhala al regresar.',
  ),
  'Crunch abdominal': ExerciseGuide(
    steps: [
      'Acuéstate boca arriba con las rodillas dobladas y los pies apoyados.',
      'Pon las manos junto a las sienes o cruzadas sobre el pecho, sin jalar el cuello.',
      'Exhala y despega los hombros del suelo curvando el abdomen.',
      'Haz una pausa breve arriba.',
      'Baja despacio sin soltar el abdomen.',
    ],
    cues: [
      'El movimiento es corto: solo sube la parte alta de la espalda.',
      'Mira al techo, con la barbilla alejada del pecho.',
      'Exhala al subir.',
    ],
    mistakes: [
      'Jalar el cuello con las manos.',
      'Subir con impulso.',
      'Subir todo el torso.',
    ],
    easier: 'Haz el movimiento con menos recorrido.',
    harder: 'Haz una pausa de 2 segundos arriba.',
  ),
  'Pallof press': ExerciseGuide(
    steps: [
      'Ancla la banda a un punto firme a la altura del pecho y colócate de lado, a un paso de distancia.',
      'Sujeta la banda con ambas manos junto al pecho, con los pies a la anchura de los hombros y las rodillas ligeramente dobladas.',
      'Estira los brazos al frente sin dejar que la banda te gire el torso.',
      'Haz una pausa de 1–2 segundos.',
      'Regresa las manos al pecho con control. Al terminar las repeticiones, cambia de lado.',
    ],
    cues: [
      'Torso y cadera de frente, resistiendo el giro.',
      'Abdomen firme.',
      'Respira con normalidad.',
    ],
    mistakes: [
      'Dejar que la banda te gire el cuerpo.',
      'Inclinarte hacia un lado.',
      'Ir con impulso.',
    ],
    safety: 'Comprueba que el anclaje sea firme y que la banda no esté dañada.',
    easier: 'Usa una banda más suave o acércate al ancla.',
    harder: 'Usa una banda más tensa o aléjate del ancla.',
    breathing: 'Exhala al estirar los brazos y inhala al regresar.',
  ),
  'Superman': ExerciseGuide(
    steps: [
      'Acuéstate boca abajo con los brazos estirados al frente y las piernas rectas.',
      'Mira al suelo, con el cuello neutro.',
      'Levanta a la vez brazos, pecho y piernas unos centímetros, apretando glúteos y espalda baja.',
      'Haz una pausa de 1–2 segundos arriba.',
      'Baja con control.',
    ],
    cues: [
      'Sube poco: no hace falta ir alto.',
      'Cuello neutro.',
      'Aprieta los glúteos.',
    ],
    mistakes: [
      'Levantar la cabeza y forzar el cuello.',
      'Subir demasiado y arquear la espalda baja.',
      'Ir con impulso.',
    ],
    easier: 'Levanta solo los brazos o solo las piernas.',
    harder: 'Haz una pausa más larga arriba.',
    breathing: 'Exhala al subir e inhala al bajar.',
  ),

  // ───────────── Cardio y cuerpo completo ─────────────
  'Mountain climbers': ExerciseGuide(
    steps: [
      'Colócate en posición de flexión, con las manos bajo los hombros y el cuerpo en línea recta.',
      'Mantén el abdomen firme.',
      'Lleva una rodilla hacia el pecho.',
      'Cambia de pierna a buen ritmo, como si corrieras en el sitio.',
      'Mantén la cadera baja y estable.',
    ],
    cues: [
      'Hombros sobre las manos.',
      'Cadera a la altura de la espalda, sin subirla.',
      'Ritmo constante.',
    ],
    mistakes: [
      'Subir la cadera.',
      'Dejar caer la espalda baja.',
      'Perder la forma por ir demasiado rápido.',
    ],
    easier: 'Hazlo más lento, o con las manos sobre una silla o un sofá.',
    harder: 'Ve más rápido o durante más tiempo.',
    breathing: 'Respira de forma continua y rítmica.',
  ),
  'Burpee': ExerciseGuide(
    steps: [
      'De pie, con los pies a la anchura de los hombros.',
      'Agáchate y apoya las manos en el suelo frente a ti.',
      'Lleva los pies hacia atrás hasta quedar en posición de flexión.',
      'Opcional: haz una flexión.',
      'Regresa los pies hacia las manos y salta hacia arriba extendiendo el cuerpo.',
    ],
    cues: [
      'Abdomen firme al llevar los pies hacia atrás.',
      'Aterriza suave, con las rodillas flexionadas.',
      'Ritmo constante.',
    ],
    mistakes: [
      'Dejar caer la cadera en la posición de flexión.',
      'Aterrizar con las piernas rígidas.',
      'Ir tan rápido que se pierde la técnica.',
    ],
    easier: 'Sin salto, caminando con los pies hacia atrás y hacia adelante.',
    harder: 'Con flexión completa y salto alto.',
    breathing: 'Respira de forma continua; exhala al saltar.',
  ),
  'Jumping jacks': ExerciseGuide(
    steps: [
      'De pie, con los pies juntos y los brazos a los lados.',
      'Salta abriendo las piernas hacia los lados y sube los brazos por encima de la cabeza.',
      'Salta de nuevo cerrando las piernas y bajando los brazos.',
      'Repite a un ritmo constante.',
    ],
    cues: [
      'Aterriza suave, sobre la parte delantera del pie.',
      'Rodillas ligeramente flexionadas.',
      'Respira de forma continua.',
    ],
    mistakes: [
      'Aterrizar con las piernas rígidas.',
      'Ir tan rápido que pierdes el ritmo.',
      'Encoger los hombros.',
    ],
    easier: 'Versión sin salto: da pasos laterales y sube los brazos.',
    harder: 'Ve más rápido o durante más tiempo.',
    breathing: 'Respira de forma continua y rítmica.',
  ),
  'Farmer walk': ExerciseGuide(
    steps: [
      'Toma una mancuerna pesada en cada mano y ponte de pie, con la espalda recta y los hombros hacia atrás y abajo.',
      'Camina con pasos cortos y controlados.',
      'Mantén el torso erguido, el abdomen firme y la mirada al frente.',
      'Recorre la distancia o el tiempo indicado y deja las mancuernas en el suelo con control.',
    ],
    cues: [
      'Hombros abajo, sin encogerlos.',
      'No te inclines hacia un lado.',
      'Respira con normalidad.',
    ],
    mistakes: [
      'Inclinarte hacia un lado.',
      'Encoger los hombros.',
      'Dar pasos largos y descontrolados.',
    ],
    safety: 'Deja las mancuernas en el suelo doblando cadera y rodillas, con la espalda recta.',
    easier: 'Usa menos peso.',
    harder: 'Más peso o más distancia.',
    breathing: 'Respira de forma lenta y continua mientras caminas.',
  ),
};

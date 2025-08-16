musico(luis, guitarra).
musico(luis, bajo).
musico(ana, voz).
musico(ana, teclado).
musico(juan, bateria).
musico(maria, voz).
musico(maria, guitarra).
instrumentosRequeridosParaBandaDe(rock, [guitarra, bateria, bajo, voz]).
instrumentosRequeridosParaBandaDe(jazz, [teclado, saxo, contrabajo, bateria]).


bandaPosible(Musicos, Genero):-  
  instrumentosRequeridosParaBandaDe(Genero, InstrumentosRequeridos),  
  findall(Instrumento,
    instrumentoDeAlgunMusico(Musicos, Instrumento), 
    InstrumentosDisponibles),  
  cubreTodos(InstrumentosRequeridos, InstrumentosDisponibles). 

instrumentoDeAlgunMusico(Musicos, Instrumento):-  
  member(Musico, Musicos), 
  musico(Musico, Instrumento). 

cubreTodos(InstrumentosRequeridos, InstrumentosDisponibles):-  
  forall(member(Instrumento, InstrumentosRequeridos), 
   member(Instrumento, InstrumentosDisponibles)). 


% Nueva solucion propuesta

bandaPosible2(G, B):-  
  	instrumentosRequeridosParaBandaDe(B, I),  
  	forall(instrumentoDeAlgunMusico(G, II),member(II,I)).

% Version arreglada

bandaPosible3(Grupo, Genero):-  
    instrumentosRequeridosParaBandaDe(Genero, InstrumentosRequeridos),  
    forall(member(Instrumento, InstrumentosRequeridos), 
        instrumentoDeAlgunMusico(Grupo, Instrumento)).

% Respuestas teoricas

%Es correcta?
% La nueva solucion propuesta (bandaPosible2) no es correcta porque 
% el forall checkea que todos los instrumentos que la banda sabe tocar
% pertenecen a los instrumentos requeridos para tocar el genero.
% Eso es incorrecto porque deberia ser al revez, que todos los instrumentos
% requeridos pertenezcan a los instrumentos que sabe tocar la banda.

%Es más expresiva?
% No tiene sentido comparar la expresividad bandaPosible2 con la de bandaPosible porque
% no resuelven el mismo problema. Igualmente, podemos decir que bandaPosible2 puede ser mas
% expresiva si le ponemos mejores nombres a las variables.
% Podemos comparar la expresividad de bandaPosible3 y bandaPosible, ya que resuelven el mismo problema.
% bandaPosible3 es mas expresiva porque resuelve el problema de una forma mas simple, por lo tanto
% mas simple de entender. 

%Es más declarativa?
% Tampoco tiene sentido comparar la declaratividad bandaPosible2 con la de bandaPosible.
% bandaPosible3 es mas declarativa que bandaPosible porque el codigo de la solución es 
% mucho mas cercano a como esta planteada la formulacion del problema.
% Lo que quiere decir esto es que cuando yo leo el codigo de bandaPosible3, lo que leo es
% "Una banda es posible para un genero cuando para todos los instrumentos requeridos
% para tocar el genero, algun miembro del grupo puede tocarlo". 
% La lectura del codigo ya es casi identica a lo que dice el enunciado. 
% En comparacion, la forma de leer el codigo de bandaPosible es:
% "Una banda es posible para un genero cuando, teniendo los instrumentos requeridos
% para tocar el genero y, calculando todos los instrumentos que la banda puede tocar,
% se valida que para todo instrumento requerido, ese instrumento pertenece a la lista de 
% instrumentos que la banda puede tocar".
% Esta lectura es mas lejana a como está planteado problema en el enunciado, porque incluye
% detalles implementativos/algoritmicos que no hacen al enunciado del problema. Por esto, decimos
% que esta solucion es menos declarativa.
% Para mas teoria sobre declaratividad: 
% https://wiki.uqbar.org/wiki/articles/declaratividad.html
% https://wiki.uqbar.org/wiki/articles/declaratividad-vs--expresividad.html

% Mostrar ejemplos de consulta y respuesta que muestren qué tan inversibles son ambas soluciones.

% bandaPosible(Quienes, rock);
% Esta consulta no es inversible porque no se está ligando la variable 'Musicos'. Esto tambien pasa 
% en bandaPosible3.


% consulta: bandaPosible([maria, juan, luis], Genero)
% respuesta: Genero=rock
% Por lo tanto, es inversible por el segundo argumento.
% Esto mismo pasa con bandaPosible3


%%%%%%%%%%%%%% supermerk2

marca(cindor, laSerenisima).
marca(latuna, nereida).
marca(serenito, laSerenisima).
cliente(Cliente):-
    compro(Cliente, _).
compro(martina, latuna).
compro(martina, cindor).
compro(aye, cindor).
compro(aye, serenito).


obsesivo1(Cliente):- 
    cliente(Cliente),
    forall(compro(Cliente,Producto), marca(Producto, Marca)).
% El problema es que el forall es "Para todo producto que compro el cliente, el producto tiene marca "
% lo cual no es lo que pide el enunciado.

obsesivo2(Cliente):- 
    marca(_, Marca),
    forall(compro(Cliente, Producto), marca(Producto, Marca)).
% El "problema" es que no es inversible. No es realmente un problema que no sea inversible
% pero usualmente queremos que los predicados importante del codigo sean inversibles.

obsesivo3(Cliente):- 
    marca(Producto, _), 
    forall(compro(Cliente, Producto), marca(Producto, Marca)).
% El problema es que se está ligando Producto antes del forall, por lo que el forall no 
% tiene el efecto de "iterar" sobre todos los productos del cliente.

% Version con not:
obsesivo4(Cliente):-
    cliente(Cliente),
    not(comproProductosDeDistintaMarca(Cliente)).

comproProductosDeDistintaMarca(Cliente):-
    comproDeMarca(Cliente, Marca1),
    comproDeMarca(Cliente, Marca2),
    Marca1 \= Marca2.

comproDeMarca(Cliente, Marca):-
    compro(Cliente, Producto),
    marca(Producto, Marca).




%%%%%% trenes y aviones


noEsSustentable(Persona):-
  findall(A, (viaja(Persona, avion(A,_,internacional))), Aviones),
  findall(T, viaja(Persona, tren(T,_)), Trenes),
  findall(V, viaja(Persona, V), Todos),
  length(Aviones, CAviones),
  length(Trenes, CTrenes),
  length(Todos, CTodos),
  CTodos is CAviones + CTrenes.

% Este predicado verifica que todos los viajes de la persona hayan sido vuelos internacionales o trenes.

% La solución planteada es poco declarativa?
% La solucion es poco declarativa comparada a la solucion superadora. La justificacion
% es la misma que la justificacion de la declaratividad los predicados de banda posible.

% La solución planteada utiliza polimorfismo?
% No utiliza polimorfismo, usa functores que no es lo mismo. Para que haya polimorfismo
% tiene que haber algun predicado que tenga algun argumento que sea un functor que pueda
% ser de distintos tipos. En el ejemplo de la solucion mejorada de abajo, el predicado
% que usa polimorficamente a los viajes es esNoSustentable.


viaja(lola, avion(latam, 180, internacional)).
viaja(lola, bicicleta(urbana)).
viaja(fran, tren(retiroRosario, 90)).
viaja(fran, avion(aerolineas, 90, domestico)).
viaja(fran, tren(cabaLujan, 70)).
viaja(lucia, avion(united, 300, internacional)).

noEsSustentable2(Persona):-
    viaja(Persona, _),
    forall(viaja(Persona, Viaje), esNoSustentable(Viaje)). % Aca al hacer "esNoSustentable(Viaje)" uso polimorficamente a los viajes.

esNoSustentable(avion(_, _, internacional)). 
esNoSustentable(tren(_,_)).




%%%%% Parcial 31 minutos

% Cancion, Compositores,  Reproducciones
cancion(bailanSinCesar, [pabloIlabaca, rodrigoSalinas], 10600177).
cancion(yoOpino, [alvaroDiaz, carlosEspinoza, rodrigoSalinas], 5209110).
cancion(equilibrioEspiritual, [danielCastro, alvaroDiaz, pabloIlabaca, pedroPeirano, rodrigoSalinas], 12052254).
cancion(tangananicaTanganana, [danielCastro, pabloIlabaca, pedroPeirano], 5516191).
cancion(dienteBlanco, [danielCastro, pabloIlabaca, pedroPeirano], 5872927). 

cancion(lala, [pabloIlabaca, pedroPeirano], 5100530).

cancion(meCortaronMalElPelo, [danielCastro, alvaroDiaz, pabloIlabaca, rodrigoSalinas], 3428854).


% Mes, Puesto, Cancion
rankingTop3(febrero, 1, lala).
rankingTop3(febrero, 2, tangananicaTanganana).
rankingTop3(febrero, 3, meCortaronMalElPelo).
rankingTop3(marzo, 1, meCortaronMalElPelo).
rankingTop3(marzo, 2, tangananicaTanganana).
rankingTop3(marzo, 3, lala).
rankingTop3(abril, 1, tangananicaTanganana).
rankingTop3(abril, 2, dienteBlanco).
rankingTop3(abril, 3, equilibrioEspiritual).
rankingTop3(mayo, 1, meCortaronMalElPelo).
rankingTop3(mayo, 2, dienteBlanco).
rankingTop3(mayo, 3, equilibrioEspiritual).
rankingTop3(junio, 1, dienteBlanco).
rankingTop3(junio, 2, tangananicaTanganana).
rankingTop3(junio, 3, lala).


esHit(Cancion):-
    cancion(Cancion, _, _),
    forall(rankingTop3(Mes, _,_), rankingTop3(Mes, _, Cancion)).

noEsReconocida(Cancion):-
    tieneMuchasReproducciones(Cancion),
    nuncaEstuvoEnRanking(Cancion).

tieneMuchasReproducciones(Cancion):-
    cancion(Cancion, _, Reproducciones),
    Reproducciones > 7000000.

nuncaEstuvoEnRanking(Cancion):-
    not(rankingTop3(_, _, Cancion)).

sonColaboradores(Compositor1, Compositor2):-
    cancion(_, Compositores, _),
    member(Compositor1, Compositores),
    member(Compositor2, Compositores),
    Compositor1 \= Compositor2. % No hace falta, pero permite evitar que compositor1 sea igual compositor2

% otra forma de hacerlo
sonColaboradores2(Compositor1, Compositor2):-
    compusoCancion(Compositor1, Cancion),
    compusoCancion(Compositor2, Cancion).
    % aca no hago el checkeo de Compositor1 \= Compositor2 porque el enunciado no lo pide.

compusoCancion(Compositor, Cancion):-
    cancion(Cancion, Compositores, _),
    member(Compositor, Compositores).


trabajador(tulio, conductor(5)).
trabajador(bodoque, periodista(2, licenciatura)).
trabajador(bodoque, reportero(5, 300)).
trabajador(marioHugo, periodista(10, posgrado)).
trabajador(juanin, conductor(0)).
trabajador(pepita, camara). % agregado por el ultimo punto. Notar como este individuo es un atomo (no es un un functor), pero puede convivir con los otros functores.


sueldoTotal(Persona, SueldoTotal):-
    trabajador(Persona, _),
    findall(Sueldo, sueldo(Persona, Sueldo), Sueldos),
    sum_list(Sueldos, SueldoTotal).

sueldo(Persona, Sueldo):-
    trabajador(Persona, Trabajo),
    sueldoDeTrabajo(Trabajo, Sueldo). % sueldoDeTrabajo es un predicado que usa polimorficamente los trabajos.

sueldoDeTrabajo(conductor(Anios), Sueldo):-
    Sueldo is Anios * 10000.

sueldoDeTrabajo(camara, 1000). % agregado por el ultimo punto. Aunque no sea un functor, puedo usarlo igual en este predicado.

sueldoDeTrabajo(reportero(Anios, Notas), Sueldo):-
    Sueldo is Anios * 10100 + Notas * 100.

sueldoDeTrabajo(periodista(Anios, Titulo), Sueldo):-
    incrementoPorTitulo(Titulo, Incremento), 
    Sueldo is 5000 * Anios * Incremento.

incrementoPorTitulo(licenciatura, 1.2).
incrementoPorTitulo(posgrado, 1.35).



% no hacer esto, repite logica!
sueldoDeTrabajoQueRepiteLogica(periodista(Anios, licenciatura), Sueldo):-
    Sueldo is 5000 * Anios * 1,2.

sueldoDeTrabajoQueRepiteLogica(periodista(Anios, posgrado), Sueldo):-
    Sueldo is 5000 * Anios * 3,5.


% Respuesta teorica del punto 6:
% El concepto es polimorfismo, porque gracias a eso pude agregar un nuevo tipo de trabajo (camara)
% simplemente agregando un nuevo caso del predicado "sueldoDeTrabajo". En soluciones no polimorficas
% agregar un nuevo trabajo seria mas complejo e implicaria modificar reglas ya existentes. En este caso,
% no tuve que modificar nada, solo agregue codigo, lo cual es mas simple que modificar codigo ya existente.
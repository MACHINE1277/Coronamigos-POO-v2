#Trabajo Final
#Grupo: Coronamigos
#Andres Inope

class Alumno
	attr_accessor :dni, :nombre, :apellido, :edad, :genero, :CS, :RE, :EC
	def initialize(dni, nombre, apellido, edad, genero)
  	@dni, @nombre, @apellido, @edad, @genero = dni, nombre, apellido, edad, genero
    @listaTutores = Array.new(2)
    @CS = 0
    @RE = 0
    @EC = 0
  end
end

class AlumnoNacional < Alumno
	attr_accessor :tipo, :promedio2do
  def initialize(dni, nombre, apellido, edad, genero, tipo, promedio2do)
 		super(dni, nombre, apellido, edad, genero)
 		@colegio = "NACIONAL"
 		@tipo = tipo.upcase
 		@promedio2do = promedio2do
 	end

 	def calificarSocioEconomica
 		if tipo == "RURAL"
 			return 100
		elsif tipo == "URBANA"
 			return 100
 		else
 			return 0
 		end
 	end

 	def calificarRendimiento
 		if promedio2do < 11
 			return 0
		elsif promedio2do < 14
 			return 20
		elsif promedio2do < 16
 			return 40
		elsif promedio2do < 18
 			return 60
		elsif promedio2do < 19
 			return 80
 		else
 			return 100
 		end
 	end
end

class AlumnoParticular < Alumno
	attr_accessor :pension, :puesto2do
 	def initialize(dni, nombre, apellido, edad, genero, pension, puesto2do)
 		super(dni, nombre, apellido, edad, genero)
 		@colegio = "PARTICULAR"
 		@pension = pension
 		@puesto2do = puesto2do
 	end

 	def calificarSocioEconomica
 		if pension <= 200
 			return 90
  	elsif pension <= 400
  		return 70
		elsif pension <= 600
 			return 50
 		else
 			return 40
 		end
 	end

 	def calificarRendimiento
 		if puesto2do < 4
 			return 100
		elsif puesto2do < 6
 			return 80
		elsif puesto2do < 11
 			return 60
		elsif puesto2do < 21
 			return 40
 		else
 			return 0
 		end
 	end
end

class Tutor
	attr_accessor :dniAlumno, :dni, :nombre, :apellido, :parentesco
	def initialize(dniAlumno, dni, nombre, apellido, parentesco)
		@dniAlumno, @dni, @nombre, @apellido, @parentesco = dniAlumno, dni, nombre, apellido, parentesco
	end

  def registrarTutor(alumno)
    return nil
  end
end

class Examen
	attr_accessor :codigoEvaluacion, :numeroPregunta, :listaRespuestasAlumno, :listaRespuestasCorrectas
	def initialize(codigoEvaluacion, numeroPregunta)
		@codigoEvaluacion, @numeroPregunta = codigoEvaluacion, numeroPregunta
    @listaRespuestasAlumno = Array.new(numeroPregunta)
    @listaRespuestasCorrectas = Array.new(numeroPregunta)
	end

  def simularResultados(examen)
    #lógica para recorrer todo el array y asignale una letra aleatoria
    for i in 0..examen.numeroPregunta
      a = ('a'..'f').to_a.sample            #comando para sacar una letra aleatoria a - f (siendo f la respuesta en blanco)
      examen.listaRespuestasAlumno[i] = a   #se ingresa la letra aleatoria al array
    end

    #puts "#{examen.listaRespuestasAlumno}" #prueba de imprimir el array para ver los resultados del aleatorio
  end

end

class Ministerio
  attr_accessor :listaAlumnos, :listaExamenes
	def initialize
		@listaAlumnos = Array.new
    @listaExamenes = Array.new
	end

  def registrarAlumno(alumno)
    validarExistenciaAlumno(alumno.dni)
    listaAlumnos.push(alumno)
  end

  def registrarExamen(examen)
    validarExistenciaExamen(examen.codigoEvaluacion)
    listaExamenes.push(examen)
  end

  def validarExistenciaAlumno(dni)
    for alumno in listaAlumnos
      raise "El alumno ya ha sido registrado." if alumno.dni == dni
    end
  end

  def validarExistenciaExamen(codigoEvaluacion)
    for examen in listaExamenes
      raise "El examen ya ha sido registrado." if examen.codigoEvaluacion == codigoEvaluacion
    end
  end

  def ingresarRespuestasCorrectas(codigoEvaluacion, respuestas)
    for examen in listaExamenes
      if examen.codigoEvaluacion == codigoEvaluacion
        validarCantidadRespuestas(examen, respuestas)
        for i in 0..examen.numeroPregunta
          examen.listaRespuestasCorrectas[i] = respuestas[i]
        end
      end
    end
  end

  def alumnoRindeExamen(dniAlumno, codigoEvaluacion)
    #variables necesarias para el cálculo
    respCorrectas = 0
    respIncorrectas = 0
    factorPuntaje = 0
    puntajeEC = 0

    #lógica para determinar el puntaje del alumno
    for alumno in listaAlumnos
      if alumno.dni == dniAlumno  #encuentra el alumno al que se le está asignando el examen
        for examen in listaExamenes
          if examen.codigoEvaluacion == codigoEvaluacion  #encuentra el examen que se le está asignando al alumno
            #determinamos cuánto va a valer cada pregunta
            if examen.numeroPregunta > 10
              factorPuntaje = 5
            else
              factorPuntaje = 10
            end
            examen.simularResultados(examen)  #simula las respuestas del alumno
            #ya tenemos los dos arrays, toca compararlos
            for i in 0..examen.numeroPregunta
              if examen.listaRespuestasAlumno[i] == "f" #respuesta en blanco
                #no hace nada si la respuesta del alumno está en blanco
              elsif examen.listaRespuestasAlumno[i] == examen.listaRespuestasCorrectas[i]
                respCorrectas += 1    #contabiliza cada respuesta correcta
              else
                respIncorrectas += 1  #contabiliza cada respuesta incorrecta
              end
            end
            #calculamos el puntaje final
            puntajeEC = (respCorrectas - (respIncorrectas * 0.5)) * factorPuntaje
          end
        end
        alumno.EC = puntajeEC #se le asigna el puntaje obtenido al alumno
      end
    end
  end

  def validarCantidadRespuestas(examen, respuestas)
    m = respuestas.length
    raise "La cantidad de respuestas no coincide con la cantidad de preguntas del examen." if m != examen.numeroPregunta
  end
end

class Factoria
  def self.dameObjeto(tipo, *arg)
    case tipo
    when "AN"
      AlumnoNacional.new(arg[0], arg[1], arg[2], arg[3], arg[4], arg[5],arg[6])
    when "AP"
      AlumnoParticular.new(arg[0], arg[1], arg[2], arg[3], arg[4], arg[5],arg[6])
    when "EX"
      Examen.new(arg[0], arg[1])
    end
  end
end


class Vista
  def listarDatosGenerales(datos)
    puts "***********Listado Total - Datos Generales*************"
    for alumno in datos
      puts "#{alumno.dni} #{alumno.nombre} #{alumno.apellido} #{alumno.edad} #{alumno.genero}"
    end
  end

  def mensajeError(m)
    puts "Error: #{m}"
  end

  def mostrarValido(m)
    puts m
  end
end


class Controlador
  attr_accessor :vista, :modelo
  def initialize(vista, modelo)
    @vista = vista
    @modelo = modelo
  end

  def registrarAlumno(tipo, *arg)
    alum = Factoria.dameObjeto(tipo, *arg)
    begin
      modelo.registrarAlumno(alum)
      vista.mostrarValido("Alumno registrado exitosamente!")
    rescue Exception => e 
      vista.mensajeError(e.message)
    end
  end

  def registrarExamen(tipo, *arg)
    ex = Factoria.dameObjeto(tipo, *arg)
    begin
      modelo.registrarExamen(ex)
      vista.mostrarValido("Examen registrado exitosamente!")
    rescue Exception => e 
      vista.mensajeError(e.message)
    end
  end

  def ingresarRespuestasCorrectas(codigoEvaluacion, respuestas)
    begin
      modelo.ingresarRespuestasCorrectas(codigoEvaluacion, respuestas)
      vista.mostrarValido("Respuestas ingresadas correctamente!")
    rescue Exception => e 
      vista.mensajeError(e.message)
    end
  end

  def alumnoRindeExamen(dniAlumno, codigoEvaluacion)
    begin
      modelo.alumnoRindeExamen(dniAlumno, codigoEvaluacion)
      vista.mostrarValido("Registro de examen rendido exitoso!")
    rescue Exception => e 
      vista.mensajeError(e.message)
    end
  end

  def imprimirListado
    datos = modelo.listaAlumnos
    vista.listarDatosGenerales(datos)
  end
end

minedu = Ministerio.new
vista = Vista.new
controlador = Controlador.new(vista, minedu)

controlador.registrarAlumno("AP", 78945612, "Andres", "Inope", 15, "Masculino", 1200, 5)
controlador.registrarAlumno("AN", 12365478, "Paolo", "Guerrero", 10, "Masculino", "RURAL", 15)
controlador.registrarAlumno("AP", 65412877, "Adriana", "Lima", 12, "Femenino", 1800, 8)

controlador.registrarExamen("EX", 45, 10)
controlador.registrarExamen("EX", 12, 20)

resp1 = Array["a","b","c","d","e","a","b","c","d","e"]
controlador.ingresarRespuestasCorrectas(12345, resp1)
resp2 = Array["a","b","c","d","e","a","b","c","d","e","a","b","c","d","e","a","b","c","d","e"]
controlador.ingresarRespuestasCorrectas(12145, resp2)

controlador.alumnoRindeExamen(78945612, 45)

controlador.imprimirListado

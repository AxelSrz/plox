require './parser.rb'
require 'yaml'
require "awesome_print"

class VirtualMachine

  def initialize()
    # Variable that saves the number of the current Quadruple
    @quadruplePointer = 0
    @constantBook = YAML.load_file('constants.yaml')
    @quadrupleVector = YAML.load_file('quadruples.yaml')
    @memory = Array.new
    @contextPointer = -1
    newContext()
  end

  def newContext()
    context = Hash.new
    @constantBook.each do |key, value|
      context[key] = value
    end
    @memory.push(context)
    @contextPointer += 1
  end

  def newCall()
  end

  def obtainData(dir)
    @memory[@contextPointer][dir]
  end

  def store(dir, value)
    @memory[@contextPointer][dir] = value
  end

  def addition()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) + obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def subtraction()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) - obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def multiplication()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) * obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def division()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) / obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def mod()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) % obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def greaterThan()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) > obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def lessThan()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) < obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def greaterEqualThan()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) >= obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def lessEqualThan()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) <= obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def equality()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = (obtainData(op1) == obtainData(op2))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def different()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = (obtainData(op1) != obtainData(op2))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def notExp()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = !(obtainData(op1))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def andExp()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = (obtainData(op1) && obtainData(op2))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def orExp()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = (obtainData(op1) || obtainData(op2))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  def equal()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = obtainData(op1)

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  def additionAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = obtainData(op1) + obtainData(op1)

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  def subtractionAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = obtainData(op1) - obtainData(op1)

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  def multiplicationAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = obtainData(op1) * obtainData(op1)

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  def divisionAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = obtainData(op1) / obtainData(op1)

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  def andAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = (obtainData(op1) && obtainData(op1))

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  def orAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = (obtainData(op1) || obtainData(op1))

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  def modAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = (obtainData(op1) % obtainData(op1))

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  def hearAction()

    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = gets.chomp

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  def sayAction()

    res = obtainData(@quadrupleVector[@quadruplePointer][1])

    # Get the value from op1 and store it in a temporary variable
    puts "#{res}";

  end

  def gotoAction()
    @quadruplePointer = @quadrupleVector[@quadruplePointer][3] - 1
  end

  def gotoTrueAction()
    value = obtainData(@quadrupleVector[@quadruplePointer][1])
    @quadruplePointer = @quadrupleVector[@quadruplePointer][3] - 1 if value
  end

  def gotoFalseAction()
    value = obtainData(@quadrupleVector[@quadruplePointer][1])
    @quadruplePointer = @quadrupleVector[@quadruplePointer][3] - 1 unless value
  end

  def paramAction()

  end

  def gosubAction()

  end

  def sendAttributeAction()

  end

  def eraAction()

  end

  def executeQuadruple(quadruple)
    case quadruple[0]
    when "+"
      addition
    when "-"
      subtraction
    when "*"
      multiplication
    when "/"
      division
    when "%"
      mod
    when ">"
      greaterThan
    when "<"
      lessThan
    when ">="
      greaterEqualThan
    when "<="
      lessEqualThan
    when "=="
      equality
    when "!="
      different
    when "!"
      notExp
    when "&&"
      andExp
    when "||"
      orExp
    when "="
      equal
    when "+="
      additionAssign
    when "-="
      subtractionAssign
    when "*="
      multiplicationAssign
    when "/="
      divisionAssign
    when "||="
      orAssign
    when "&&="
      andAssign
    when "%="
      modAssign
    when "hear"
      hearAction
    when "say"
      sayAction
    when "goto"
      gotoAction
    when "gotoT"
      gotoTrueAction
    when "gotoF"
      gotoFalseAction
    when "param"
      paramAction
    when "gosub"
      gosubAction
    when "SEND_ATTR"
      sendAttributeAction
    else
      puts "falta cuadruplo " + quadruple[0]
    end
  end

  def execution()
    puts "Executing program...";
    while @quadruplePointer < @quadrupleVector.count() do
      executeQuadruple(@quadrupleVector[@quadruplePointer])
      @quadruplePointer += 1
    end
  end
end

prueba = ObjectivePlox.new
puts "Ingrese el nombre del archivo a parsear junto con su extension: "
STDOUT.flush
nombre = gets.chomp
prueba.parse(nombre)
vm = VirtualMachine.new

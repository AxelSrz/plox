require './parser.rb'
require 'yaml'
require "awesome_print"

class Memory
  attr_accessor :params, :attributes, :context
  def initialize()
    @params = Hash.new
    @attributes = Hash.new
    @params["paramsCompleted"] = false
    @context = -1
  end
end

class VirtualMachine

  def initialize()
    # Variable that saves the number of the current Quadruple
    @quadruplePointer = 0
    @constantBook = YAML.load_file('constants.yaml')
    @quadrupleVector = YAML.load_file('quadruples.yaml')
    @memory = Array.new
    @contextPointer = -1
    @callStack = Array.new
    @callPointer = -1
    initialContext()
  end

  def initialContext()
    context = Hash.new
    @constantBook.each do |key, value|
      context[key] = value
    end
    context["isSwapping"] = false
    @memory.push(context)
    @contextPointer += 1
  end

  def newContext()
    context = Hash.new
    @constantBook.each do |key, value|
      context[key] = value
    end
    context["isSwapping"] = false
    call = @callStack.pop()
    @callPointer -= 1
    call.params.each do |key, value|
      context[key] = value
    end
    call.attributes.each do |key, h|
      context[key] = h["value"]
    end
    context["forReturn"] = Marshal.load(Marshal.dump(call.attributes))
    context["returnDir"] = @quadrupleVector[@quadruplePointer][3]
    context["returningQuadruple"] = @quadruplePointer
    @memory.push(context)
    @contextPointer += 1
    @quadruplePointer = @quadrupleVector[@quadruplePointer][1] - 1
  end

  def newCall()
    call = Memory.new
    call.context = $contextPointer
    @callStack.push(call)
    @callPointer += 1
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
    input = gets.chomp
    if @quadrupleVector[@quadruplePointer][1] == "number"
      temp = input.to_i
    elsif @quadrupleVector[@quadruplePointer][1] == "decimal"
      temp = input.to_f
    elsif @quadrupleVector[@quadruplePointer][1] == "logic"
      temp = input == "true"
    elsif @quadrupleVector[@quadruplePointer][1] == "char"
      temp = input[0]
    else
      temp = input
    end


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
    if @memory[@contextPointer]["isSwapping"]
        newCall() if @quadrupleVector[@quadruplePointer][2][0] == 1
    else
      @memory[@contextPointer]["isSwapping"] = true
      newCall()
    end
    @callStack[@callPointer].params["paramsCompleted"] = true if @quadrupleVector[@quadruplePointer][2][0] == @quadrupleVector[@quadruplePointer][2][1]
    @callStack[@callPointer].params[@quadrupleVector[@quadruplePointer][3]] = @memory[@contextPointer][@quadrupleVector[@quadruplePointer][1]]
  end

  def gosubAction()
    newContext
  end

  def sendAttributeAction()
    if @memory[@contextPointer]["isSwapping"]
      newCall() unless @callStack[@callPointer].params["paramsCompleted"]
    else
      newCall()
      @memory[@contextPointer]["isSwapping"] = true
      @callStack[@callPointer].params["paramsCompleted"] = true
    end
    @callStack[@callPointer].attributes[@quadrupleVector[@quadruplePointer][1]] = Hash.new
    @callStack[@callPointer].attributes[@quadrupleVector[@quadruplePointer][1]]["value"] = @memory[@contextPointer][@quadrupleVector[@quadruplePointer][1]]
    @callStack[@callPointer].attributes[@quadrupleVector[@quadruplePointer][1]]["return"] = @quadrupleVector[@quadruplePointer][3]
  end

  def returnAction
    past = @memory.pop()
    @contextPointer -= 1
    past["forReturn"].each do |key, h|
      @memory[@contextPointer][h["return"]] = past[key]
    end
    @memory[@contextPointer][past["returnDir"]] = past[@quadrupleVector[@quadruplePointer][3]]
    @quadruplePointer = past["returningQuadruple"]
    if @callStack.count == 0
      @memory[@contextPointer]["isSwapping"] = false
    elsif @callStack[@callPointer].context != @contextPointer
      @memory[@contextPointer]["isSwapping"] = false
    end
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
    when "return"
      returnAction
    when "terminate"
      abort
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
puts "Ingrese el nombre del archivo a compilar: "
STDOUT.flush
nombre = gets.chomp
prueba.parse(nombre)
vm = VirtualMachine.new
vm.execution

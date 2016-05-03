#!/usr/bin/env ruby
require './parser.rb'
require 'yaml'
require "awesome_print"

# Class that simulates the memory and stores
# parameters and attributes as well as the
# current context. 
class Memory
  attr_accessor :params, :attributes, :context
  def initialize()
    @params = Hash.new
    @attributes = Hash.new
    @params["paramsCompleted"] = false
    @context = -1
  end
end

# Class that performs the necesary operations
# for execution. AKA Virtual Machine
class VirtualMachine

  # Method that initializes all the variables for the
  # virtual machine class.
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

  # Method that defines the initial context.
  # It pushes the context and increases the context
  # pointer size in case a new context arrives later.
  def initialContext()
    context = Hash.new
    @constantBook.each do |key, value|
      context[key] = value
    end
    context["isSwapping"] = false
    @memory.push(context)
    @contextPointer += 1
  end

  # Method that creates a new context.
  # It initializes all variables and
  # it stores the context, it retrieves
  # the returning direction, the returning quadruple
  # and it pushes the context to the memory.
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

  # Method that performs a change of context
  # and pushes the last context to the call
  # stack.
  def newCall()
    call = Memory.new
    call.context = $contextPointer
    @callStack.push(call)
    @callPointer += 1
  end

  # Method that returns the value of a variable
  # given its address in memory.
  # Entry parameters:
  # dir - The direction to where the variable and value
  # are stored in memory
  def obtainData(dir)
    if (dir.is_a?(Integer))
      return @memory[@contextPointer][dir]
    else
      return @memory[@contextPointer][@memory[@contextPointer][dir.to_i]]
    end
  end

  # Method that stores a direction and value in memory.
  # Entry parameters:
  # dir - The direction to be stored
  # value - The value to be stored for the direction
  def store(dir, value)
    if (dir.is_a?(Integer))
      @memory[@contextPointer][dir] = value
    else
      @memory[@contextPointer][@memory[@contextPointer][dir.to_i]] = value
    end
  end

  # Method that corresponds to the + action.
  # It determines if the addition between two variables
  # and it stores the result in a temporary variable
  # which is then stored in memory.
  def addition()
    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) + obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)
  end

  # Method that corresponds to the - action.
  # It determines if the subtraction between two variables
  # and it stores the result in a temporary variable
  # which is then stored in memory.
  def subtraction()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) - obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the * action.
  # It determines if the multiplication between two variables
  # and it stores the result in a temporary variable
  # which is then stored in memory.
  def multiplication()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) * obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the / action.
  # It determines if the division between two variables
  # and it stores the result in a temporary variable
  # which is then stored in memory.
  def division()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    if obtainData(op2) == 0
      abort("Execution error: cannot have a division by 0.")
    end
    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) / obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the % action.
  # It determines if the modulus between two variables
  # and it stores the result in a temporary variable
  # which is then stored in memory.
  def mod()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) % obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the > action.
  # It determines if the value of op1 is greater than
  # the value of op2 and it stores the result
  # in a temporary variable which is then stored in memory.
  def greaterThan()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) > obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the < action.
  # It determines if the value of op1 is less than
  # the value of op2 and it stores the result
  # in a temporary variable which is then stored in memory.
  def lessThan()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) < obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the >= action.
  # It determines if the value of op1 is greater than or
  # equal to the value of op2 and it stores the result
  # in a temporary variable which is then stored in memory.
  def greaterEqualThan()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) >= obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the <= action.
  # It determines if the value of op1 is less than or
  # equal to the value of op2 and it stores the result
  # in a temporary variable which is then stored in memory.
  def lessEqualThan()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) <= obtainData(op2)
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the == action.
  # It determines if two variables are equal
  # and it stores the result in a temporary variable
  # which is then stored in memory.
  def equality()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = (obtainData(op1) == obtainData(op2))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the != action.
  # It determines if two variables are different
  # and it stores the result in a temporary variable
  # which is then stored in memory.
  def different()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = (obtainData(op1) != obtainData(op2))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the ! action.
  # It permorms the logical negation to a variable
  # and it stores the result in memory.
  def notExp()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = !(obtainData(op1))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the negate action.
  # It transforms a positve number to a negative one.
  # It stores the result in a temporary variable that
  # is stored in memory.
  def negateExp()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = -(obtainData(op1))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the && action.
  # It permorms the logical and operation between two
  # variables and it stores the result in memory.
  def andExp()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = (obtainData(op1) && obtainData(op2))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the || action.
  # It permorms the logical or operation between two
  # variables and it stores the result in memory.
  def orExp()

    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = (obtainData(op1) || obtainData(op2))
    # Store the temporary variable in @memory
    store(res, temp)

  end

  # Method that corresponds to the = action.
  # It assigns the value of a variable to another variable.
  # It stores the result in memory.
  def equal()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = obtainData(op1)

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  # Method that corresponds to the += action.
  # It assigns the value of an addition operation to a variable.
  # It retrieves both the variable being assigned and the variable
  # where the value will be assigned and it stores the result in a
  # temporary variable in memory.
  def additionAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = obtainData(res) + obtainData(op1)

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  # Method that corresponds to the -= action.
  # It assigns the value of a subtraction operation to a variable.
  # It retrieves both the variable being assigned and the variable
  # where the value will be assigned and it stores the result in a
  # temporary variable in memory.
  def subtractionAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = obtainData(res) - obtainData(op1)

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  # Method that corresponds to the *= action.
  # It assigns the value of a multiplication operation to a variable.
  # It retrieves both the variable being assigned and the variable
  # where the value will be assigned and it stores the result in a
  # temporary variable in memory.
  def multiplicationAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = obtainData(res) * obtainData(op1)

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  # Method that corresponds to the /= action.
  # It assigns the value of a division operation to a variable.
  # It retrieves both the variable being assigned and the variable
  # where the value will be assigned and it stores the result in a
  # temporary variable in memory.
  def divisionAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = obtainData(res) / obtainData(op1)

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  # Method that corresponds to the &&= action.
  # It assigns the value of an and operation to a variable.
  # It retrieves both the variable being assigned and the variable
  # where the value will be assigned and it stores the result in a
  # temporary variable in memory.
  def andAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = (obtainData(res) && obtainData(op1))

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  # Method that corresponds to the ||= action.
  # It assigns the value of an or operation to a variable.
  # It retrieves both the variable being assigned and the variable
  # where the value will be assigned and it stores the result in a
  # temporary variable in memory.
  def orAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = (obtainData(res) || obtainData(op1))

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  # Method that corresponds to the %= action.
  # It assigns the value of a mod operation to a variable.
  # It retrieves both the variable being assigned and the variable
  # where the value will be assigned and it stores the result in a
  # temporary variable in memory.
  def modAssign()

    op1 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    temp = (obtainData(res) % obtainData(op1))

    # Store the value of op1 in the @memory address of res
    store(res, temp)

  end

  # Method that corresponds to the +SpecialRight action.
  # It performs the addition of a negative number with
  # a positive one. It retrieves both variables and the variable
  # where the value will be assigned and it stores value in a
  # temporary variable in memory.
  def addSpecialRight
    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) + op2
    # Store the temporary variable in @memory
    store(res, temp)
  end

  # Method that corresponds to the *SpecialRight action.
  # It performs the multiplication of a negative number with
  # a positive one. It retrieves both variables and the variable
  # where the value will be assigned and it stores value in a
  # temporary variable in memory.
  def multSpecialRight
    op1 = @quadrupleVector[@quadruplePointer][1]
    op2 = @quadrupleVector[@quadruplePointer][2]
    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value for op1 and op2 and store them in a temporary variable
    temp = obtainData(op1) * op2
    # Store the temporary variable in @memory
    store(res, temp)
  end

  # Method that corresponds to the verify quadruple
  # It checks is the number that you are trying
  # to get in an array is between the lower and
  # upper bounds.
  def verify
    num = obtainData(@quadrupleVector[@quadruplePointer][3])
    abort("Execution error: out of bounds.") unless num <= @quadrupleVector[@quadruplePointer][1] && num >= @quadrupleVector[@quadruplePointer][2]
  end

  # Method that corresponds to the hear action.
  # It gets the value of the thing to read and
  # it determins the data type to which it belongs.
  # After that it stores it in the corresponding
  # memory location.
  def hearAction()

    res = @quadrupleVector[@quadruplePointer][3]

    # Get the value from op1 and store it in a temporary variable
    input = $stdin.gets.chomp
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

  # Method that corresponds to the say action.
  # It gets the value of the thing to print and
  # it prints it with an endline at the end.
  def sayAction()

    res = obtainData(@quadrupleVector[@quadruplePointer][1])

    # Get the value from op1 and store it in a temporary variable
    puts "#{res}";

  end

  # Method that corresponds to the goto action.
  # It gets the address of the place you need to
  # jump to.
  def gotoAction()
    @quadruplePointer = @quadrupleVector[@quadruplePointer][3] - 1
  end

  # Method that corresponds to the gotoT action.
  # It gets the address of the place you need to go to
  # if the variable value is equal to true.
  def gotoTrueAction()
    value = obtainData(@quadrupleVector[@quadruplePointer][1])
    @quadruplePointer = @quadrupleVector[@quadruplePointer][3] - 1 if value
  end

  # Method that corresponds to the gotoF action.
  # It gets the address of the place you need to go to
  # if the variable value is equal to false.
  def gotoFalseAction()
    value = obtainData(@quadrupleVector[@quadruplePointer][1])
    @quadruplePointer = @quadrupleVector[@quadruplePointer][3] - 1 unless value
  end

  # Method that corresponds to the param action.
  # It starts sending parameters to a function
  # up until the amount of parameters that it
  # can accept.
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

  # Method that corresponds to the param action.
  # It sends the attributes of a function from one
  # contexto to another.
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

  # Method that corresponds to the return action.
  # it gets the direction to which the code needs to
  # return after being in a function.
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

  # Method that executes quadruples with a switch.
  # Entry parameters: The pointer to the current quadruple.
  # It obtains the first element of the current quadruple (it's action)
  # and it executes the method that corresponds to that action.
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
    when "negate"
      negateExp
    when "+SpecialRight"
      addSpecialRight
    when "*SpecialRight"
      multSpecialRight
    when "verify"
      verify
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
    # Ends the program's execution.
    when "terminate"
      abort
    # Indicates that there is no action for the current quadruple.
    else
      puts "falta cuadruplo " + quadruple[0]
    end
  end

  # Method that starts the execution of the program. It shows a message
  # so the programmer knows he is in the execution. It starts the
  # execution of the quadruples one by one until the quadruple vector's
  # total size is met. The counter increments by 1 to get the next
  # quadruple.
  def execution()
    puts "Executing program...";
    while @quadruplePointer < @quadrupleVector.count() do
      executeQuadruple(@quadrupleVector[@quadruplePointer])
      @quadruplePointer += 1
    end
  end
end

prueba = ObjectivePlox.new
prueba.parse(ARGV[0])
vm = VirtualMachine.new
vm.execution

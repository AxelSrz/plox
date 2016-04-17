require_relative 'objective_plox_bison.y'

# Variable that saves the content of the current Quadruple
$currentQuadruple = Array.new
$memoryManager = $speciesBook
$memory
$quadrupleManager = $quadrupleVector

# Variable that saves the number of the current Quadruple
$quadrupleCounter = 0

def addition()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = $memory.obtainData(op1) + $memory.obtainData(op2)
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def subtraction()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = $memory.obtainData(op1) - $memory.obtainData(op2)
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def multiplication()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = $memory.obtainData(op1) * $memory.obtainData(op2)
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def division()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = $memory.obtainData(op1) / $memory.obtainData(op2)
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def mod()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = $memory.obtainData(op1) % $memory.obtainData(op2)
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def greaterThan()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = $memory.obtainData(op1) > $memory.obtainData(op2)
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def lessThan()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = $memory.obtainData(op1) < $memory.obtainData(op2)
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def greaterEqualThan()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = $memory.obtainData(op1) >= $memory.obtainData(op2)
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def lessEqualThan()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = $memory.obtainData(op1) <= $memory.obtainData(op2)
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def equality()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = ($memory.obtainData(op1) == $memory.obtainData(op2))
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def different()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = ($memory.obtainData(op1) != $memory.obtainData(op2))
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def notExp()

  op1 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = !($memory.obtainData(op1))
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def andExp()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = ($memory.obtainData(op1) && $memory.obtainData(op2))
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def orExp()

  op1 = $currentQuadruple[1]
  op2 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value for op1 and op2 and store them in a temporary variable
  temp = ($memory.obtainData(op1) || $memory.obtainData(op2))
  # Store the temporary variable in memory
  $memory.store(res, temp)

end

def equal()

  op1 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value from op1 and store it in a temporary variable
  temp = $memory.obtainData(op1)

  # Store the value of op1 in the memory address of res
  $memory.store(res, temp)

end

def additionAssign()

  op1 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value from op1 and store it in a temporary variable
  temp = $memory.obtainData(op1) + $memory.obtainData(op1)

  # Store the value of op1 in the memory address of res
  $memory.store(res, temp)

end

def subtractionAssign()

  op1 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value from op1 and store it in a temporary variable
  temp = $memory.obtainData(op1) - $memory.obtainData(op1)

  # Store the value of op1 in the memory address of res
  $memory.store(res, temp)

end

def multiplicationAssign()

  op1 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value from op1 and store it in a temporary variable
  temp = $memory.obtainData(op1) * $memory.obtainData(op1)

  # Store the value of op1 in the memory address of res
  $memory.store(res, temp)

end

def divisionAssign()

  op1 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value from op1 and store it in a temporary variable
  temp = $memory.obtainData(op1) / $memory.obtainData(op1)

  # Store the value of op1 in the memory address of res
  $memory.store(res, temp)

end

def andAssign()

  op1 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value from op1 and store it in a temporary variable
  temp = ($memory.obtainData(op1) && $memory.obtainData(op1))

  # Store the value of op1 in the memory address of res
  $memory.store(res, temp)

end

def orAssign()

  op1 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value from op1 and store it in a temporary variable
  temp = ($memory.obtainData(op1) || $memory.obtainData(op1))

  # Store the value of op1 in the memory address of res
  $memory.store(res, temp)

end

def modAssign()

  op1 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value from op1 and store it in a temporary variable
  temp = ($memory.obtainData(op1) % $memory.obtainData(op1))

  # Store the value of op1 in the memory address of res
  $memory.store(res, temp)

end

def hearAction()

  op1 = $currentQuadruple[2]
  res = $currentQuadruple[3]

  # Get the value from op1 and store it in a temporary variable
  temp = gets.chomp

  # Store the value of op1 in the memory address of res
  $memory.store(res, temp)

end

def sayAction()

  res = $currentQuadruple[3]

  # Get the value from op1 and store it in a temporary variable
  puts "#{res}";

end

$Action = {
  "+" => addition,
  "-" => subtraction,
  "*" => multiplication,
  "/" => division,
  "%" => mod,
  ">" => greaterThan,
  "<" => lessThan,
  ">=" => greaterEqualThan,
  "<=" => lessEqualThan,
  "==" => equality,
  "!=" => different,
  "!" => notExp,
  "&&" => andExp,
  "||" => orExp,
  "=" => equal,
  "+=" => additionAssign,
  "-=" => subtractionAssign,
  "*=" => multiplicationAssign,
  "/=" => divisionAssign,
  "||=" => orAssign,
  "&&=" => andAssign,
  "%=" => modAssign
  "hear" => hearAction,
  "say" => sayAction
}

class VirtualMachine
  def executeQuadruple(quadruple)
    $currentQuadruple = quadruple

    # Retrieval of the action to execute in the switch
    quadrupleAction = quadruple[0]

    return $Action[quadrupleAction]

  end

  def execution()
    puts "Executing program...";
    while $quadrupleCounter < $quadrupleManager.count() do
      executeQuadruple($quadrupleManager[$quadrupleCounter])
      $quadrupleCounter += 1
    end
  end
end

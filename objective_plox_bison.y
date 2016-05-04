class ObjectivePlox
  prechigh
    right POINT
    nonassoc NOT
    left MOD
    left MULT DIV
    left PLUS MINUS
    left MTHAN MEQUAL LTHAN LEQUAL EQUALITY DIFFERENT
    left AND OR
    right EQUAL PLUSASSIGN MINUSASSIGN MULTASSIGN DIVASSIGN ORASSIGN ANDASSIGN MODASSIGN
    nonassoc SEMIC
  preclow
rule
  supreme_plox:
    plox_generation                                   { puts "OP! Compilation successful."; terminateCompilation() }

  plox_generation:
    /* empty */                                       {}
    | type_declaration plox_generation                {}

  type_declaration:
    HABEMVS class_declaration                         {}

  class_declaration:
    SPECIES code_new_class code_heirof BLEFT class_body BRIGHT      {}

  code_new_class:
    ID { newSpecies(val[0][0]) }

  code_heirof:
    /* empty */                                       {}
    | HEIROF ID                                       { heirSpecies(val[1][0]) }

  class_body:
    class_variable_block class_function_block         {}

  class_variable_block:
    /* empty */                                       {}
    | variable_declaration class_variable_block       {}

  class_function_block:
    /* empty */                                       {}
    | method_declaration class_function_block         {}

  modifier:
    OPEN                                              { $actualModifier = true }
    | HIDDEN                                          { $actualModifier = false }

  variable_declaration:
    variable_is_modifiable variable_scope type_specifier some_variables SEMIC            {}

  variable_scope:
    /* empty */                                       {}
    | modifier                                        {}

  variable_is_modifiable:
    VAR                                               { $actualModifier = false; $isVariable = true }
    | ETERNAL                                         { $actualModifier = false; $isVariable = false }

  some_variables:
    code_new_variable next_variable                   {}

  code_new_variable:
    new_var_id array_dec                              {}

  new_var_id:
    ID  { newVariable(val[0][0]) }

  next_variable:
    /* empty */                                       {}
    | COMA some_variables                             {}

  array_dec:
    /* empty */                                       {}
    | start_array bounds array_dec2 SBRIGHT           { defineArray() }

  start_array:
    SBLEFT                                            { newArray() }

  array_dec2:
    /* empty */                                       {}
    | COMA bounds array_dec2                          {}

  bounds:
   CTEN POINT POINT CTEN  { newDimension(val[0], val[3]) }

  variable_assignment:
    id_reference EQUAL expression                     { createAssignQuadruple(val[1][0], val[0], val[2]) }
    | id_reference PLUSASSIGN expression              { createAssignQuadruple(val[1][0], val[0], val[2]) }
    | id_reference MINUSASSIGN expression             { createAssignQuadruple(val[1][0], val[0], val[2]) }
    | id_reference MULTASSIGN expression              { createAssignQuadruple(val[1][0], val[0], val[2]) }
    | id_reference DIVASSIGN expression               { createAssignQuadruple(val[1][0], val[0], val[2]) }
    | id_reference ORASSIGN expression                { createAssignQuadruple(val[1][0], val[0], val[2]) }
    | id_reference ANDASSIGN expression               { createAssignQuadruple(val[1][0], val[0], val[2]) }
    | id_reference MODASSIGN expression               { createAssignQuadruple(val[1][0], val[0], val[2]) }

  array_call:
    start_array_call array_index array_call2 SBRIGHT    { val[0][1] = endArrayAccess() }

  start_array_call:
    SBLEFT                                            { startArrayIndex() }

  array_call2:
    /* empty */                                       {}
    | COMA array_index array_call2                    {}

  array_index:
   expression                                         { newDimensionIndex(val[0]) }

  method_declaration:
    new_function_code method_declaration1 type_specifier method_declaration2 PLEFT method_declaration3 PRIGHT method_declaration4    { endFunk([nil, nil]) }

  new_function_code:
    FUNK { $actualModifier = true }

  method_declaration1:
    /* empty */                                       {}
    | modifier                                        {}

  method_declaration2:
    ID                                                { newMethod(val[0][0]) }
    | CHIEF                                           { newMethod("chief"); fillQuadruple(0) }

  method_declaration3:
    /* empty */                                       {}
    | parameter_list method_declaration3              {}

  method_declaration4:
    statement_block                                   {}
    | SEMIC                                           {}


  type_specifier:
    LOGIC                                             { $actualType = "logic" }
    | CHAR                                            { $actualType = "char" }
    | NUMBER                                          { $actualType = "number" }
    | DECIMAL                                         { $actualType = "decimal" }
    | ID                                              { $actualType = val[0][0] }
    | OBLIVION                                        { $actualType = "oblivion" }
    | STRING                                          { $actualType = "string" }

  parameter_list:
    parameter parameter_list1                         {}

  parameter_list1:
    /* empty */                                       {}
    | COMA parameter_list                             {}

  statement_block:
    BLEFT statement_block1 statement_block2 BRIGHT    {}

  statement_block1:
    /* empty */                                       {}
    | variable_declaration statement_block1           {}

  statement_block2:
    /* empty */                                       {}
    | statement statement_block2                      {}

  reference_expression:
    id_reference                                    {}
    | non_final_id POINT function_call                { val[0][0] = val[2][0]; val[0][1] = val[2][1]; $actualIdSpecies = $speciesStack.last; $actualIdFunk = $idStack.last }
    | non_final_id POINT reference_expression5        { val[0][0] = val[0][0] + "." + val[2][0]; validateAttribute(val[0][0]); val[0][1] = retrieveIdLocation(val[0][0]); val[0][0] = retrieveIdType(val[0][0]); $actualIdSpecies = nil }
    | function_call                                   { $actualIdSpecies = nil }

  id_reference:
    base_id                                           {}
    | base_id array_call                              { val[0][1] = val[1][1] }

  base_id:
    ID                                                { $actualId = val[0][0]; val[0][1] = retrieveIdLocation(val[0][0]); val[0][0] = retrieveIdType(val[0][0]) }

  non_final_id:
    ID                                                { $actualIdSpecies = retrieveIdType(val[0][0]); $actualId = val[0][0] }

  function_call:
    funk_id start_funk reference_expression6 PRIGHT     { val[0][0] = val[1][0]; val[0][1] = endFunkCall() }

  funk_id:
    ID                                                { $actualIdFunk = val[0][0] }

  start_funk:
    PLEFT                                       { val[0][0] = validateFunk() }

  reference_expression5:
    ID                                                {}
    | ID POINT reference_expression5                  { val[0][0] = val[0][0] + "." + val[2][0] }

  reference_expression6:
    /* empty */                                       {}
    | arglist                                         {}

  parameter:
    type_specifier ID                                 { newArgument(val[0][0], val[1][0]) }

  statement:
    variable_assignment SEMIC                         {}
    | SAY PLEFT expression PRIGHT SEMIC               {$quadrupleVector.push(["say", val[2][1], nil, nil])}
    | HEAR PLEFT reference_expression PRIGHT SEMIC    {$quadrupleVector.push(["hear", val[2][0], nil, val[2][1]]) }
    | unless_statement                                {}
    | if_statement                                    {}
    | do_statement                                    {}
    | while_statement                                 { endWhile() }
    | REPLY expression SEMIC                          { endFunk(val[1]) }
    | function_call SEMIC                             { $actualIdSpecies = $speciesStack.last; $actualIdFunk = $idStack.last }
    | non_final_id POINT function_call SEMIC          { val[0][0] = val[2][0]; val[0][1] = val[2][1]; $actualIdSpecies = nil }


  expression:
    expression SUM expression                { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression DIV expression              { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression MOD expression              { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression PLUS expression             { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression MINUS expression            { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression MULT expression             { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression MTHAN expression            { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression LTHAN expression            { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression MEQUAL expression           { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression LEQUAL expression           { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression EQUALITY expression         { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression DIFFERENT expression        { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | NOT expression                         { val[0][0] = "logic";  val[0][1] = createNotQuadruple(val[1]) }
    | MINUS expression                       { val[0][0] = "number"; val[0][1] = createNegateExp(val[1]) }
    | expression AND expression              { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression OR expression               { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | TRUE                                   { val[0][1] = $trueLocation }
    | FALSE                                  { val[0][1] = $falseLocation }
    | PLEFT expression PRIGHT                { val[0][0] = val[1][0]; val[0][1] = val[1][1] }
    | literal_expression                     {}
    | reference_expression                   {}

  arglist:
    generate_arg arglist1                               {}

  generate_arg:
    expression                                       { generateArg(val[0]) }

  arglist1:
    /* empty */                                       {}
    | COMA arglist                                    {}

  unless_statement:
    UNLESS expression statement_block unless_statement1    {}

  unless_statement1:
    /* empty */                                       {}
    | ELSE statement_block                                  {}

  if_statement:
    IF push_if_floor validateLogicexp statement_block if_statement1  { endIf() }

  if_statement1:
    /* empty */                                       {}
    | ELSIF generateElseCode validateLogicexp statement_block if_statement1      {}
    | ELSE generateElseCode statement_block                      {}

  do_statement:
    DO push_cont_jump statement_block WHILE validateDoWhileExp  {}

  validateDoWhileExp:
    expression                                          { generateDoWhileQuadruple(val[0]) }

  while_statement:
    WHILE push_cont_jump validateLogicexp statement_block    {}

  push_cont_jump:
    /* empty */                                       { $jumpStack.push($quadrupleVector.count()) }

  push_if_floor:
    /* empty */                                       { $jumpStack.push("if") }

  validateLogicexp:
    expression                                        { generateLogicControlQuadruple(val[0], false) }

  generateElseCode:
    /* empty */                                       { generateElse() }

  literal_expression:
    CTED                                              { val[0][1] = newConstant(val[0][0], val[0][1]) }
    | CTEN                                            { val[0][1] = newConstant(val[0][0], val[0][1]) }
    | CTESTRING                                       { val[0][1] = newConstant(val[0][0], val[0][1]) }

end

---- header

  require_relative 'lexer'  # Add the lexer to the racc program.
  require 'yaml'
  require "awesome_print"
  $line_number = 0          # Initialization of the variable that stores the line number.
  $speciesBook = Hash.new{}
  $actualSpecies
  $actualModifier
  $isVariable
  $actualType
  $actualMethod
  $actualScope
  $operatorStack = Array.new
  $operandStack = Array.new
  $quadrupleVector = Array.new
  first = ["goto", nil, nil, nil]
  $quadrupleVector.push(first)
  $constantBook = Hash.new
  $constantCounterBook = Hash.new
  $theMagicNumber = 10000
  $magicReference = {
    "global" => {
      "number" => 0,
      "decimal" => 1,
      "string" => 2,
      "char" => 3,
      "logic" => 4
    },
    "local" => {
      "number" => 5,
      "decimal" => 6,
      "string" => 7,
      "char" => 8,
      "logic" => 9
    },
    "temporal" => {
      "number" => 10,
      "decimal" => 11,
      "string" => 12,
      "char" => 13,
      "logic" => 14
    },
    "constant" => {
      "number" => 15,
      "decimal" => 16,
      "string" => 17,
      "char" => 18,
      "logic" => 19
    }
  }
  $magicCounter = {
    "global" => {
      "number" => 0,
      "decimal" => 0,
      "string" => 0,
      "char" => 0,
      "logic" => 0
    },
    "local" => {
      "number" => 0,
      "decimal" => 0,
      "string" => 0,
      "char" => 0,
      "logic" => 0
    },
    "temporal" => {
      "number" => 0,
      "decimal" => 0,
      "string" => 0,
      "char" => 0,
      "logic" => 0
    },
    "constant" => {
      "number" => 0,
      "decimal" => 0,
      "string" => 0,
      "char" => 0,
      "logic" => 0
    }
  }
  $semanticCube = {
    "logic" => {
      "logic" => {
        "!=" => "logic",
        "||=" => "logic",
        "&&=" => "logic",
        "==" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "=" => "logic"
      },
      "char" => {
      },
      "number" => {
      },
      "decimal" => {
      },
      "string" => {
      },
      "hear" => {
        "!=" => "logic",
        "||=" => "logic",
        "&&=" => "logic",
        "==" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "=" => "logic"
      }
    },
    "char" => {
      "logic" => {
      },
      "char" => {
        "!=" => "logic",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "=" => "char",
        "<" => "logic",
        ">" => "logic"
      },
      "number" => {
      },
      "decimal" => {
      },
      "string" => {
      },
      "hear" => {
        "!=" => "logic",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "=" => "char",
        "<" => "logic",
        ">" => "logic"
      }
    },
    "number" => {
      "logic" => {
      },
      "char" => {
      },
      "number" => {
        "!=" => "logic",
        "+=" => "number",
        "-=" => "number",
        "*=" => "number",
        "/=" => "number",
        "%=" => "number",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "%" => "number",
        "*" => "number",
        "/" => "number",
        "+" => "number",
        "-" => "number",
        "=" => "number",
        "<" => "logic",
        ">" => "logic"
      },
      "decimal" => {
        "!=" => "logic",
        "+=" => "number",
        "-=" => "number",
        "*=" => "number",
        "/=" => "number",
        "%=" => "number",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "%" => "number",
        "*" => "number",
        "/" => "number",
        "+" => "number",
        "-" => "number",
        "=" => "number",
        "<" => "logic",
        ">" => "logic"
      },
      "string" => {
      },
      "hear" => {
        "!=" => "logic",
        "+=" => "number",
        "-=" => "number",
        "*=" => "number",
        "/=" => "number",
        "%=" => "number",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "%" => "number",
        "*" => "number",
        "/" => "number",
        "+" => "number",
        "-" => "number",
        "=" => "number",
        "<" => "logic",
        ">" => "logic"
      }
    },
    "decimal" => {
      "logic" => {
      },
      "char" => {
      },
      "number" => {
        "!=" => "logic",
        "+=" => "number",
        "-=" => "number",
        "*=" => "number",
        "/=" => "number",
        "%=" => "number",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "%" => "number",
        "*" => "number",
        "/" => "number",
        "+" => "number",
        "-" => "number",
        "=" => "number",
        "<" => "logic",
        ">" => "logic"
      },
      "decimal" => {
        "!=" => "logic",
        "+=" => "decimal",
        "-=" => "decimal",
        "*=" => "decimal",
        "/=" => "decimal",
        "%=" => "decimal",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "%" => "decimal",
        "*" => "decimal",
        "/" => "decimal",
        "+" => "decimal",
        "-" => "decimal",
        "=" => "decimal",
        "<" => "logic",
        ">" => "logic"
      },
      "string" => {
      },
      "hear" => {
        "!=" => "logic",
        "+=" => "decimal",
        "-=" => "decimal",
        "*=" => "decimal",
        "/=" => "decimal",
        "%=" => "decimal",
        "==" => "logic",
        "<=" => "logic",
        ">=" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "%" => "decimal",
        "*" => "decimal",
        "/" => "decimal",
        "+" => "decimal",
        "-" => "decimal",
        "=" => "decimal",
        "<" => "logic",
        ">" => "logic"
      }
    },
    "string" => {
      "logic" => {
      },
      "char" => {
      },
      "number" => {
      },
      "decimal" => {
      },
      "string" => {
        "!=" => "logic",
        "==" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "=" => "string",
      },
      "hear" => {
        "!=" => "logic",
        "==" => "logic",
        "&&" => "logic",
        "||" => "logic",
        "=" => "string",
      }
    }
  }
  $falseLocation = $magicReference["constant"]["logic"] * $theMagicNumber
  $trueLocation = $falseLocation + 1
  $jumpStack = Array.new
  $actualIdSpecies = nil
  $actualFunkType
  $funkGlobalContext
  $actualId
  $argumentCount = 0
  $argumentCountStack = []
  $funkSpecies
  $speciesStack = Array.new
  $idStack = Array.new
  $actualVarId
  $arrayIndexStack = Array.new

  $constantBook[false] = $magicReference["constant"]["logic"] * $theMagicNumber
  $constantBook[true] = $constantBook[false] + 1

---- inner

  # Función que lee un archivo de texto como entrada. Esta ha sido
  # importada de la gema RACC.
  def parse(input)
    scan_file(input)
  end

  # Metodo que despliega la linea donde encontro el error
  def on_error(t, val, vstack)
    raise ParseError, sprintf("\nParsing error on value %s (%s) found on line: %i", val[0].inspect, token_to_str(t) || '?', $line_number)
  end

  # Método que crea una nueva clase en el hash correspondiente.
  # Parámetros de entrada:
  # species: el nombre de la clase
  # Este método crea la estructura del hash y lo agrega
  # al dirProc. Se muestra un error si la clase ya existe.
  def newSpecies(species)
    if $speciesBook[species] == nil
      $speciesBook[species] = Hash.new
      $speciesBook[species]["methods"] = Hash.new
      $speciesBook[species]["variables"] = Hash.new
      $speciesBook[species]["size"] = { "number" => 0, "decimal" => 0, "string" => 0, "char" => 0, "logic" => 0 }
      $actualSpecies = species
      $actualMethod = "species"
      resetCounters("global")
    else
      abort("Semantic error: species '#{species}' is already defined. Error on line: #{$line_number}")
    end
  end

  # Método que implementa la herencia entre clases.
  # Parámetros de entrada:
  # father: El nombre de la clase padre
  # Este método agrega el padre de una clase a la que se encuentra
  # se hereda y muestra un mensaje de error si la clase padre
  # no se ha creado.
  def heirSpecies(father)
    if $speciesBook[father] != nil
      $speciesBook[$actualSpecies]["father"] = $speciesBook[father]
      $magicCounter["global"] = $speciesBook[father]["size"].clone
    else
      abort("Semantic error: '#{father}' father of species '#{$actualSpecies}' is not defined. Error on line: #{$line_number}")
    end
  end

  # Método que añade una variable a la tabla de variables para una determinada
  # clase.
  # Parámetros de entrada:
  # Id: El nombre de la variable
  # Este método crea una nueva variable y se añade
  # a la tabla de variables. Tiene múltiples validaciones
  # en caso de que la clase de la variable que estas creando no existe,
  # o un error si no se define la variable,
  # O si se ha definido previamente.
  def newVariable(id)
    if $actualMethod == "species"
      unless idDeclaredInSpeciesRecursively($speciesBook[$actualSpecies], id, "variables")
        abort("Semantic error: species '#{$actualType}' is not defined. Error on line: #{$line_number}") unless isValidType($actualType)
        abort("Semantic error: you cannot have recursive species definitions. Error on line: #{$line_number}") if $actualType == $actualSpecies
        $speciesBook[$actualSpecies]["variables"][id] = Hash.new
        $speciesBook[$actualSpecies]["variables"][id]["type"] = $actualType
        $speciesBook[$actualSpecies]["variables"][id]["scope"] = $actualModifier
        $speciesBook[$actualSpecies]["variables"][id]["modifiable"] = $isVariable
        if $actualType == "number" || $actualType == "decimal" || $actualType == "string" || $actualType == "char" || $actualType == "logic"
          $speciesBook[$actualSpecies]["variables"][id]["location"] = locationGenerator(1, "global", $actualType)
          $speciesBook[$actualSpecies]["size"][$actualType] += 1
        else
          createAtributtesRecursively(id, $speciesBook[$actualType])
        end
      else
        abort("Semantic error: variable '#{id}' is already defined. Error on line: #{$line_number}")
      end
    else
      if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] == nil
        abort("Semantic error: species '#{$actualType}' is not defined. Error on line: #{$line_number}") unless isValidType($actualType)
        $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] = Hash.new
        $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["type"] = $actualType
        $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["modifiable"] = $isVariable
        if $actualType == "number" || $actualType == "decimal" || $actualType == "string" || $actualType == "char" || $actualType == "logic"
          $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["location"] = locationGenerator(1, "local", $actualType)
          $speciesBook[$actualSpecies]["methods"][$actualMethod]["size"][$actualType] += 1
        end
      else
        abort("Semantic error: variable '#{id}' is already defined in method '#{$actualMethod}'. Error on line: #{$line_number}")
      end
    end
    $actualVarId = id
  end

  # Método que crea una nueva matriz. Se recupera la species y el
  # tipo de la matriz. Se lleva a cabo una validación para ver si está
  # tratando de crear una matriz de objetos (que no es compatible).
  def newArray()
    if $actualMethod == "species"
      if $actualType == "number" || $actualType == "decimal" || $actualType == "string" || $actualType == "char" || $actualType == "logic"
        $speciesBook[$actualSpecies]["variables"][$actualVarId]["dimensions"] = Array.new
      else
        abort("Semantic error: ObjectivePlox currently doesnt support arrays of objects. Error on line: #{$line_number}")
      end
    else
      if $actualType == "number" || $actualType == "decimal" || $actualType == "string" || $actualType == "char" || $actualType == "logic"
        $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][$actualVarId]["dimensions"] = Array.new
      else
        abort("Semantic error: ObjectivePlox currently doesnt support arrays of objects. Error on line: #{$line_number}")
      end
    end
  end

  # Método que agrega una nueva dimension en la declaracion de una matriz.
  # Parámetros de entrada:
  # infLi: Limite inferior
  # supLi: Limite superior
  # Crea un hash con los datos de los limites y la r acumulada hasta el momento
  # y lo agrega a las dimensiones de la variable
  def newDimension(infLi, supLi)
    dimension = Hash.new
    dimension["sl"] = supLi[1]
    dimension["il"] = infLi[1]
    dimension["r"] = supLi[1] - infLi[1] + 1
    if $actualMethod == "species"
      dimension["r"] *= $speciesBook[$actualSpecies]["variables"][$actualVarId]["dimensions"].last["r"] if $speciesBook[$actualSpecies]["variables"][$actualVarId]["dimensions"].last != nil
      $speciesBook[$actualSpecies]["variables"][$actualVarId]["dimensions"].push(dimension)
    else
      dimension["r"] *= $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][$actualVarId]["dimensions"].last["r"] if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][$actualVarId]["dimensions"].last != nil
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][$actualVarId]["dimensions"].push(dimension)
    end
  end

  # Método que saca la dimension total de un array y la k
  # Segun la formula vuelve a recorrer toda la lista
  # de dimesiones para sacar el tamaño total y la k
  def defineArray()
    suma = 0
    if $actualMethod == "species"
      r = $speciesBook[$actualSpecies]["variables"][$actualVarId]["dimensions"].last["r"]
      $speciesBook[$actualSpecies]["variables"][$actualVarId]["totalsize"] = r
      locationGenerator(r-1, "global", $actualType)
      $speciesBook[$actualSpecies]["variables"][$actualVarId]["dimensions"].each_with_index do |h, i|
        m = r / (h["sl"] - h["il"] + 1)
        r = m
        suma += (h["il"] * m)
        if i == $speciesBook[$actualSpecies]["variables"][$actualVarId]["dimensions"].count - 1
          $speciesBook[$actualSpecies]["variables"][$actualVarId]["dimensions"][i]["k"] = - suma
        else
          $speciesBook[$actualSpecies]["variables"][$actualVarId]["dimensions"][i]["m"] = m
        end
      end
    else
      r = $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][$actualVarId]["dimensions"].last["r"]
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][$actualVarId]["totalsize"] = r
      locationGenerator(r-1, "local", $actualType)
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][$actualVarId]["dimensions"].each_with_index do |h, i|
        m = r / (h["sl"] - h["il"] + 1)
        r = m
        suma += (h["il"] * m)
        if i == $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][$actualVarId]["dimensions"].count - 1
          $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][$actualVarId]["dimensions"][i]["k"] = - suma
        else
          $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][$actualVarId]["dimensions"][i]["m"] = m
        end
      end
    end
  end

  # Método recursivo que regresa si un id está declarado en una
  # species o en alguno de los padres.
  # Parámetros de entrada:
  # species: hash de la species a buscar
  # id: un string del id que se está buscando
  # type: el tipo del id que se está buscando
  def idDeclaredInSpeciesRecursively(species, id, type)
    if species[type][id] != nil # regresa si la variable ya existe
      return true
    elsif species["father"] == nil  # si la clase no tiene padre
      return false
    else
      return idDeclaredInSpeciesRecursively(species["father"], id, type) # checa para su padre
    end
  end

  def isValidType(type)
    if type == "number" || type == "decimal" || type == "char" || type == "string" || type == "logic"
      return true
    else
      return $speciesBook[type] != nil # que no sea un hash vacio (valor por default)
    end
  end

  # Método para dar de alta una funcion o método
  # en una species.
  # Parámetros de entrada:
  # id: nombre de la funcion
  # Este método crea una nueva funcion y se añade
  # a la tabla de variables. Tiene múltiples validaciones
  # en caso de que la clase de la funcion que estas creando no existe,
  # o un error si no se define el tipo de la funcion,
  # O si la funcion ya se ha definido previamente.
  def newMethod(id)
    unless $speciesBook[$actualSpecies]["methods"][id] != nil
      unless isValidType($actualType) || $actualType == "oblivion"
        abort("Semantic error: species '#{$actualType}' is not defined. Error on line: #{$line_number}")
      end
      $speciesBook[$actualSpecies]["methods"][id] = Hash.new
      $speciesBook[$actualSpecies]["methods"][id]["type"] = $actualType
      $speciesBook[$actualSpecies]["methods"][id]["scope"] = $actualModifier
      $speciesBook[$actualSpecies]["methods"][id]["size"] = { "number" => 0, "decimal" => 0, "string" => 0, "char" => 0, "logic" => 0 }
      $speciesBook[$actualSpecies]["methods"][id]["variables"] = Hash.new
      $speciesBook[$actualSpecies]["methods"][id]["argumentList"] = []
      $speciesBook[$actualSpecies]["methods"][id]["begin"] = $quadrupleVector.count()
      $actualMethod = id
      resetCounters("local")
    else
      abort("Semantic error: variable '#{id}' is already defined. Error on line: #{$line_number}")
    end
  end

  # Método que agrega una nuevo argumento a la funcion actual.
  # Parámetros de entrada:
  # type: tipo de la funcion
  # id: el id del argumento
  # Da de alta el argumento en la tabla de variables de la funcion
  # e incrementa el contador de parametros
  def newArgument(type, id)
    if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] == nil
      unless isValidType(type)
        abort("Semantic error: species '#{type}' is not defined. Error on line: #{$line_number}")
      end
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] = Hash.new
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["type"] = $actualType
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["modifiable"] = $isVariable
      if $actualType == "number" || $actualType == "decimal" || $actualType == "string" || $actualType == "char" || $actualType == "logic"
        $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["location"] = locationGenerator(1, "local", $actualType)
        $speciesBook[$actualSpecies]["methods"][$actualMethod]["size"][$actualType] += 1
      end
      arg = { "location" => $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["location"], "type" => type }
      $speciesBook[$actualSpecies]["methods"][$actualMethod]["argumentList"].push(arg)
    else
      abort("Semantic error: argument '#{id}' is already defined in method '#{$actualMethod}'. Error on line: #{$line_number}")
    end
  end

  # Método que checa los tipos de 2 operandos
  # con el cubo semantico.
  def expressionResultType(operator, leftOp, rightOp)
    if $semanticCube[leftOp][rightOp][operator] == nil
      abort("Semantic error: type mismatch. Cannot combine type '#{leftOp}' and type '#{rightOp}' with operator '#{operator}'. Error on line: #{$line_number}")
    end
    return $semanticCube[leftOp][rightOp][operator]
  end

  # Método que da de alta una constante en la
  # tabla de constantes
  def newConstant(type, value)
    if $constantBook[value] == nil
      $constantBook[value] = locationGenerator(1, "constant", type)
    end
    return $constantBook[value]
  end


  # Método que genera direcciones de memoria segun
  # el scope, el tipo y el tamaño de la variable
  def locationGenerator(size, scope, type)
    if $theMagicNumber - $magicCounter[scope][type] >= size
      location = $magicReference[scope][type] * $theMagicNumber + $magicCounter[scope][type]
      $magicCounter[scope][type] += size
      return location
    else
      abort("Compilation error: out of memory for a #{type} variable with the #{scope} scope. While compiling line: #{$line_number}")
    end
  end

  def resetCounters(scope)
    $magicCounter[scope]["number"] = 0
    $magicCounter[scope]["decimal"] = 0
    $magicCounter[scope]["string"] = 0
    $magicCounter[scope]["char"] = 0
    $magicCounter[scope]["logic"] = 0
  end

  def createExpressionQuadruple(operator, leftOp, rightOp, tempType)
    temporal = locationGenerator(1, "temporal", tempType)
    quadruple = [operator, leftOp, rightOp, temporal]
    $quadrupleVector.push(quadruple)
    return temporal
  end

  def createAssignQuadruple(operator, leftOpHash, rightOpHash)
    expressionResultType(operator, leftOpHash[0], rightOpHash[0])
    quadruple = [operator, nil, rightOpHash[1], leftOpHash[1]]
    $quadrupleVector.push(quadruple)
  end

  def createNotQuadruple(opHash)
    abort("Semantic error: you cannot negate a non-logic expression with '!'. Error on line: #{$line_number}") unless opHash[0] == "logic"
    result = locationGenerator(1, "temporal", "logic")
    quadruple = ["!", nil, opHash[1], result]
    $quadrupleVector.push(quadruple)
    return result
  end

  def createNegateExp(exp)
    abort("Semantic error: you cannot negate a non-numeric expression with '-'. Error on line: #{$line_number}") unless exp[0] == "number"
    result = locationGenerator(1, "temporal", "number")
    quadruple = ["negate", nil, exp[1], result]
    $quadrupleVector.push(quadruple)
    return result
  end

  # Metódo que regresa la ubicación de una variable en memoria
  # segun su id
  def retrieveIdLocation(id)
    if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] != nil
      return $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["location"]
    elsif idLocationRecursively($speciesBook[$actualSpecies], id) != nil
      return idLocationRecursively($speciesBook[$actualSpecies], id)
    else
      abort("Semantic error: variable '#{id}' not declared. Error on line: #{$line_number}")
    end
  end

  # Metódo que regresa el tipo de una variable
  # segun su id
  def retrieveIdType(id)
    if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] != nil
      return $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["type"]
    elsif idTypeRecursively($speciesBook[$actualSpecies], id) != nil
      return idTypeRecursively($speciesBook[$actualSpecies], id)
    else
      abort("Semantic error: variable '#{id}' not declared. Error on line: #{$line_number}")
    end
  end

  # Metódo que regresa el hash con todas las dimensiones
  # de una varible segun su id
  def retrieveIdDimensions(id)
    if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] != nil
      return $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["dimensions"]
    elsif idDimensionsRecursively($speciesBook[$actualSpecies], id) != nil
      return idDimensionsRecursively($speciesBook[$actualSpecies], id)
    else
      abort("Semantic error: dimensioned variable '#{id}' not declared. Error on line: #{$line_number}")
    end
  end

  def generateLogicControlQuadruple(exp, goToType)
    unless exp[0] == "logic"
      abort("Semantic error: type mismatch. Control expression is not logic type. Error on line: #{$line_number}")
    end
    action = "gotoF"
    if goToType
      action = "gotoT"
    end
    quadruple = [action, exp[1], nil, nil]
    $quadrupleVector.push(quadruple)
    $jumpStack.push($quadrupleVector.count()-1)
  end

  def generateDoWhileQuadruple(exp)
    unless exp[0] == "logic"
      abort("Semantic error: type mismatch. Control expression is not logic type. Error on line: #{$line_number}")
    end
    retorno = $jumpStack.pop()
    quadruple = ["gotoV", exp[1], nil, retorno]
    $quadrupleVector.push(quadruple)
  end

  def endWhile()
    aux = $jumpStack.pop(2)
    quadruple = ["goto", nil, nil, aux[0]]
    $quadrupleVector.push(quadruple)
    fillQuadruple(aux[1])
  end

  def endIf()
    while $jumpStack.last() != "if" do
      fillQuadruple($jumpStack.pop())
    end
    $jumpStack.pop()
  end

  def generateElse()
    quadruple = ["goto", nil, nil, nil]
    $quadrupleVector.push(quadruple)
    fillQuadruple($jumpStack.pop())
    $jumpStack.push($quadrupleVector.count()-1)
  end

  def fillQuadruple(index)
    $quadrupleVector[index][3] = $quadrupleVector.count()
  end

  def endFunk(exp)
    type = $speciesBook[$actualSpecies]["methods"][$actualMethod]["type"]
    abort("Semantic error: type mismatch in reply expression. Error on line: #{$line_number}") if type != exp[0] && exp[0] != nil
    abort("Semantic error: oblivion funks cannot have reply. Error on line: #{$line_number}") if type == "oblivion" && exp[0] != nil
    if $actualMethod != "chief"
      $quadrupleVector.push(["return", nil, nil, exp[1]])
    else
      $quadrupleVector.push(["terminate", nil, nil, exp[1]])
    end
  end

  # Método que se encarga de validar que una funcion haya sido
  # llamada correctamente
  def validateFunk()
    if $argumentCount != 0
      $argumentCountStack.push($argumentCount)
    end
    $argumentCount = 0
    $funkGlobalContext = false
    if $actualIdSpecies == nil
      $actualIdSpecies = $actualSpecies
      $funkGlobalContext = true
    end
    $speciesStack.push($actualIdSpecies)
    $idStack.push($actualIdFunk)
    funkHash = speciesHashOfFunkRecursively($speciesBook[$actualIdSpecies], $actualIdFunk)
    if funkHash != nil
      if funkHash["scope"] || $funkGlobalContext
        return funkHash["type"]
      else
        abort("Semantic error: method #{$actualIdFunk} is not open. Error on line: #{$line_number}")
      end
    else
      abort("Semantic error: method #{$actualIdFunk} not defined. Error on line: #{$line_number}")
    end
  end

  def generateArg(argument)
    funkHash = speciesHashOfFunkRecursively($speciesBook[$actualIdSpecies], $actualIdFunk)
    if $argumentCount >= funkHash["argumentList"].count()
      abort("Semantic error: wrong number of arguments for function #{$actualIdFunk}. Error on line: #{$line_number}")
    end
    expected = funkHash["argumentList"][$argumentCount]["type"]
    if expected == argument[0]
      quadruple = ["param", argument[1], [($argumentCount+1), funkHash["argumentList"].count], funkHash["argumentList"][$argumentCount]["location"]]
      $quadrupleVector.push(quadruple)
      $argumentCount += 1
    else
      abort("Semantic error: argument type mismatch in #{$actualIdFunk}, expected: '#{expected}' actual: '#{argument[0]}'. Error on line: #{$line_number}")
    end
  end

  def endFunkCall
    funkHash = speciesHashOfFunkRecursively($speciesBook[$actualIdSpecies], $actualIdFunk)
    if $argumentCount == funkHash["argumentList"].count()
      if $funkGlobalContext
        sendAttributesDirectly()
      else
        sendAttributes()
      end
      typeDir = funkHash["type"]
      if typeDir == "oblivion"
        typeDir = nil
      else
        typeDir = locationGenerator(1, "local", typeDir)
      end
      quadruple = ["gosub", funkHash["begin"], nil, typeDir]
      $quadrupleVector.push(quadruple)
      $speciesStack.pop
      $idStack.pop
      if $argumentCountStack.empty?
        $argumentCount = 0
      else
        $argumentCount = $argumentCountStack.pop
      end
      return typeDir
    else
      abort("Semantic error: wrong number of arguments for function #{$actualIdFunk}. Error on line: #{$line_number}")
    end
  end

  def createAtributtesRecursively(id, speciesHash)
    createAtributtesRecursively(id, speciesHash["father"]) if speciesHash["father"] != nil
    auxSpecies = $actualSpecies
    speciesHash["variables"].each do |key, h|
      $actualType = h["type"]
      $actualModifier = h["scope"]
      $isVariable = h["modifiable"]
      newVariable(id+"."+key)
    end
    $actualSpecies = auxSpecies
    $actualType = $speciesBook[$actualSpecies]["variables"][id]["type"]
    $actualModifier = $speciesBook[$actualSpecies]["variables"][id]["scope"]
    $isVariable = $speciesBook[$actualSpecies]["variables"][id]["modifiable"]
  end

  def validateAttribute(id)
    unless $speciesBook[$actualSpecies]["variables"][id]["scope"]
      attribute = id.split(".").last
      abort("Semantic error: attribute #{attribute} is not open. Error on line: #{$line_number}")
    end
  end

  # Método que se encarga de mandar todos los atributos
  # de la clase correspondiente al iniciar la llamada a una funcion
  def sendAttributes()
    $speciesBook[$actualSpecies]["variables"].each do |key, h|
      tokens = key.split(".")
      type = h["type"]
      isPrimitive = type == "number" || type == "decimal" || type == "char" || type == "string" || type == "logic"
      if tokens[0] == $actualId && tokens.count > 1 && isPrimitive
        destination = idLocationRecursively($speciesBook[$speciesBook[$actualSpecies]["variables"][tokens[0]]["type"]], key[key.index(".")+1..-1])
        quadruple = ["SEND_ATTR", destination, nil, h["location"]]
        $quadrupleVector.push(quadruple)
        if h["totalsize"] != nil
          for index in 1..h["totalsize"]-1
            quadruple = ["SEND_ATTR", destination, nil, h["location"]+index]
            $quadrupleVector.push(quadruple)
          end
        end
      end
    end
  end

  def sendAttributesDirectly()
    iterateClassVariablesRecursively($speciesBook[$actualSpecies])
  end

  def iterateClassVariablesRecursively(speciesHash)
    if speciesHash["father"] != nil
      iterateClassVariablesRecursively(speciesHash["father"])
    else
      speciesHash["variables"].each do |key, h|
        type = h["type"]
        isPrimitive = type == "number" || type == "decimal" || type == "char" || type == "string" || type == "logic"
        if isPrimitive
          quadruple = ["SEND_ATTR", h["location"], nil, h["location"]]
          $quadrupleVector.push(quadruple)
          if h["totalsize"] != nil
            for index in 1..h["totalsize"]-1
              quadruple = ["SEND_ATTR", h["location"]+index, nil, h["location"]+index]
              $quadrupleVector.push(quadruple)
            end
          end
        end
      end
    end
  end

  def speciesHashOfFunkRecursively(species, id)
    if species["methods"][id] != nil # regresa si la variable ya existe
      return species["methods"][id]
    elsif species["father"] == nil  # si la clase no tiene padre
      return nil
    else
      return speciesHashOfFunkRecursively(species["father"], id) # checa para su padre
    end
  end

  def idLocationRecursively(species, id)
    if species["variables"][id] != nil # regresa si la variable ya existe
      return species["variables"][id]["location"]
    elsif species["father"] == nil  # si la clase no tiene padre
      return nil
    else
      return idLocationRecursively(species["father"], id) # checa para su padre
    end
  end

  def idTypeRecursively(species, id)
    if species["variables"][id] != nil # regresa si la variable ya existe
      return species["variables"][id]["type"]
    elsif species["father"] == nil  # si la clase no tiene padre
      return nil
    else
      return idTypeRecursively(species["father"], id) # checa para su padre
    end
  end

  def idDimensionsRecursively(species, id)
    if species["variables"][id] != nil # regresa si la variable ya existe
      return species["variables"][id]["dimensions"]
    elsif species["father"] == nil  # si la clase no tiene padre
      return nil
    else
      return idDimensionsRecursively(species["father"], id) # checa para su padre
    end
  end

  def startArrayIndex()
    dim = retrieveIdDimensions($actualId)
    if dim != nil
      arrIndex = Hash.new
      arrIndex["dimensions"] = dim
      arrIndex["location"] = retrieveIdLocation($actualId)
      arrIndex["index"] = -1
      $arrayIndexStack.push(arrIndex)
    end
  end

  # Método que valida que genera los cuadruplos necesarios
  # para validar el rango de una llamada a un arreglo
  # y las operaciones necesarias del indexamiento
  def newDimensionIndex(index)
    abort("Semantic error: you can only use numbers to refer a dimension index. Error on line: #{$line_number}") unless index[0] == "number"
    $arrayIndexStack.last["index"] += 1
    abort("Semantic error: wrong nunmber of dimensions, the variable you're accessing has less dimensions. Error on line: #{$line_number}") unless $arrayIndexStack.last["index"] < $arrayIndexStack.last["dimensions"].count
    sl = $arrayIndexStack.last["dimensions"][$arrayIndexStack.last["index"]]["sl"]
    il = $arrayIndexStack.last["dimensions"][$arrayIndexStack.last["index"]]["il"]
    $quadrupleVector.push(["verify", sl, il, index[1]])
    temp = -1
    if $arrayIndexStack.last["index"] != $arrayIndexStack.last["dimensions"].count - 1
      temp = locationGenerator(1,"temporal","number")
      $quadrupleVector.push(["*SpecialRight", index[1], $arrayIndexStack.last["dimensions"][$arrayIndexStack.last["index"]]["m"], temp])
      if $arrayIndexStack.last["index"] > 0
        aux = temp
        temp = locationGenerator(1,"temporal","number")
        $quadrupleVector.push(["+", aux, $arrayIndexStack.last["temporal"], temp])
        $arrayIndexStack.last["temporal"] = temp
      end
    elsif $arrayIndexStack.last["index"] > 0
      temp = locationGenerator(1,"temporal","number")
      $quadrupleVector.push(["+", index[1], $arrayIndexStack.last["temporal"], temp])
      $arrayIndexStack.last["temporal"] = temp
    else
      temp = index[1]
    end
    $arrayIndexStack.last["temporal"] = temp
  end

  def endArrayAccess()
     abort("Semantic error: wrong nunmber of dimensions, the variable you're accessing has more dimensions. Error on line: #{$line_number}") unless $arrayIndexStack.last["index"] == $arrayIndexStack.last["dimensions"].count - 1
     temp = locationGenerator(1,"temporal","number")
     $quadrupleVector.push(["+SpecialRight", $arrayIndexStack.last["temporal"], $arrayIndexStack.last["dimensions"][$arrayIndexStack.last["index"]]["k"], temp])
     aux = temp
     temp = locationGenerator(1,"temporal","number")
     $quadrupleVector.push(["+SpecialRight", aux, $arrayIndexStack.last["location"], temp])
     $arrayIndexStack.pop
     return temp.to_f
  end

  def terminateCompilation()
    $constantBook.each do |key, value|
      $constantCounterBook[value] = key
    end
    File.open('constants.yaml', 'w') { |fo| fo.puts $constantCounterBook.to_yaml }
    File.open('quadruples.yaml', 'w') { |fo| fo.puts $quadrupleVector.to_yaml }
  end

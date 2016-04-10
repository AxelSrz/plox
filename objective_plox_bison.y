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
    plox_generation                                   { puts "OP! Programa compilado exitosamente."; ap $speciesBook; ap $quadrupleVector}

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
    variable_is_modifiable variable_scope type some_variables SEMIC            {}

  variable_scope:
    /* empty */                                       {}
    | modifier                                        {}

  variable_is_modifiable:
    VAR                                               { $actualModifier = false; $isVariable = true }
    | ETERNAL                                         { $actualModifier = false; $isVariable = false }

  some_variables:
    code_new_variable next_variable                   {}

  code_new_variable:
    ID  { newVariable(val[0][0]) }

  next_variable:
    /* empty */                                       {}
    | COMA some_variables                      {}

  type:
    type_specifier type1                              {}

  type1:
    /* empty */                                       {}
    | type2                                           {}

  type2:
    SBLEFT expression SBRIGHT type1           {}

  variable_assignment:
    ID variable_assignment1 EQUAL variable_value          { createAssignQuadruple(val[2][0], val[0], val[3]) }
    | ID variable_assignment1 PLUSASSIGN variable_value   { createAssignQuadruple(val[2][0], val[0], val[3]) }
    | ID variable_assignment1 MINUSASSIGN variable_value  { createAssignQuadruple(val[2][0], val[0], val[3]) }
    | ID variable_assignment1 MULTASSIGN variable_value   { createAssignQuadruple(val[2][0], val[0], val[3]) }
    | ID variable_assignment1 DIVASSIGN variable_value    { createAssignQuadruple(val[2][0], val[0], val[3]) }
    | ID variable_assignment1 ORASSIGN variable_value     { createAssignQuadruple(val[2][0], val[0], val[3]) }
    | ID variable_assignment1 ANDASSIGN variable_value    { createAssignQuadruple(val[2][0], val[0], val[3]) }
    | ID variable_assignment1 MODASSIGN variable_value    { createAssignQuadruple(val[2][0], val[0], val[3]) }


  variable_assignment1:
    /* empty */                                       {}
    | variable_assignment4 variable_assignment5       {}


  variable_assignment4:
    SBLEFT expression SBRIGHT variable_assignment5      {}

  variable_assignment5:
    /* empty */                                       {}
    | variable_assignment4                            {}

  method_declaration:
    new_function_code method_declaration1 type method_declaration2 PLEFT method_declaration3 PRIGHT method_declaration4    { endFunk() }

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

  variable_value:
    expression                                        {}
    | HEAR PLEFT PRIGHT                               {}

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
    NULL                                              {}
    | ITSELF                                          {}
    | ID                                              { val[0][1] = retrieveIdLocation(val[0][0]); val[0][0] = retrieveIdType(val[0][0]) }
    | reference_expression2                           {}

  reference_expression2:
    reference_expression reference_expression5        {}

  reference_expression5:
    PLEFT reference_expression6 PRIGHT                {}
    | SBLEFT expression SBRIGHT                       {}
    | POINT reference_expression                      {}

  reference_expression6:
    /* empty */                                       {}
    | arglist                                         {}

  parameter:
    type ID parameter1                                { newArgument(val[0][0], val[1][0]) }

  parameter1:
    /* empty */                                       {}
    | SBLEFT SBRIGHT parameter1                       {}

  statement:
    variable_assignment SEMIC                         {}
    | SAY PLEFT expression PRIGHT SEMIC                                {}
    | unless_statement                                {}
    | if_statement                                    {}
    | do_statement                                    {}
    | while_statement                                 { endWhile() }
    | REPLY expression SEMIC                          {}

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
    | NOT expression                         { val[0][1] = createNotQuadruple(val[0]) }
    | expression AND expression              { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | expression OR expression               { val[0][0] = expressionResultType(val[1][0], val[0][0], val[2][0]); val[0][1] = createExpressionQuadruple(val[1][0], val[0][1], val[2][1], val[0][0]) }
    | TRUE                                   { val[0][1] = $trueLocation }
    | FALSE                                  { val[0][1] = $falseLocation }
    | PLEFT expression PRIGHT                { val[0][0] = val[1][0]; val[0][1] = val[1][1] }
    | literal_expression                              {}
    | reference_expression                            {}

  arglist:
    expression arglist1                               {}

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

  require_relative 'lexer'  # Se agrega el lexer al programa de racc.
  require "awesome_print"
  $line_number = 0          # Se inicializa la variable que guarda el numero de linea en la cual se encuentra el error.
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
---- inner

  # Se importa esta funcion perteneciente a la gema de racc. Se realiza una modificacion
  # Funcion que lee un archivo como entrada.
  def parse(input)
    scan_file(input)
  end

  # para poder desplegar la linea en la que se encuentra el error.
  def on_error(t, val, vstack)
    raise ParseError, sprintf("\nParsing error on value %s (%s) found on line: %i", val[0].inspect, token_to_str(t) || '?', $line_number)
  end

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

  def heirSpecies(father)
    if $speciesBook[father] != nil
      $speciesBook[$actualSpecies]["father"] = $speciesBook[father]
    else
      abort("Semantic error: '#{father}' father of species '#{$actualSpecies}' is not defined. Error on line: #{$line_number}")
    end
  end

  def newVariable(id)
    if $actualMethod == "species"
      unless idDeclaredInSpeciesRecursively($speciesBook[$actualSpecies], id, "variables")
        unless isValidType($actualType)
          abort("Semantic error: species '#{$actualType}' is not defined. Error on line: #{$line_number}")
        end
        if $actualType == $actualSpecies
          abort("Semantic error: you cannot have recursive species definitions. Error on line: #{$line_number}")
        end
        $speciesBook[$actualSpecies]["variables"][id] = Hash.new
        $speciesBook[$actualSpecies]["variables"][id]["type"] = $actualType
        $speciesBook[$actualSpecies]["variables"][id]["scope"] = $actualModifier
        $speciesBook[$actualSpecies]["variables"][id]["modifiable"] = $isVariable
        if $actualType == "number" || $actualType == "decimal" || $actualType == "string" || $actualType == "char" || $actualType == "logic"
          $speciesBook[$actualSpecies]["variables"][id]["location"] = locationGenerator(1, "global", $actualType)
          $speciesBook[$actualSpecies]["size"][$actualType] += 1
        end
      else
        abort("Semantic error: variable '#{id}' is already defined. Error on line: #{$line_number}")
      end
    else
      if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] == nil
        unless isValidType($actualType)
          abort("Semantic error: species '#{$actualType}' is not defined. Error on line: #{$line_number}")
        end
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
  end

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

  def newMethod(id)
    unless idDeclaredInSpeciesRecursively($speciesBook[$actualSpecies], id, "methods")
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

  def expressionResultType(operator, leftOp, rightOp)
    # puts "Cube call with leftOp: #{leftOp}, rightOp: #{rightOp} and operator: #{operator} on line: #{$line_number}"
    if $semanticCube[leftOp][rightOp][operator] == nil
      abort("Semantic error: type mismatch. Cannot combine type '#{leftOp}' and type '#{rightOp}' with operator '#{operator}'. Error on line: #{$line_number}")
    end
    return $semanticCube[leftOp][rightOp][operator]
  end

  def newConstant(type, value)
    if $constantBook[value] == nil
      $constantBook[value] = locationGenerator(1, "constant", type)
    end
    return $constantBook[value]
  end

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
    # puts "Assign Q leftOp: #{leftOpHash}, rightOp: #{rightOpHash} and operator: #{operator} on line: #{$line_number}"
    leftOp = retrieveIdLocation(leftOpHash[0])
    leftOpType = retrieveIdType(leftOpHash[0])
    expressionResultType(operator, leftOpType, rightOpHash[0])
    if rightOpHash[0] == "hear"
      quadruple = [operator, nil, rightOpHash[0], leftOp]
    else
      quadruple = [operator, nil, rightOpHash[1], leftOp]
    end
    $quadrupleVector.push(quadruple)
  end

  def createNotQuadruple(opHash)
    if opHash[0] == "logic"
      result = locationGenerator(1, "temporal", "logic")
      quadruple = ["!", nil, opHash[1], result]
      return result
    else
      abort("Semantic error: type mismatch. Cannot negate non-logic values ('#{opHash[0]}'). Error on line: #{$line_number}")
    end
  end

  def retrieveIdLocation(id)
    if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] != nil
      return $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["location"]
    elsif $speciesBook[$actualSpecies]["variables"][id] != nil
      return $speciesBook[$actualSpecies]["variables"][id]["location"]
    else
      abort("Semantic error: variable '#{id}' not declared. Error on line: #{$line_number}")
    end
  end

  def retrieveIdType(id)
    if $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id] != nil
      return $speciesBook[$actualSpecies]["methods"][$actualMethod]["variables"][id]["type"]
    elsif $speciesBook[$actualSpecies]["variables"][id] != nil
      return $speciesBook[$actualSpecies]["variables"][id]["type"]
    else
      abort("Semantic error: variable '#{id}' not declared. Error on line: #{$line_number}")
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

  def endFunk()
    if $actualMethod != "chief"
      $quadrupleVector.push(["return", nil, nil, nil])
    else
      $quadrupleVector.push(["terminate", nil, nil, nil])
    end
  end

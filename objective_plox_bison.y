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
    plox_generation                                   { puts "OP! Programa compilado exitosamente." }

  plox_generation:
    /* empty */                                       {}
    | type_declaration plox_generation                {}

  type_declaration:
    HABEMVS class_declaration SEMIC                   {}

  class_declaration:
    SPECIES code_new_class code_heirof BLEFT class_body BRIGHT      {}

  code_new_class:
    ID { newSpecies(val[0]) }

  code_heirof:
    /* empty */                                       {}
    | HEIROF ID                                       { heirSpecies(val[1]) }

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
    VAR                                               { $actualModifier = true; $isVariable = true }
    | ETERNAL                                         { $actualModifier = true; $isVariable = false }

  some_variables:
    code_new_variable next_variable                   {}

  code_new_variable:
    ID  { }

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
    ID variable_assignment1 assign_operator variable_value      {}

  variable_assignment1:
    /* empty */                                       {}
    | variable_assignment4 variable_assignment5       {}

  assign_operator:
    EQUAL                                             {}
    | PLUSASSIGN
    | MINUSASSIGN
    | MULTASSIGN
    | DIVASSIGN
    | ORASSIGN
    | ANDASSIGN
    | MODASSIGN

  variable_assignment4:
    SBLEFT expression SBRIGHT variable_assignment5      {}

  variable_assignment5:
    /* empty */                                       {}
    | variable_assignment4                            {}

  method_declaration:
    FUNK method_declaration1 type method_declaration2 PLEFT method_declaration3 PRIGHT method_declaration4          {}

  method_declaration1:
    /* empty */                                       {}
    | modifier                                        {}

  method_declaration2:
    ID                                                {}
    | CHIEF                                           {}

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
    | ID                                              { $actualType = "object" }
    | OBLIVION                                        { $actualType = "oblivion" }
    | STRING                                          { $actualType = "string" }

  num_operator:
    MULT                                              {}
    | DIV                                             {}
    | MOD                                             {}
    | PLUS                                            {}
    | MINUS                                           {}

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
    | ID                                              {}
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
    type ID parameter1                                {}

  parameter1:
    /* empty */                                       {}
    | parameter2                                      {}

  parameter2:
    SBLEFT expression SBRIGHT parameter3              {}

  parameter3:
    /* empty */                                       {}
    | parameter2                                      {}

  statement:
    variable_assignment SEMIC                         {}
    | SAY PLEFT expression PRIGHT SEMIC               {}
    | expression SEMIC                                {}
    | statement_block                                 {}
    | unless_statement                                {}
    | if_statement                                    {}
    | do_statement                                    {}
    | while_statement                                 {}
    | REPLY statement1 SEMIC                          {}
    | SEMIC                                           {}

  statement1:
    /* empty */                                       {}
    | expression

  expression:
    expression num_operator expression                {}
    | expression testing_operator expression          {}
    | NOT expression                                  {}
    | expression boolean_operator expression          {}
    | TRUE                                            {}
    | FALSE                                           {}
    | PLEFT expression PRIGHT                         {}
    | literal_expression                              {}
    | reference_expression                            {}

  arglist:
    expression arglist1                               {}

  arglist1:
    /* empty */                                       {}
    | COMA arglist                                    {}

  unless_statement:
    UNLESS PLEFT expression PRIGHT statement unless_statement1    {}

  unless_statement1:
    /* empty */                                       {}
    | ELSE statement                                  {}

  if_statement:
    IF PLEFT expression PRIGHT statement if_statement1  {}

  if_statement1:
    /* empty */                                       {}
    | ELSE statement                                  {}

  do_statement:
    DO statement WHILE PLEFT expression PRIGHT SEMIC  {}

  while_statement:
    WHILE PLEFT expression PRIGHT statement           {}

  testing_operator:
    MTHAN                                             {}
    | LTHAN                                           {}
    | MEQUAL                                          {}
    | LEQUAL                                          {}
    | EQUALITY                                        {}
    | DIFFERENT                                       {}

  boolean_operator:
    AND                                               {}
    | OR                                              {}

  literal_expression:
    CTED                                              {}
    | CTEN                                            {}
    | CTESTRING                                       {}

end

---- header

  require_relative 'lexer'  # Se agrega el lexer al programa de racc.
  $line_number = 0          # Se inicializa la variable que guarda el numero de linea en la cual se encuentra el error.
  $speciesBook = Hash.new{}
  $actualSpecies
  $actualModifier
  $isVariable
  $actualFunction
  $actualType

---- inner

  # Se importa esta funcion perteneciente a la gema de racc. Se realiza una modificacion
  # Funcion que lee un archivo como entrada.
  def parse(input)
    scan_file(input)
  end

  # para poder desplegar la linea en la que se encuentra el error.
  def on_error(t, val, vstack)
    raise ParseError, sprintf("\nParsing error on value %s (%s) found on line: %i", val.inspect, token_to_str(t) || '?', $line_number)
  end

  def newSpecies(species)
    if $speciesBook[species] == nil
      $speciesBook[species] = Hash.new
      $speciesBook[species]["global"] = Hash.new
      $speciesBook[species]["global"]["methods"] = Hash.new
      $speciesBook[species]["global"]["variables"] = Hash.new
      $speciesBook[species] = Hash.new
      $actualSpecies = species
      $actualFunction = "global"
      puts "species #{species} successfully defined"
    else
      abort("Semantic error: species '#{species}' is already defined. Error on line: #{$line_number}")
    end
  end

  def heirSpecies(father)
    if $speciesBook[father] != nil
      $speciesBook[$actualSpecies] = $speciesBook[father].clone
      puts "successful heiring from #{father}"
    else
      abort("Semantic error: '#{father}' father of species '#{$actualSpecies}' is not defined. Error on line: #{$line_number}")
    end
  end

  def newVariable(id)
    if $speciesBook[$actualSpecies][$actualFunction]["variables"][id] == nil
      $speciesBook[$actualSpecies][$actualFunction]["variables"][id] = Hash.new
      $speciesBook[$actualSpecies][$actualFunction]["variables"][id]["type"] = $actualType
    else
      abort("Error, variable '#{id}' is already defined. Error on line: #{$line_number}")
    end
  end

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
  plox_generation:
    /* empty */                                       {}
    | type_declaration plox_generation                { puts "OP! Programa compilado exitosamente." }

  type_declaration:
    HABEMVS class_declaration SEMIC                   {}

  class_declaration:
    SPECIES ID class_declaration2 BLEFT class_declaration3 BRIGHT      {}

  class_declaration2:
    /* empty */                                       {}
    | HEIROF ID                                       {}

  class_declaration3:
    class_declaration4 class_declaration5             {}

  class_declaration4:
    /* empty */                                       {}
    | variable_declaration class_declaration4         {}

  class_declaration5:
    /* empty */                                       {}
    | method_declaration class_declaration5            {}

  modifier:
    OPEN                                              {}
    | HIDDEN                                          {}

  variable_declaration:
    variable_declaration2 variable_declaration1 type variable_declaration3 SEMIC            {}

  variable_declaration1:
    /* empty */                                       {}
    | modifier                                        {}

  variable_declaration2:
    VAR                                               {}
    | ETERNAL                                         {}

  variable_declaration3:
    ID variable_declaration4                          {}

  variable_declaration4:
    /* empty */                                       {}
    | COMA variable_declaration3                      {}

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
    EQUAL
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
    LOGIC                                             {}
    | CHAR                                            {}
    | NUMBER                                          {}
    | DECIMAL                                         {}
    | ID                                              {}
    | OBLIVION                                        {}
    | STRING                                          {}

  num_operator:
    MULT                                              {}
    | DIV                                             {}
    | MOD                                             {}
    | PLUS                                            {}
    | MINUS                                           {}

  variable_value:
    expression SEMIC                                  {}
    | HEAR PLEFT PRIGHT SEMIC                         {}

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
    variable_assignment                               {}
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
    expression num_operator expression {}
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

---- inner
  # Se importa esta funcion perteneciente a la gema de racc. Se realiza una modificacion
  # Funcion que lee un archivo como entrada.
  def parse(input)
    scan_file(input)
  end
  # para poder desplegar la linea en la que se encuentra el error.
  def on_error(t, val, vstack)
    raise ParseError, sprintf("\nParsing error on value %s (%s) found on line : %i", val.inspect, token_to_str(t) || '?', $line_number)
  end

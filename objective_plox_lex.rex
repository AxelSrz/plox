require_relative 'parser'

class ObjectivePlox
macro
  BLANK     [\ \t\n\r\f]
rule
  {BLANK}
  [a-zA-Z][a-zA-Z0-9]*   { $line_number = lineno; if text == "habemvs" then return [:HABEMVS, text]
                           elsif text == "oblivion" then return [:OBLIVION, {0 => text}]
                           elsif text == "var" then return [:VAR, {0 => text}]
                           elsif text == "eternal" then return [:ETERNAL, {0 => text}]
                           elsif text == "chief" then return [:CHIEF, {0 => text}]
                           elsif text == "open" then return [:OPEN, {0 => text}]
                           elsif text == "hidden" then return [:HIDDEN, {0 => text}]
                           elsif text == "species" then return [:SPECIES, {0 => text}]
                           elsif text == "null" then return [:NULL, {0 => text}]
                           elsif text == "if" then return [:IF, {0 => text}]
                           elsif text == "else" then return [:ELSE, {0 => text}]
                           elsif text == "while" then return [:WHILE, {0 => text}]
                           elsif text == "do" then return [:DO, {0 => text}]
                           elsif text == "unless" then return [:UNLESS, {0 => text}]
                           elsif text == "true" then return [:TRUE, {0 => "logic", 1 => true}]
                           elsif text == "false" then return [:FALSE, {0 => "logic", 1 => false}]
                           elsif text == "var" then return [:VAR, {0 => text}]
                           elsif text == "say" then return [:SAY, {0 => text}]
                           elsif text == "hear" then return [:HEAR, {0 => text}]
                           elsif text == "itself" then return [:ITSELF, {0 => text}]
                           elsif text == "funk" then return [:FUNK, {0 => text}]
                           elsif text == "eternal" then return [:ETERNAL, {0 => text}]
                           elsif text == "heirof" then return [:HEIROF, {0 => text}]
                           elsif text == "reply" then return [:REPLY, {0 => text}]
                           elsif text == "number" then return [:NUMBER, {0 => text}]
                           elsif text == "decimal" then return [:DECIMAL, {0 => text}]
                           elsif text == "char" then return [:CHAR, {0 => text}]
                           elsif text == "string" then return [:STRING, {0 => text}]
                           elsif text == "logic" then return [:LOGIC, {0 => text}]
                           else return [:ID, {0 => text}] end }
  [0-9]+\.[0-9]+         { [:CTED, {0 => "decimal", 1 => text.to_f}] }
  [0-9]+                 { [:CTEN, {0 => "number", 1 => text.to_i}] }
  ".*"                   { [:CTESTRING, {0 => "string", 1 => text[1...-1]}] }
  !=                     { [:DIFFERENT, {0 => text}] }
  \|\|=                  { [:ORASSIGN, {0 => text}] }
  &&=                    { [:ANDASSIGN, {0 => text}] }
  \+=                    { [:PLUSASSIGN, {0 => text}] }
  \-=                    { [:MINUSASSIGN, {0 => text}] }
  \*=                    { [:MULTASSIGN, {0 => text}] }
  \/=                    { [:DIVASSIGN, {0 => text}] }
  %=                     { [:MODASSIGN, {0 => text}] }
  ==                     { [:EQUALITY, {0 => text}] }
  \<=                    { [:LEQUAL, {0 => text}] }
  \>=                    { [:MEQUAL, {0 => text}] }
  &&                     { [:AND, {0 => text}] }
  \|\|                    { [:OR, {0 => text}] }
  !                      { [:NOT, {0 => text}] }
  %                      { [:MOD, {0 => text}] }
  \*                     { [:MULT, {0 => text}]}
  \/                     { [:DIV, {0 => text}]}
  \+                     { [:PLUS, {0 => text}]}
  \-                     { [:MINUS, {0 => text}] }
  \(                     { [:PLEFT, {0 => text}] }
  \)                     { [:PRIGHT, {0 => text}] }
  \{                     { [:BLEFT, {0 => text}] }
  \}                     { [:BRIGHT, {0 => text}] }
  \[                     { [:SBLEFT, {0 => text}] }
  \]                     { [:SBRIGHT, {0 => text}] }
  :                      { [:TWOP, {0 => text}] }
  ;                      { [:SEMIC, {0 => text}] }
  =                      { [:EQUAL, {0 => text}] }
  ,                      { [:COMA, {0 => text}] }
  \.                     { [:POINT, {0 => text}] }
  \<                     { [:LTHAN, {0 => text}] }
  \>                     { [:MTHAN, {0 => text}] }

inner
  def tokenize(code)
    scan_setup(code)
    tokens = []
    while token = next_token
      tokens << token
    end
    tokens
  end
end

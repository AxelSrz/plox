require_relative 'parser'

class ObjectivePlox
macro
  BLANK     [\ \t\n\r\f]
rule
  {BLANK}
  [a-zA-Z][a-zA-Z0-9]*   { $line_number = lineno; if text == "habemvs" then return [:HABEMVS, text]
                           elsif text == "oblivion" then return [:OBLIVION, text]
                           elsif text == "var" then return [:VAR, text]
                           elsif text == "eternal" then return [:ETERNAL, text]
                           elsif text == "chief" then return [:CHIEF, text]
                           elsif text == "open" then return [:OPEN, text]
                           elsif text == "hidden" then return [:HIDDEN, text]
                           elsif text == "species" then return [:SPECIES, text]
                           elsif text == "fresh" then return [:FRESH, text]
                           elsif text == "null" then return [:NULL, text]
                           elsif text == "if" then return [:IF, text]
                           elsif text == "else" then return [:ELSE, text]
                           elsif text == "while" then return [:WHILE, text]
                           elsif text == "do" then return [:DO, text]
                           elsif text == "unless" then return [:UNLESS, text]
                           elsif text == "true" then return [:TRUE, text]
                           elsif text == "false" then return [:FALSE, text]
                           elsif text == "var" then return [:VAR, text]
                           elsif text == "say" then return [:SAY, text]
                           elsif text == "hear" then return [:HEAR, text]
                           elsif text == "itself" then return [:ITSELF, text]
                           elsif text == "funk" then return [:FUNK, text]
                           elsif text == "eternal" then return [:ETERNAL, text]
                           elsif text == "heirof" then return [:HEIROF, text]
                           elsif text == "reply" then return [:REPLY, text]
                           elsif text == "number" then return [:NUMBER, text]
                           elsif text == "decimal" then return [:DECIMAL, text]
                           elsif text == "char" then return [:CHAR, text]
                           elsif text == "string" then return [:STRING, text]
                           elsif text == "logic" then return [:LOGIC, text]
                           else return [:ID, text] end }
  [0-9]+\.[0-9]+         { [:CTED, text.to_f] }
  [0-9]+                 { [:CTEN, text.to_i] }
  ".*"                 { [:CTESTRING, text] }
  !=                     { [:DIFFERENT, text] }
  \|\|=                  { [:ORASSIGN, text] }
  &&=                    { [:ANDASSIGN, text] }
  \+=                    { [:PLUSASSIGN, text] }
  \-=                    { [:MINUSASSIGN, text] }
  \*=                    { [:MULTASSIGN, text] }
  \/=                    { [:DIVASSIGN, text] }
  %=                     { [:MODASSIGN, text] }
  ==                     { [:EQUALITY, text] }
  \<=                    { [:LEQUAL, text] }
  \>=                    { [:MEQUAL, text] }
  &&                     { [:AND, text] }
  \|\|                    { [:OR, text] }
  !                      { [:NOT, text] }
  %                      { [:MOD, text] }
  \*                     { [:MULT, text]}
  \/                     { [:DIV, text]}
  \+                     { [:PLUS, text]}
  \-                     { [:MINUS, text] }
  \(                     { [:PLEFT, text] }
  \)                     { [:PRIGHT, text] }
  \{                     { [:BLEFT, text] }
  \}                     { [:BRIGHT, text] }
  \[                     { [:SBLEFT, text] }
  \]                     { [:SBRIGHT, text] }
  :                      { [:TWOP, text] }
  ;                      { [:SEMIC, text] }
  =                      { [:EQUAL, text] }
  ,                      { [:COMA, text] }
  \.                     { [:POINT, text] }
  \<                     { [:LTHAN, text] }
  \>                     { [:MTHAN, text] }

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

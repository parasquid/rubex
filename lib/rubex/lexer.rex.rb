# encoding: UTF-8
#--
# This file is automatically generated. Do not modify it.
# Generated by: oedipus_lex version 2.4.1.
# Source: lib/rubex/lexer.rex
#++

class Rubex::Lexer
  require 'strscan'

  DEF        = /def/
  RETURN     = /return/
  PRINT      = /print/
  IF         = /if/
  ELSE       = /else/
  ELSIF      = /elsif/
  THEN       = /then/
  IDENTIFIER = /[a-zA-Z_][a-zA-Z_0-9]*/
  LPAREN     = /\(/
  RPAREN     = /\)/
  NL         = /\n/
  COMMA      = /,/
  SQUOTE     = /'/
  SCOLON     = /;/
  INTEGER    = /-?\d+/
  FLOAT      = /-?\d+\.\d+/
  EXPO       = /\*\*/
  MULTIPLY   = /\*/
  DIVIDE     = /\//
  PLUS       = /\+/
  MINUS      = /\-/
  MODULUS    = /%/
  ASSIGN     = /=/

  class ScanError < StandardError ; end

  attr_accessor :filename
  attr_accessor :ss
  attr_accessor :state

  alias :match :ss

  def matches
    m = (1..9).map { |i| ss[i] }
    m.pop until m[-1] or m.empty?
    m
  end

  def action
    yield
  end


  def scanner_class
    StringScanner
  end unless instance_methods(false).map(&:to_s).include?("scanner_class")

  def parse str
    self.ss     = scanner_class.new str
    self.state  ||= nil

    do_parse
  end

  def parse_file path
    self.filename = path
    open path do |f|
      parse f.read
    end
  end

  def next_token

    token = nil

    until ss.eos? or token do
      token =
        case state
        when nil then
          case
          when text = ss.scan(/'.\'/) then
            action { [:tSINGLE_CHAR, text] }
          when text = ss.scan(/#{FLOAT}/) then
            action { [:tFLOAT, text] }
          when text = ss.scan(/#{INTEGER}/) then
            action { [:tINTEGER, text] }
          when text = ss.scan(/#{DEF}/) then
            action { [:kDEF   , text] }
          when text = ss.scan(/end/) then
            action { [:kEND   , text] }
          when text = ss.scan(/#{RETURN}/) then
            action { [:kRETURN, text] }
          when text = ss.scan(/#{PRINT}/) then
            action { [:kPRINT , text] }
          when text = ss.scan(/#{IF}/) then
            action { [:kIF    , text] }
          when text = ss.scan(/#{ELSIF}/) then
            action { [:kELSIF , text] }
          when text = ss.scan(/#{ELSE}/) then
            action { [:kELSE  , text] }
          when text = ss.scan(/#{THEN}/) then
            action { [:kTHEN  , text] }
          when text = ss.scan(/unsigned long long int/) then
            action { [:kDTYPE_ULLINT, text] }
          when text = ss.scan(/unsigned long int/) then
            action { [:kDTYPE_ULINT, text] }
          when text = ss.scan(/unsigned int/) then
            action { [:kDTYPE_UINT, text] }
          when text = ss.scan(/long int/) then
            action { [:kDTYPE_LINT, text] }
          when text = ss.scan(/long long int/) then
            action { [:kDTYPE_LLINT, text] }
          when text = ss.scan(/char/) then
            action { [:kDTYPE_CHAR, text] }
          when text = ss.scan(/i8/) then
            action { [:kDTYPE_I8, text] }
          when text = ss.scan(/i16/) then
            action { [:kDTYPE_I16, text] }
          when text = ss.scan(/i32/) then
            action { [:kDTYPE_I32, text] }
          when text = ss.scan(/i64/) then
            action { [:kDTYPE_I64, text] }
          when text = ss.scan(/u8/) then
            action { [:kDTYPE_UI8, text] }
          when text = ss.scan(/u16/) then
            action { [:kDTYPE_UI16, text] }
          when text = ss.scan(/u32/) then
            action { [:kDTYPE_UI32, text] }
          when text = ss.scan(/u64/) then
            action { [:kDTYPE_UI64, text] }
          when text = ss.scan(/int/) then
            action { [:kDTYPE_INT, text] }
          when text = ss.scan(/f32/) then
            action { [:kDTYPE_F32, text] }
          when text = ss.scan(/float/) then
            action { [:kDTYPE_F32, text] }
          when text = ss.scan(/f64/) then
            action { [:kDTYPE_F64, text] }
          when text = ss.scan(/double/) then
            action { [:kDTYPE_F64, text] }
          when text = ss.scan(/object/) then
            action { [:kDTYPE_ROBJ, text] }
          when text = ss.scan(/#{IDENTIFIER}/) then
            action { [:tIDENTIFIER, text] }
          when text = ss.scan(/#{LPAREN}/) then
            action { [:tLPAREN, text] }
          when text = ss.scan(/#{RPAREN}/) then
            action { [:tRPAREN, text] }
          when text = ss.scan(/#{COMMA}/) then
            action { [:tCOMMA, text] }
          when text = ss.scan(/#{SCOLON}/) then
            action { [:tSCOLON, text] }
          when text = ss.scan(/#{NL}/) then
            action { [:tNL, text] }
          when text = ss.scan(/#{PLUS}/) then
            action { [:tPLUS, text]}
          when text = ss.scan(/#{MINUS}/) then
            action { [:tMINUS, text]}
          when text = ss.scan(/#{MULTIPLY}/) then
            action { [:tMULTIPLY, text]}
          when text = ss.scan(/#{DIVIDE}/) then
            action { [:tDIVIDE, text]}
          when text = ss.scan(/#{EXPO}/) then
            action { [:tEXPO, text]}
          when text = ss.scan(/#{MODULUS}/) then
            action { [:tMODULUS, text]}
          when text = ss.scan(/#{EXPO}/) then
            action { [:tEXPO, text]}
          when text = ss.scan(/#{ASSIGN}/) then
            action { [:tASSIGN, text] }
          when ss.skip(/^\n\s*$/) then
            # do nothing
          when ss.skip(/\s+/) then
            # do nothing
          else
            text = ss.string[ss.pos .. -1]
            raise ScanError, "can not match (#{state.inspect}): '#{text}'"
          end
        else
          raise ScanError, "undefined state: '#{state}'"
        end # token = case state

      next unless token # allow functions to trigger redo w/ nil
    end # while

    raise "bad lexical result: #{token.inspect}" unless
      token.nil? || (Array === token && token.size >= 2)

    # auto-switch state
    self.state = token.last if token && token.first == :state

    token
  end # def next_token
    def do_parse
    end
end # class

   # Rubex::Lexer

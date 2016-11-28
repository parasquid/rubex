module Rubex
  class CodeWriter
    attr_reader :code

    def initialize target_name
      @code = "/* C extension for #{target_name}.\n"\
                 "This file in generated by Rubex. Do not change!\n"\
               "*/\n"
      @indent = 0
    end

    def write_func_declaration return_type, c_name, args=""
      write_func_prototype return_type, c_name, args
      @code << ";"
      new_line
    end

    def write_func_definition_header return_type, c_name, args=""
      write_func_prototype return_type, c_name, args
      @code << "\n"
      @code << "{\n"
    end

    def declare_variable var
      @code << "#{var.type.to_s} #{var.c_name};\n"
    end
    
    def << s
      @code << s
    end

    def new_line
      @code << "\n"
    end
    alias :nl :new_line

    def indent
      @indent += 1
    end

    def dedent
      raise "Cannot dedent, already 0." if @indent == 0
      @indent -= 1
    end

    def define_instance_method_under scope, name, c_name
      @code << "rb_define_method(" + scope.c_name + " ,\"" + name + "\", " + 
        c_name + ", -1);\n"
    end

    def to_s
      @code
    end

  private

    def write_func_prototype return_type, c_name, args
      @code << "#{return_type} #{c_name} "
      @code << "("
      if args.empty?
        @code << "int argc, VALUE* argv, VALUE #{Rubex::ARG_PREFIX}self"
      else
        @code << args
      end
      @code << ")"      
    end
  end
end
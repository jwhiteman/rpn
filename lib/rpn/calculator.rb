module RPN
  class Calculator
    class InvalidExpression < Exception;end

    NUMERIC        = /\A-?\d+(\.\d+)?\Z/
    OPERATOR       = /\A[*+-\\]\Z/
    ADDITION       = /\+/
    SUBTRACTION    = /-/
    MULTIPLICATION = /\*/
    DIVISION       = /\//
    DECIMAL_POINT  = /\./
    ETOK           = "invalid token".freeze
    EOPD           = "not enough operands".freeze
    EOPR           = "invalid operator".freeze

    attr_reader :stack

    def initialize
      @stack = []
    end

    def eval(expr)
      expr.split.map { |token| eval_token(token) }.last
    end

    def eval_token(token)
      if numeric?(token)
        eval_numeric(token)
      elsif operator?(token)
        eval_operator(token)
      else
        raise InvalidExpression, ETOK
      end
    end

    def eval_numeric(str_num)
      to_number(str_num).tap do |num|
        push(num)
      end
    end

    def operands
      if stack.length < 2
        raise InvalidExpression, EOPD
      else
        stack.pop(2)
      end
    end

    def eval_operator(operator)
      case operator
      when ADDITION
        do_add
      when SUBTRACTION
        do_subtraction
      when MULTIPLICATION
        do_multiplication
      when DIVISION
        do_division
      else
        raise InvalidExpression, EOPR
      end
    end

    def do_add
      do_operation { |left, right| left + right }
    end

    def do_subtraction
      do_operation { |left, right| left - right }
    end

    def do_multiplication
      do_operation { |left, right| left * right }
    end

    def do_division
      do_operation { |left, right| left / right }
    end

    def do_operation
      yield(*operands).tap do |result|
        push(result)
      end
    end

    def to_number(str)
      if float?(str)
        Float(str)
      else
        Integer(str)
      end
    end

    def numeric?(token)
      token =~ NUMERIC
    end

    def float?(str)
      str =~ DECIMAL_POINT
    end

    def operator?(token)
      token =~ OPERATOR
    end

    def push(expr)
      stack.push(expr)
    end

    def clear
      stack.clear
    end

    def stack_info
      stack.inspect
    end
  end
end

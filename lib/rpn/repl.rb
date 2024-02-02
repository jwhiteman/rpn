module RPN
  class REPL
    PRE   = "> ".freeze
    QUIT  = /\Aq(uit)?\Z/i
    STACK = /\A\?\Z/
    CLEAR = /\Ac\Z/i
    HELLO = "RPN REPL (#{VERSION}) - press Ctrl-D (or Ctrl-C) " \
            "or type 'q' to exit".freeze
    BYE   = "Bye!".freeze

    attr_reader :evaluator
    attr_reader :reader
    attr_reader :writer

    def initialize(evaluator:, reader: STDIN, writer: STDOUT)
      @evaluator = evaluator
      @reader    = reader
      @writer    = writer
    end

    def start
      init_signal_handling
      say_hello

      loop do
        begin
          if shutdown?
            break
          else
            print_line_start

            result = evaluate_input

            write(result)
          end
        rescue RPN::Calculator::InvalidExpression => e
          write(e.message)
        end
      end

      say_goodbye
    end

    def shutdown?
      @shutdown
    end

    def print_line_start
      writer.print(PRE)
    end

    def evaluate_input
      input = get_input

      case input
      when nil
        shutdown

        nil
      when QUIT
        shutdown

        nil
      when STACK
        evaluator.stack_info
      when CLEAR
        evaluator.clear

        evaluator.stack_info
      else
        evaluator.eval(input)
      end
    end

    def write(result)
      writer.puts(result)
    end

    def get_input
      reader.gets.tap do |input|
        input.chomp! if input
      end
    end

    def init_signal_handling
      trap(:INT) { shutdown }
    end

    def say_hello
      write(HELLO)
    end

    def shutdown
      @shutdown = true
    end

    def say_goodbye
      write(BYE)
    end
  end
end

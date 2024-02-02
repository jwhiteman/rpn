require "spec_helper"

describe RPN::REPL do
  let(:rpn) { RPN::Calculator.new }
  let(:reader) { StringIO.new }
  let(:writer) { StringIO.new }

  let(:repl) do
    RPN::REPL.new(evaluator: rpn, reader: reader, writer: writer)
  end

  describe "#shutdown" do
    it "exits when encountering a 'q'" do
      reader << "q"
      reader.rewind

      repl.start

      expect(writer.string).to match(RPN::REPL::BYE)
    end
  end

  describe "evaluating" do
    it "evaluates expressions" do
      reader.puts("1")
      reader.puts("2")
      reader.puts("3")
      reader.puts("*")
      reader.puts("+")
      reader.puts("q")
      reader.rewind

      repl.start

      expect(writer.string).to include("1\n> 2\n> 3\n> 6\n> 7\n>")
    end
  end

  describe "viewing the stack" do
    it "shows the contents of the stack" do
      reader.puts("1")
      reader.puts("2")
      reader.puts("3")
      reader.puts("?")
      reader.puts("q")
      reader.rewind

      repl.start

      expect(writer.string).to include(" [1, 2, 3]")
    end
  end

  describe "clearing" do
    it "allows the user to clear the stack from the CLI" do
      reader.puts("1")
      reader.puts("2")
      reader.puts("3")
      reader.puts("c")
      reader.puts("q")
      reader.rewind

      repl.start

      expect(rpn.stack).to be_empty
    end
  end

  describe "error handling" do
    it "recovers from basic errors" do
      reader.puts("1")
      reader.puts("2")
      reader.puts("dog")
      reader.puts("+")
      reader.puts("q")
      reader.rewind

      repl.start

      expect(writer.string).to include(" 1\n> 2\n> invalid token\n> 3\n")
    end
  end
end

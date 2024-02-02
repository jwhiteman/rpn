require "spec_helper"

describe "calculator integration spec" do
  subject { RPN::Calculator.new }

  # Integration specs; taken (mostly) from "Example Input/Output" in the gist
  describe "integration specs" do
    it "works for simple integers" do
      result = subject.eval("5")
      expect(result).to eq(5)

      result = subject.eval("8")
      expect(result).to eq(8)

      result = subject.eval("+")
      expect(result).to eq(13)
    end

    it "works for expressions on a single line" do
      result = subject.eval("5 8 +")
      expect(result).to eq(13)

      result = subject.eval("13 -")
      expect(result).to eq(0)
    end

    it "works with negative numbers" do
      result = subject.eval("-3")
      expect(result).to eq(-3)

      result = subject.eval("-2.0")
      expect(result).to eq(-2.0)

      result = subject.eval("*")
      expect(result).to eq(6.0)

      result = subject.eval("5")
      expect(result).to eq(5)

      result = subject.eval("+")
      expect(result).to eq(11.0)
    end

    it "works with integer division" do
      result = subject.eval("5")
      expect(result).to eq(5)

      result = subject.eval("9")
      expect(result).to eq(9)

      result = subject.eval("1")
      expect(result).to eq(1)

      result = subject.eval("-")
      expect(result).to eq(8)

      result = subject.eval("/")
      expect(result).to eq(0)  # 5 / 8 => 0 for integer division
    end

    it "works with decimal division" do
      result = subject.eval("5")
      expect(result).to eq(5)

      result = subject.eval("9")
      expect(result).to eq(9)

      result = subject.eval("1.0")
      expect(result).to eq(1)

      result = subject.eval("-")
      expect(result).to eq(8.0)

      result = subject.eval("/")
      expect(result).to eq(0.625)  # 5 / 8 => 0.625 for decimal division
    end
  end
end

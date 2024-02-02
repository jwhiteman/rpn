require "spec_helper"

describe RPN::Calculator do
  describe "#eval_numeric" do
    it "returns the number it was given" do
      result = subject.eval_numeric("42")

      expect(result).to eq(42)
    end

    it "pushes the number on to the stack" do
      subject.eval_numeric("7")

      expect(subject.stack).to eq([7])
    end
  end

  describe "#operands" do
    before do
      subject.eval("2 3 4 5")
    end

    it "returns the latest two elements" do
      result = subject.operands

      expect(result).to match_array([4, 5])
    end

    it "destructively pops off the latest two elements from the stack" do
      result = subject.operands

      expect(subject.stack).to eq([2, 3])
    end

    it "raises an error message if there are not two elements to return" do
      subject.operands # pop the first pair
      subject.operands # pop the last pair

      expect do
        subject.operands
      end.to raise_error(RPN::Calculator::InvalidExpression, /not enough operands/i)
    end
  end

  describe "#eval_operator" do
    before do
      subject.eval("2 3 4 5")
    end

    it "returns the result of the operation" do
      result = subject.eval_operator("*")

      expect(result).to eq(20) # 5 * 4
    end

    it "replaces the last two elements on the stack with the result" do
      subject.eval_operator("*")

      expect(subject.stack).to eq([2, 3, 20])
    end
  end

  describe "#numeric?" do
    it "is true if the input is an integer" do
      result = subject.numeric?("42")

      expect(result).to be_truthy
    end

    it "is true if the number is negative" do
      result = subject.numeric?("-42")

      expect(result).to be_truthy
    end

    it "is true if the input is a floating point number" do
      result = subject.numeric?("3.14")

      expect(result).to be_truthy
    end

    it "is false if the input is not numeric" do
      result = subject.numeric?("pretzle")

      expect(result).to be_falsey
    end
  end

  describe "#command?" do
    it "is true if input is the addition symbol" do
      result = subject.operator?("+")

      expect(result).to be_truthy
    end

    it "is true if input is the subtraction symbol" do
      result = subject.operator?("-")

      expect(result).to be_truthy
    end

    it "is true if input is the multiplication symbol" do
      result = subject.operator?("*")

      expect(result).to be_truthy
    end

    it "is true if input is the division symbol" do
      result = subject.operator?("/")

      expect(result).to be_truthy
    end

    it "is false if the input is not a basic math operator" do
      result = subject.operator?("%")

      expect(result).to be_falsey
    end
  end

  describe "#eval" do
    it "raises an error when given a string with invalid chars" do
      expect do
        subject.eval("1 apple +")
      end.to raise_error(RPN::Calculator::InvalidExpression)
    end
  end
end

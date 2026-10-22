describe Renalware::PageSize do
  def parse(value) = described_class.parse(value, default: 25)

  it "parse returns the default when the value is blank" do
    expect(parse(nil)).to eq(25)
    expect(parse("")).to eq(25)
  end

  it "parse returns the value as an integer when it is valid" do
    expect(parse("10")).to eq(10)
  end

  it "parse returns the default when the value is not a positive integer" do
    expect([parse("abc"), parse("0"), parse("-5"), parse("3.5")]).to all(eq(25))
  end

  it "parse caps the value at the maximum" do
    expect(parse("1000000")).to eq(described_class::MAX)
  end
end

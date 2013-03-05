require './checkout'

describe Checkout do
  it "tells me to pay 0 when not buying anything" do
    checkout.should == 0
  end

  it "tells me to pay 9.25 when buying one Lavender heart" do
    checkout(001).should == 9.25
  end

  it "tells me to pay 39.90 when buying two Kids t-shirts" do
    checkout(003, 003).should == 39.90
  end

  it "tells me to pay 81 when buying two Personalised cufflinks" do
    checkout(002, 002).should == 81.00
  end

  it "tells me to pay 17.00 when buying two Lavender hearts" do
    checkout(001, 001).should == 17.00
  end

  it "tells me to pay 66.78 with 001,002,003" do
    checkout(001, 002, 003).should == 66.78
  end

  it "tells me to pay 36.95 with 001,003,001" do
    checkout(001, 003, 001).should == 36.95
  end

  it "tells me to pay 73.76 with 001,002,001,003" do
    checkout(001, 002, 001, 003).should == 73.76
  end

  def checkout(*scans)
    rules = {:total => {:over => 60.00, :discount => 0.10},
             :product => {001 => {:quantity => 2, :price => 8.50}}}
    c = Checkout.new(PromotionalRules.new rules)
    scans.each { |s| c.scan s }
    c.total
  end
end

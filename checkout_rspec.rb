require './checkout'

describe Checkout do
  it "tells me to pay 0 when not buying anything" do
    checkout.should == 0
  end

  it "tells me to pay 5.00 when buying one Strawberry" do
    checkout("SR1").should == 5.00
  end

  it "tells me to pay 22.46 when buying two Kids t-shirts" do
    checkout("CF1", "CF1").should == 22.46
  end

  it "tells me to pay 3.11 when buying two Fruit teas" do
    checkout("FR1", "FR1").should == 3.11
  end

  it "tells me to pay 13.50 when buying three Strawberries" do
    checkout("SR1", "SR1", "SR1").should == 13.50
  end

  # the test has a mistake in this one
  it "tells me to pay 19.34 with FR1, SR1, FR1, CF1" do
    checkout("FR1", "SR1", "FR1", "CF1").should == 19.34
  end

  it "tells me to pay 16.61 with SR1, SR1, FR1, SR1" do
    checkout("SR1", "SR1", "FR1", "SR1").should == 16.61
  end

  def checkout(*scans)
    rules = {:product => {"SR1" => {:quantity => 3, :price => 4.50},
                          "FR1" => {:quantity => 1, :free => 1}}}
    c = Checkout.new(PromotionalRules.new rules)
    scans.each { |s| c.scan s }
    c.total
  end
end

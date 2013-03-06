class Checkout
  PRODUCTS = {"FR1" => {:name => "Fruit tea", :price => 3.11},
              "SR1" => {:name => "Strawberry", :price => 5.00},
              "CF1" => {:name => "Coffee", :price => 11.23}}

  def initialize(rules)
    @scanned = {}
    @rules = rules 
  end

  def scan(product)
    @scanned[product] ||= 0
    @scanned[product] += 1 
  end

  def total
    @scanned.keys.inject(0) do |sum, product|
      sum += calculate_cost product, @scanned[product]
    end
  end

  private

  def calculate_cost(product, quantity)
    calculate_quantity(product, quantity) * calculate_price(product, quantity)
  end

  def calculate_quantity(product, quantity)
    @rules.quantity(product, quantity)
  end

  def calculate_price(product, quantity)
    @rules.price(product, PRODUCTS[product][:price], quantity)
  end
end

class PromotionalRules

  def initialize(rules)
    @rules = rules
  end

  def price(product, price, quantity)
    has_promotion?(product) && eligible_price?(product, quantity) ? promotion_price(product) : price
  end

  def quantity(product, scanned)
    has_promotion?(product) && eligible_quantity?(product) ? promotion_quantity(product, scanned) : scanned
  end

  private

  def promotion_quantity(product, scanned)
    scanned - Integer(scanned / (@rules[:product][product][:quantity] + @rules[:product][product][:free]))
  end

  def promotion_price(product)
    @rules[:product][product][:price]
  end

  def has_promotion?(product)
    @rules[:product] && @rules[:product][product]
  end

  def eligible_price?(product, quantity)
    quantity >= @rules[:product][product][:quantity] && @rules[:product][product][:price]
  end

  def eligible_quantity?(product)
    @rules[:product][product][:free]
  end
end

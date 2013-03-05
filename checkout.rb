class Checkout
  PRODUCTS = {001 => {:name => "Lavender heart", :price => 9.25},
              002 => {:name => "Personalised cufflinks", :price => 45.00},
              003 => {:name => "Kids T-shirt", :price => 19.95}}

  def initialize(rules)
    @scanned = {}
    @rules = rules 
  end

  def scan(product)
    @scanned[product] ||= 0
    @scanned[product] += 1 
  end

  def total
    @rules.total_with_discount calculate_total
  end

  private

  def calculate_total
    @scanned.keys.inject(0) do |sum, product|
      sum += calculate_cost product, @scanned[product]
    end
  end

  def calculate_cost(product, quantity)
    quantity * calculate_price(product, quantity)
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
    has_promotion?(product) && eligible?(product, quantity) ? promotion_price(product) : price
  end

  def total_with_discount(total)
    discount?(total) ? with_discount(total) : total
  end

  private

  def promotion_price(product)
    @rules[:product][product][:price]
  end

  def has_promotion?(product)
    @rules[:product] && @rules[:product][product]
  end

  def eligible?(product, quantity)
    @rules[:product][product][:quantity] <= quantity
  end

  def with_discount(total)
    total -= total * @rules[:total][:discount]
    total.round(2)
  end

  def discount?(total)
    @rules[:total] && total > @rules[:total][:over]
  end
end

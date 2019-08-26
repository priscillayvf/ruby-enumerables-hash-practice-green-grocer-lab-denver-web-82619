def consolidate_cart(cart)
  proper_cart = {}
  count = 0
  cart.each do |element|
    element.each do |fruit, hash|
      proper_cart[fruit] ||= hash
      proper_cart[fruit][:count] ||= 0
      proper_cart[fruit][:count] += 1
    end
  end
  return proper_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    if cart.has_key?(item)
      if cart[item][:count] >= coupon[:num] && !cart.has_key?("#{item} W/COUPON")
        cart["#{item} W/COUPON"] = [price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]]
      elsif cart[item][:count] >= coupon[:num] && cart.has_key?("#{item} W/COUPON")
        cart["#{item} W/COUPON"][:count] += coupon[:num]
      end
      cart[item][:count] -= coupon[:num]
    end
  end
  cart
end
    


def apply_coupons(cart, coupons)
  achash = cart
  coupons.each do |coupon_achash|
    item = coupon_achash[:item]

    if !achash[item].nil? && achash[item][:count] >= coupon_achash[:num]
      temp = {"#{item} W/COUPON" => {
        :price => coupon_achash[:cost],
        :clearance => achash[item][:clearance],
        :count => 1
        }
      }
      
      if achash["#{item} W/COUPON"].nil?
        achash.merge!(temp)
      else
        achash["#{item} W/COUPON"][:count] += 1
      end
      
      achash[item][:count] -= coupon_achash[:num]
    end
  end
  achash
end

def apply_clearance(cart)
  cart.each do |item, price_hash|
    if price_hash[:clearance] == true
      price_hash[:price] = (price_hash[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(items, coupons)
  cart = consolidate_cart(items)
  cart1 = apply_coupons(cart, coupons)
  cart2 = apply_clearance(cart1)
  
  total = 0
  
  cart2.each do |name, price_hash|
    total += price_hash[:price] * price_hash[:count]
  end
  
  total > 100 ? total * 0.9 : total
  
end

items =   [
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"KALE" => {:price => 3.00, :clearance => false}},
      {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
      {"ALMONDS" => {:price => 9.00, :clearance => false}},
      {"TEMPEH" => {:price => 3.00, :clearance => true}},
      {"CHEESE" => {:price => 6.50, :clearance => false}},
      {"BEER" => {:price => 13.00, :clearance => false}},
      {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
      {"BEETS" => {:price => 2.50, :clearance => false}},
      {"SOY MILK" => {:price => 4.50, :clearance => true}}
    ]

coupons = [
      {:item => "AVOCADO", :num => 2, :cost => 5.00},
      {:item => "AVOCADO", :num => 2, :cost => 5.00},
      {:item => "BEER", :num => 2, :cost => 20.00},
      {:item => "CHEESE", :num => 2, :cost => 15.00}
    ]

checkout(items, coupons)

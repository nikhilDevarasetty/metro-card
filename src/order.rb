# metro system orders: recharge, card purchase
class Order
  attr_reader :collected_at, :convinience_fee

  def initialize(order_type, amount, convinience_fee, station)
    @order_type = order_type
    @amount = amount
    @convinience_fee = convinience_fee
    @collected_at = station
  end
end

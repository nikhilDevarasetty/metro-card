# ticket class
class Ticket
  attr_accessor :card, :passenger_type, :departure_station, :fare, :return_ticket, :discount

  def initialize(card, passenger_type, departure_station, fare, discount)
    @card = card
    @passenger_type = passenger_type
    @departure_station = departure_station
    @fare = fare
    @discount = discount
    @return_ticket = nil
  end
end

# metro system class
require_relative 'metro_card'
require_relative 'ticket'
require_relative 'order'

class MetroSystem
  attr_accessor :metro_cards, :tickets, :orders, :start_journey_ticket

  def initialize
    @metro_cards = []
    @tickets = []
    @orders = []
  end

  def create_card(card_id, amount)
    puts 'create card failed: card already exits' if metro_cards.find { |e| e.id == card_id }

    metro_cards << MetroCard.new(card_id, amount)
  end

  def create_order(card_id, passenger_type, departure_station)
    card = metro_cards.find { |e| e.id == card_id }
    if card.nil?
      puts 'create order failed: card does not exist'
    else
      fare = card.fare(passenger_type)
      if can_apply_discount?(card, passenger_type, departure_station)
        fare /= 2
        dicount = fare
      end

      if card.amount < fare
        recharge_amount = fare - card.amount
        card.recharge(recharge_amount)
        orders << Order.new('RECHARGE', recharge_amount, 0.2 * recharge_amount, departure_station)
      end
      card.charge(fare)
      ticket = Ticket.new(card, passenger_type, departure_station, fare, dicount)
      tickets << ticket

      tag_return_ticket(ticket)
    end
  end

  def print_summary
    puts "TOTAL_COLLECTION CENTRAL #{calculate_amount('CENTRAL', 'fare')} #{calculate_amount('CENTRAL', 'discount')}\n"
    puts "PASSENGER_TYPE_SUMMARY\n"
    central_tickets.group_by(&:passenger_type).sort_by { |_, v| v.size }.each do |k, v|
      puts "#{k} #{v.size}"
    end

    puts "TOTAL_COLLECTION CENTRAL #{calculate_amount('AIRPORT', 'fare')} #{calculate_amount('AIRPORT', 'discount')}\n"
    puts "PASSENGER_TYPE_SUMMARY\n"
    airport_tickets.group_by(&:passenger_type).sort_by { |_, v| v.size }.each do |k, v|
      puts "#{k} #{v.size}"
    end
  end

  private

  def can_apply_discount?(card, passenger_type, departure_station)
    self.start_journey_ticket = @tickets.find do |e|
      e.card.id == card.id && e.passenger_type == passenger_type &&
        e.departure_station == destination(departure_station) && e.return_ticket.nil?
    end
  end

  def tag_return_ticket(ticket)
    ticket.return_ticket = start_journey_ticket
  end

  def destination(departure_station)
    case departure_station
    when 'CENTRAL' then 'AIRPORT'
    when 'AIRPORT' then 'CENTRAL'
    end
  end

  def central_tickets
    @central_tickets ||= tickets.filter { |e| e.departure_station == 'CENTRAL' }
  end

  def airport_tickets
    @airport_tickets ||= tickets.filter { |e| e.departure_station == 'AIRPORT' }
  end

  def calculate_amount(station, type)
    case type
    when 'fare'
      send("#{station.downcase}_tickets").sum(&:fare) +
        orders.filter { |e| e.collected_at == station }.map(&:convinience_fee).compact.sum
    when 'discount'
      send("#{station.downcase}_tickets").map(&:discount).compact.sum
    end.to_i
  end

  alias balance create_card
  alias check_in create_order
end

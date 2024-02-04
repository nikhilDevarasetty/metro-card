# metro_card.rb
class MetroCard
  attr_reader :id, :amount

  def initialize(id, amount)
    @id = id
    @amount = amount.to_i
  end

  def charge(fare)
    @amount -= fare
  end

  def recharge(amount)
    @amount += amount
  end

  def fare(passenger_type)
    case passenger_type.downcase
    when 'adult' then 200
    when 'senior_citizen' then 100
    when 'kid' then 50
    end
  end
end

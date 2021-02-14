require_relative "card"

# main class
class ListCard
  attr_reader :id, :name, :cards

  def initialize(data)
    @id = data["id"] || 0
    @name = data["name"]
    @cards = get_cards(data["cards"])
  end

  def update(data)
    return puts "Invalid input" if data.nil? || data.empty?

    @name = data["name"]
  end

  def to_hash
    hash = {
      "id" => @id,
      "name" => @name,
      "cards" => []
    }
    @cards.each do |x|
      hash["cards"].push(x.to_hash)
    end
    hash
  end

  def add_card(data)
    new_card = Card.new(data)
    return puts "Invalid data" if data.nil? || data.empty?

    @cards.push(new_card)
    new_card
  end

  def remove_card(id)
    @cards.reject! { |card| card.id == id }
  end

  def update_card(data)
    @cards.select { |card| card.id == data["id"] }[0].update(data)
  end

  private

  def get_cards(data)
    cards = []
    return cards if data.nil?

    data.each do |card_data|
      card = Card.new(card_data)
      cards.push(card)
    end
    cards
  end
end

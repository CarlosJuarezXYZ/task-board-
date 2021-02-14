require "terminal-table"
require_relative "list_card"

class Board
  attr_reader :id, :name, :description, :lists

  def initialize(data)
    @id = data["id"]
    @name = data["name"]
    @description = data["description"]
    @lists = get_lists(data["lists"])
  end

  def update(new_data)
    # variable = @store.find {|a| clinboards.id==id }
    @name = new_data["name"]
    @description = new_data["description"]
  end

  def show
    @lists.each do |element|
      table = Terminal::Table.new
      table.title = element.name
      table.headings = %w[ID Title Members Labels DueDate Checklist]
      table.rows = element.cards.map(&:to_array_resume)
      puts table
    end
  end

  def get_lists(data)
    lists = []
    return lists if data.nil?

    data.each do |list|
      new_list = ListCard.new(list)
      lists.push(new_list)
    end
    lists
  end

  def resume_lists
    cadena = ""
    @lists.each do |list|
      cadena << "#{list.name}(#{list.cards.length}) "
    end
    cadena
  end

  def lists_max_id
    return 0 if @lists.empty?

    list = @lists.max_by(&:id)
    list.id + 1
  end

  def create_list(data)
    data["id"] = lists_max_id
    list = ListCard.new(data)
    @lists.push(list)
  end

  def delete_list(id)
    return puts "Id not provided" if id.nil? || !id.positive?

    @lists.reject! { |list| list.id == id }
  end

  def update_list(id, data)
    return puts "Id/Data was not provide" if data.nil? || data.empty? || id.nil? || !id.positive?

    @lists.each do |list|
      list.update(data) if list.id == id
    end
  end

  def to_hash
    {
      "id" => @id,
      "name" => @name,
      "description" => @description,
      "lists" => @lists.map(&:to_hash)
    }
  end
end

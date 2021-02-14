require_relative "formatter"
require_relative "requester"
require_relative "parser"
require_relative "board"
require_relative "functions"
require_relative "request_card"
require_relative "menu_module"

class ClinBoards
  include Formatter
  include Requester
  include Parser
  include Functions
  include CardActions
  include RequestCard
  include Menu
  include ListActions

  def initialize(filename)
    @filename = filename || "store.json"
    @boards = board_ini
  end

  def start
    welcome
    menu_start
  end

  def all_data
    parse_json(@filename)
  end

  def board_ini
    boards = []
    all_data.each do |board_data|
      board = Board.new(board_data)
      boards.push(board)
    end
    boards
  end

  def create_board(data)
    return "Data was not provided" if data.nil? || data.empty?

    new_board_id = boards_max_id
    data["id"] = new_board_id
    board = Board.new(data)
    @boards.push(board)
  end

  def update_board(id, data)
    return puts "Id/Data was not provide" if data.nil? || data.empty? || id.nil? || !id.positive?

    @boards.each do |board|
      board.update(data) if board.id == id
    end
  end

  def delete_board(id)
    return puts "Id not provided" if id.nil? || !id.positive?

    @boards.reject! { |board| board.id == id }
  end

  def boards_max_id
    return 0 if @boards.empty?

    board = @boards.max_by(&:id)
    board.id + 1
  end
end

filename = ARGV.first
app = ClinBoards.new(filename)
app.start

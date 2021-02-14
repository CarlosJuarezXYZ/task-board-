require "terminal-table"
module Formatter
  def welcome
    puts ("#" * 36).to_s
    puts "#      Welcome to CLIn Boards      #"
    puts ("#" * 36).to_s
  end

  def print_boards
    table = Terminal::Table.new
    table.title = "CLIn Boards"
    table.headings = %w[ID Name Description List(#cards)]
    table.rows = @boards.map do |board|
      row = []
      row.push(board.id)
      row.push(board.name)
      row.push(board.description)
      row.push(board.resume_lists)
    end
    puts table
    puts ""
  end

  def show_board(id)
    @currend_board = @boards.find { |board| board.id == id }
    return puts "Board not found.." if @currend_board.nil?

    option = nil
    until option == "back"
      @currend_board.show
      puts ""
      option, param = menu_option_board
      puts ""
      case_show_board_list(option, param)
      case_show_board_card(option, param)
    end
  end

  def show_checklist(id)
    card_checklist = nil
    @currend_board.lists.each do |list|
      card_checklist ||= list.cards.find { |card| card.id == id }
    end
    return "Invalid id.." if card_checklist.nil?

    card_checklist.show_card_checklist
    puts ""
    case_checklist(card_checklist)
  end
end

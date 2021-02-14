module Requester
  def menu_start
    print_boards
    menu_text
    choice = $stdin.gets.chomp.strip
    choice_command = choice.split(" ")[0]
    choice_id = choice.split(" ")[1].to_i
    return exit_text if choice_command == "exit"

    menu_case(choice_command, choice_id)
    menu_start
  end

  def board_req
    print "Name: "
    name = $stdin.gets.chomp.strip
    print "Description: "
    description = $stdin.gets.chomp.strip
    { "name" => name, "description" => description }
  end

  def list_req
    print "Name: "
    name = $stdin.gets.chomp.strip
    { "name" => name }
  end

  def menu_text
    print "Board options:"
    puts "create | show ID | update ID | delete ID | exit"
    print "> "
  end

  def exit_text
    puts ("#" * 36).to_s
    puts "#   Thanks for using CLIn Boards   #"
    puts ("#" * 36).to_s
  end

  def menu_option_board
    puts "List options: create-list | update-list LISTNAME | delete-list LISTNAME"
    puts "Card options: create-card | checklist ID | update-card ID | delete-card ID"
    print "back\n> "
    $stdin.gets.chomp.strip.split
  end

  def input_field(required, label = "> ")
    loop do
      print label
      result = $stdin.gets.chomp.strip
      break result if !required || !result.empty?
    end
  end
end

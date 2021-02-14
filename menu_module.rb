module Menu
  def menu_case(choice_command, choice_id)
    case choice_command
    when "create"
      create_board(board_req)
      print_boards
    when "show"
      show_board(choice_id)
    when "update"
      update_board(choice_id, board_req)
      print_boards
    when "delete"
      delete_board(choice_id)
      print_boards
    end
    puts ""
    save_data
  end
end

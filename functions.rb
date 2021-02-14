module Functions
  def case_show_board_list(option, param)
    case option
    when "create-list"
      create_list(list_req)
    when "update-list"
      update_list(param, list_req)
    when "delete-list"
      delete(param)
    end
    save_data
  end

  def case_show_board_card(option, param)
    case option
    when "create-card" then create_card
    when "checklist" then show_checklist(param.to_i)
    when "update-card" then update_card(param.to_i)
    when "delete-card" then delete_card(param.to_i)
    end
    save_data
  end

  def checklist_add(card)
    title = input_field(true, "title: ")
    card.add_checkitem(title)
    card.show_card_checklist
  end

  def checklist_toggle(card, index)
    return puts "specific number o number incorect" if index.nil? || index.negative? || index >= card.checklist_size

    card.toggle_checkitem(index)
    card.show_card_checklist
  end

  def checklist_delete(card, index)
    return puts "specific number o number incorect" if index.nil? || index.negative? || index >= card.checklist_size

    card.delete_checkitem(index)
    card.show_card_checklist
  end

  def case_checklist(card)
    option = nil
    until option == "back"
      option, param = menu_checklist
      puts ""
      case option
      when "add"
        checklist_add(card)
      when "toggle"
        checklist_toggle(card, param.to_i - 1)
      when "delete"
        checklist_delete(card, param.to_i - 1)
      else
        puts "option invalid"
      end
      save_data
    end
  end
end

module CardActions
  def fill_new_card_hash(required: false)
    new_data = {}
    new_data["title"] = input_field(required, "Title: ")
    new_data["members"] = input_field(required, "Members: ").split
    new_data["labels"] = input_field(required, "Labels: ").split
    new_data["due_date"] = input_field(required, "Due Date: ")
    new_data
  end

  def create_card
    list_names = @currend_board.lists.map(&:name)
    return puts "First create a list..." if list_names.empty?

    list_name = loop do
      list_name = input_field(true, "Select a list:\n#{list_names.join(' | ')}\n> ")
      break list_name if list_names.include?(list_name)

      puts "Please enter a valid list name"
    end

    new_data = fill_new_card_hash(required: true)

    select_listcard = @currend_board.lists.find do |list|
      list.name == list_name
    end
    select_listcard.add_card(new_data)
  end

  def update_card(id)
    card_and_list = find_card_and_list(id)
    return puts "Card not found" if card_and_list.nil?

    list_names = @currend_board.lists.map(&:name)
    return puts "First create a list..." if list_names.empty?

    list_name = loop do
      list_name = input_field(true, "Select a list:\n#{list_names.join(' | ')}\n> ")
      break list_name if list_names.include?(list_name)

      puts "Please enter a valid list name"
    end

    save_card(card_and_list, list_name, fill_new_card_hash(required: false))
  end

  def save_card(card_and_list, list_name, new_data)
    card, old_list = card_and_list
    if old_list.name == list_name
      card.update(new_data)
    else
      select_list = @currend_board.lists.find { |list| list.name == list_name }

      card.update(new_data)
      data_updated = card.to_hash
      old_list.remove_card(card.id)
      select_list.add_card(data_updated)
    end
  end

  def find_card_and_list(id)
    @currend_board.lists.each do |list|
      list.cards.each { |card| return [card, list] if card.id == id }
    end
    nil
  end

  def delete_card(id)
    _, list = find_card_and_list(id)
    return puts "Card not found.." if list.nil?

    list.remove_card(id)
  end
end

module ListActions
  def create_list(data)
    @currend_board.create_list(data)
  end

  def update_list(param, data)
    pp param
    pp data

    return puts "Param was not provide" if param.nil? || param.empty?
    return puts "Data was not provide" if data.nil? || data.empty?

    @currend_board.lists.each do |list|
      list.update(data) if list.name == param
    end
  end

  def delete(param)
    return puts "Param not provided" if param.nil? || param.empty?

    @currend_board.lists.reject! { |list| list.name == param }
  end
end

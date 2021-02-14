require_relative "task"

class Card
  attr_reader :id

  @@current_id = 0

  def initialize(data)
    @id = data["id"] || next_id
    @@current_id = @id if @id > @@current_id
    @title = data["title"]
    @members = data["members"]
    @labels = data["labels"]
    @due_date = data["due_date"]
    @checklist = check_data(data["checklist"])
  end

  def checklist_size
    @checklist.size
  end

  def show_card_checklist
    puts "Card: #{@title}"
    @checklist.each_with_index do |task, index|
      puts task.to_print(index + 1)
    end
  end

  def add_checkitem(title)
    return if title.empty?

    @checklist << Task.new(title, false)
  end

  def toggle_checkitem(index)
    @checklist[index].toggle
  end

  def delete_checkitem(index)
    @checklist.delete_at(index)
  end

  def to_array_resume
    [
      @id,
      @title,
      @members.join(", "),
      @labels.join(", "),
      @due_date,
      "#{completed_count}/#{@checklist.size}"
    ]
  end

  def completed_count
    @checklist.filter(&:completed).count
  end

  def update(new_values)
    assign_valid_data(@title, new_values["title"])
    assign_valid_data(@members, new_values["members"])
    assign_valid_data(@labels, new_values["labels"])
    assign_valid_data(@due_date, new_values["due_date"])
  end

  def to_hash
    {
      "id" => @id,
      "title" => @title,
      "members" => @members,
      "labels" => @labels,
      "due_date" => @due_date,
      "checklist" => @checklist.map(&:to_h)
    }
  end

  private

  def assign_valid_data(parameter, new_data)
    parameter = new_data if !new_data.empty? && !new_data.nil?
    parameter
  end

  def next_id
    (@@current_id = @@current_id.next)
  end

  def check_data(data_list)
    data_list ||= []
    data_list.map do |task|
      task.is_a?(Task) ? task : Task.new(task["title"], task["completed"])
    end
  end
end

class Task
  attr_reader :completed

  def initialize(title, completed)
    @title = title
    @completed = completed || false
  end

  def toggle
    @completed = !@completed
  end

  def to_h
    {
      title: @title,
      completed: @completed
    }
  end

  def to_print(index)
    "[#{@completed ? 'x' : ' '}] #{index}. #{@title}"
  end
end

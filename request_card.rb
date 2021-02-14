module RequestCard
  def menu_checklist
    print "Checklist options:"
    puts "add | toggle INDEX | delete INDEX"
    puts "back"
    print ">"
    $stdin.gets.chomp.strip.split
  end
end

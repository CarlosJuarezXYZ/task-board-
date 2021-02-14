require "json"
module Parser
  def parse_json(filename)
    json = File.read(filename)
    JSON.parse(json)
  end

  def save_data
    File.write(@filename, JSON.dump(@boards.map(&:to_hash)))
  end
end

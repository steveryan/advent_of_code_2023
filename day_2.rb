data = File.read("data/day_2.txt").lines.map(&:strip)

def get_games(data)
  games = []
  data.each do |line|
    game = line.split(":")[1]
    games << game.strip
  end
  games
end

def check_games(games:, red:, green:, blue:)
  sum = 0
  games.each_with_index do |game,i|
    game_num = i+1
    sets = game.split("; ")
    game_is_possible = true
    sets.each do |set|
      rolls = set.split(", ")
      rolls.each do |roll|
        split = roll.split(" ")
        color = split[1]
        number = split[0].to_i
        if color == "red" && number > red
          game_is_possible = false
          break
        elsif color == "green" && number > green
          game_is_possible = false
          break
        elsif color == "blue" && number > blue
          game_is_possible = false
          break
        end
      end
    end
    sum += game_num if game_is_possible
  end
  sum
end

def get_sum_of_power_of_games(games)
  sum = 0
  games.each do |game|
    game_power = 0
    sets = game.split("; ")
    min = {"red": 0, "green": 0, "blue": 0}
    sets.each do |set|
      rolls = set.split(", ")
      rolls.each do |roll|
        split = roll.split(" ")
        color = split[1]
        number = split[0].to_i
        min[color.to_sym] = number if number > min[color.to_sym]
      end
    end
    game_power = min[:red] * min[:green] * min[:blue]
    sum += game_power
  end
  sum
end

def part1(games)
  sum = check_games(games: games, red: 12, green: 13, blue: 14)
end

def part2(games)
  sum = get_sum_of_power_of_games(games)
end

start = Time.now
games = get_games(data)
p "Part 1: " + part1(games).to_s
p "Part 2: " + part2(games).to_s
p "Finished in #{Time.now - start} seconds."
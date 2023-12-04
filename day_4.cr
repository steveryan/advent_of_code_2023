data = File.read("data/day_4.txt").lines.map { |line| line.chomp }

def check_games_part_1(data)
  sum = 0
  data.each do |line|
    chopped_line = line.split(":")[1]
    winners_and_numbers = chopped_line.split("|")
    winners = winners_and_numbers[0].split(" ")
    winners.compact!
    numbers = winners_and_numbers[1].split(" ")
    numbers.compact!
    winners_hash = {} of String => Bool
    winners.each { |winner| winners_hash[winner] = true }
    game_sum = 0
    numbers.each do |number|
      next if number == ""
      if winners_hash.has_key?(number)
        if game_sum == 0
          game_sum = 1
        else
          game_sum *= 2
        end
      end
    end
    sum += game_sum
  end
  sum
end

def check_games_part_2(data)
  quantity_of_each_card = {} of Int32 => Int32
  i = 1
  while i <= data.size
    quantity_of_each_card[i] = 1
    i += 1
  end
  data.each_with_index do |line, index|
    card_number = index + 1
    chopped_line = line.split(":")
    winners_and_numbers = chopped_line[1].split("|")
    winners = winners_and_numbers[0].split(" ").compact!
    numbers = winners_and_numbers[1].split(" ").compact!
    winners_hash = {} of String => Bool
    winners.each { |winner| winners_hash[winner] = true }
    number_of_winners = 0
    numbers.each do |number|
      next if number == ""
      if winners_hash.has_key?(number)
        number_of_winners += 1
      end
    end
    i = 1
    while i <= number_of_winners
      quantity_of_each_card[card_number + i] += quantity_of_each_card[card_number]
      i += 1
    end
  end
  quantity_of_each_card.values.sum
end

def part1(data)
  check_games_part_1(data)
end

def part2(data)
  check_games_part_2(data)
end

start = Time.monotonic
p "Part 1: " + part1(data).to_s
p "Part 2: " + part2(data).to_s
p "Finished in #{Time.monotonic - start} seconds."

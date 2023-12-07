@data = File.read("data/day_7.txt").lines.map(&:strip).reject(&:empty?)

@hands = []
@bets = {}
@data.each do |line|
  split = line.split(" ")
  @hands << split[0]
  @bets[split[0]] = split[1].to_i
end

def part1
  five_of_a_kind = []
  four_of_a_kind = []
  full_house = []
  three_of_a_kind = []
  two_pair = []
  pair = []
  nothing = []
  @hands.each do |hand|
    chars = hand.chars
    tally = chars.tally
    if tally.values.include?(5)
      five_of_a_kind << hand
    elsif tally.values.include?(4)
      four_of_a_kind << hand
    elsif tally.values.include?(3) && tally.values.include?(2)
      full_house << hand
    elsif tally.values.include?(3)
      three_of_a_kind << hand
    elsif tally.values.include?(2) && tally.values.length == 3
      two_pair << hand
    elsif tally.values.include?(2)
      pair << hand
    else
      nothing << hand
    end
  end
  nothing = nothing.sort {|a,b| comparison(a,b)}
  pair = pair.sort {|a,b| comparison(a,b)}
  two_pair = two_pair.sort {|a,b| comparison(a,b)}
  three_of_a_kind = three_of_a_kind.sort {|a,b| comparison(a,b)}
  full_house = full_house.sort {|a,b| comparison(a,b)}
  four_of_a_kind = four_of_a_kind.sort {|a,b| comparison(a,b)}
  five_of_a_kind = five_of_a_kind.sort {|a,b| comparison(a,b)}
  ordered_hands = nothing + pair + two_pair + three_of_a_kind + full_house + four_of_a_kind + five_of_a_kind

  answer = 0
  for i in 1..ordered_hands.length
    index = i - 1
    product = @bets[ordered_hands[index]] * i
    answer += product
  end
  answer
end

def part2
  five_of_a_kind = []
  four_of_a_kind = []
  full_house = []
  three_of_a_kind = []
  two_pair = []
  pair = []
  nothing = []
  @hands.each do |hand|
    chars = hand.chars
    tally = chars.tally
    j = tally.delete("J")
    if tally.values.include?(5) || (j && j==5) || (j && tally.values.max + j == 5)
      five_of_a_kind << hand
    elsif tally.values.include?(4) || (j && tally.values.max + j == 4)
      four_of_a_kind << hand
    elsif (tally.values.include?(3) && tally.values.include?(2)) || (j && tally.values.length == 2 && tally.values.max + j == 3)
      full_house << hand
    elsif tally.values.include?(3) || (j && tally.values.max + j == 3)
      three_of_a_kind << hand
    elsif tally.values.include?(2) && tally.values.length == 3
      two_pair << hand
    elsif tally.values.include?(2) || (j && tally.values.max + j == 2)
      pair << hand
    else
      nothing << hand
    end
  end
  nothing = nothing.sort {|a,b| comparison2(a,b)}
  pair = pair.sort {|a,b| comparison2(a,b)}
  two_pair = two_pair.sort {|a,b| comparison2(a,b)}
  three_of_a_kind = three_of_a_kind.sort {|a,b| comparison2(a,b)}
  full_house = full_house.sort {|a,b| comparison2(a,b)}
  four_of_a_kind = four_of_a_kind.sort {|a,b| comparison2(a,b)}
  five_of_a_kind = five_of_a_kind.sort {|a,b| comparison2(a,b)}
  ordered_hands = nothing + pair + two_pair + three_of_a_kind + full_house + four_of_a_kind + five_of_a_kind

  answer = 0
  for i in 1..ordered_hands.length
    index = i - 1
    product = @bets[ordered_hands[index]] * i
    answer += product
  end
  answer
end

def comparison(a,b)
  a = a.chars
  b = b.chars
  ranking = {
    "2" => 1,
    "3" => 2,
    "4" => 3,
    "5" => 4,
    "6" => 5,
    "7" => 6,
    "8" => 7,
    "9" => 8,
    "T" => 9,
    "J" => 10,
    "Q" => 11,
    "K" => 12,
    "A" => 13
  }
  for i in 0..a.length-1
    if a[i] == b[i]
      next
    end
    if ranking[a[i]] > ranking[b[i]]
      return 1
    else
      return -1
    end
  end
end

def comparison2(a,b)
  a = a.chars
  b = b.chars
  ranking = {
    "J" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "T" => 10,
    "Q" => 11,
    "K" => 12,
    "A" => 13
  }
  for i in 0..a.length-1
    if a[i] == b[i]
      next
    end
    if ranking[a[i]] > ranking[b[i]]
      return 1
    else
      return -1
    end
  end
end

start = Time.now
p "Part 1: " + part1.to_s
p "Part 2: " + part2.to_s
p "Finished in #{Time.now - start} seconds."
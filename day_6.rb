require "JSON"
@data = File.read("data/day_6.txt").lines.map(&:strip).reject(&:empty?)

@data.each do |line|
  if line.start_with?("Time:")
    @times = line.split(": ")[1].split(" ").map(&:to_i)
    @time = line.split(": ")[1].split(" ").inject(:+).to_i
  elsif line.start_with?("Distance:")
    @distances = line.split(": ")[1].split(" ").map(&:to_i)
    @distance = line.split(": ")[1].split(" ").inject(:+).to_i
  end
end

def part1
  ways_to_beat_record = []
  for i in 0..@times.length-1
    time = @times[i]
    distance = @distances[i]
    ways_to_beat_record[i] = 0
    for j in 1..time-1
      distance_covered = j * (time - j)
      ways_to_beat_record[i] += 1 if distance_covered > distance
    end
  end
  product_of_ways = ways_to_beat_record.inject(:*)
end

def part2
  ways_to_beat_record = 0
  p @time
  p @distance
  for j in 1..@time-1
    distance_covered = j * (@time - j)
    ways_to_beat_record += 1 if distance_covered > @distance
  end
  ways_to_beat_record
end

start = Time.now
p "Part 1: " + part1.to_s
p "Part 2: " + part2.to_s
p "Finished in #{Time.now - start} seconds."
require "JSON"
@data = File.read("data/day_5.txt").lines.map(&:strip).reject(&:empty?)

@data.each_with_index do |line,i|
  if line.start_with?("seeds:")
    @seeds = line.split(": ")[1].split(" ").map(&:to_i)
  elsif line.start_with?("seed-to-soil map:")
    @seed_to_soil_start = i
  elsif line.start_with?("soil-to-fertilizer map:")
    @soil_to_fertilizer_start = i
  elsif line.start_with?("fertilizer-to-water map:")
    @fertilizer_to_water_start = i
  elsif line.start_with?("water-to-light map:")
    @water_to_light_start = i
  elsif line.start_with?("light-to-temperature map:")
    @light_to_temperature_start = i
  elsif line.start_with?("temperature-to-humidity map:")
    @temperature_to_humidity_start = i
  elsif line.start_with?("humidity-to-location map:")
    @humidity_to_location_start = i
  end
end

def get_soil(seed)
  ranges = @data[@seed_to_soil_start+1..@soil_to_fertilizer_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if seed >= range[1] && seed <= range[1]+range[2]-1
      return range[0] + seed - range[1]
    end
  end
  return seed
end

def get_fertilizer(soil)
  ranges = @data[@soil_to_fertilizer_start+1..@fertilizer_to_water_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if soil >= range[1] && soil <= range[1]+range[2]-1
      return range[0] + soil - range[1]
    end
  end
  return soil
end

def get_water(fertilizer)
  ranges = @data[@fertilizer_to_water_start+1..@water_to_light_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if fertilizer >= range[1] && fertilizer <= range[1]+range[2]-1
      return range[0] + fertilizer - range[1]
    end
  end
  return fertilizer
end

def get_light(water)
  ranges = @data[@water_to_light_start+1..@light_to_temperature_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if water >= range[1] && water <= range[1]+range[2]-1
      return range[0] + water - range[1]
    end
  end
  return water
end

def get_temperature(light)
  ranges = @data[@light_to_temperature_start+1..@temperature_to_humidity_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if light >= range[1] && light <= range[1]+range[2]-1
      return range[0] + light - range[1]
    end
  end
  return light
end

def get_humidity(temperature)
  ranges = @data[@temperature_to_humidity_start+1..@humidity_to_location_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if temperature >= range[1] && temperature <= range[1]+range[2]-1
      return range[0] + temperature - range[1]
    end
  end
  return temperature
end

def get_location(humidity)
  ranges = @data[@humidity_to_location_start+1..-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if humidity >= range[1] && humidity <= range[1]+range[2]-1
      return range[0] + humidity - range[1]
    end
  end
  return humidity
end

def get_soil_ranges(ranges)
  soil_ranges = []
  ranges.each do |range|
    start_num = range.first
    end_num = range.last
    offset = end_num - start_num + 1
    mappings = @data[@seed_to_soil_start+1..@soil_to_fertilizer_start-1].map{|line| line.split(" ").map(&:to_i)}
    finished = false
    mappings.reverse.each do |mapping|
      map_range = (mapping[1]..mapping[1]+mapping[2]-1)
      if map_range.cover?(range)
        finished = true
        soil_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + end_num - mapping[1])
      elsif map_range.cover?(start_num)
        range_end = [mapping[0] + mapping[2] - 1, end_num].min
        soil_ranges << (mapping[0] + start_num - mapping[1]..range_end)
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif map_range.cover?(end_num)
        next if finished
        soil_ranges << (mapping[0]..mapping[0] + end_num - mapping[1])
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    soil_ranges << (start_num..end_num) unless finished
  end
  soil_ranges
end

def get_fertilizer_ranges(ranges)
  fertilizer_ranges = []
  ranges.each do |range|
    start_num = range.first
    end_num = range.last
    offset = end_num - start_num + 1
    mappings = @data[@soil_to_fertilizer_start+1..@fertilizer_to_water_start-1].map{|line| line.split(" ").map(&:to_i)}
    finished = false
    mappings.reverse.each do |mapping|
      map_range = (mapping[1]..mapping[1]+mapping[2]-1)
      if map_range.cover?(range)
        finished = true
        fertilizer_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + end_num - mapping[1])
      elsif map_range.cover?(start_num)
        fertilizer_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + mapping[2] - 1)
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif map_range.cover?(end_num)
        next if finished
        fertilizer_ranges << (mapping[0]..mapping[0] + end_num - mapping[1])
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    fertilizer_ranges << (start_num..end_num) unless finished
  end
  fertilizer_ranges
end

def get_water_ranges(ranges)
  water_ranges = []
  ranges.each do |range|
    start_num = range.first
    end_num = range.last
    offset = end_num - start_num + 1
    mappings = @data[@fertilizer_to_water_start+1..@water_to_light_start-1].map{|line| line.split(" ").map(&:to_i)}
    finished = false
    mappings.reverse.each do |mapping|
      map_range = (mapping[1]..mapping[1]+mapping[2]-1)
      if map_range.cover?(range)
        finished = true
        water_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + end_num - mapping[1])
      elsif map_range.cover?(start_num)
        range_end = [mapping[0] + mapping[2] - 1, end_num].min
        water_ranges << (mapping[0] + start_num - mapping[1]..range_end)
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif map_range.cover?(end_num)
        next if finished
        range_start = [mapping[0], start_num].max
        water_ranges << (range_start..mapping[0] + end_num - mapping[1])
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    water_ranges << (start_num..end_num) unless finished
  end
  water_ranges
end

def get_light_ranges(ranges)
  light_ranges = []
  ranges.each do |range|
    start_num = range.first
    end_num = range.last
    offset = end_num - start_num + 1
    mappings = @data[@water_to_light_start+1..@light_to_temperature_start-1].map{|line| line.split(" ").map(&:to_i)}
    finished = false
    mappings.reverse.each do |mapping|
      map_range = (mapping[1]..mapping[1]+mapping[2]-1)
      if map_range.cover?(range)
        finished = true
        light_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + end_num - mapping[1])
      elsif map_range.cover?(start_num)
        light_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + mapping[2] - 1)
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif map_range.cover?(end_num)
        next if finished
        light_ranges << (mapping[0]..mapping[0] + end_num - mapping[1])
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    light_ranges << (start_num..end_num) unless finished
  end
  light_ranges
end

def get_temperature_ranges(ranges)
  temperature_ranges = []
  ranges.each do |range|
    start_num = range.first
    end_num = range.last
    offset = end_num - start_num + 1
    mappings = @data[@light_to_temperature_start+1..@temperature_to_humidity_start-1].map{|line| line.split(" ").map(&:to_i)}
    finished = false
    mappings.reverse.each do |mapping|
      map_range = (mapping[1]..mapping[1]+mapping[2]-1)
      if map_range.cover?(range)
        finished = true
        temperature_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + end_num - mapping[1])
      elsif map_range.cover?(start_num)
        temperature_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + mapping[2] - 1)
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif map_range.cover?(end_num)
        next if finished
        temperature_ranges << (mapping[0]..mapping[0] + end_num - mapping[1])
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    temperature_ranges << (start_num..end_num) unless finished
  end
  temperature_ranges
end

def get_humidity_ranges(ranges)
  humidity_ranges = []
  ranges.each do |range|
    start_num = range.first
    end_num = range.last
    offset = end_num - start_num + 1
    mappings = @data[@temperature_to_humidity_start+1..@humidity_to_location_start-1].map{|line| line.split(" ").map(&:to_i)}
    finished = false
    mappings.reverse.each do |mapping|
      map_range = (mapping[1]..mapping[1]+mapping[2]-1)
      if map_range.cover?(range)
        finished = true
        humidity_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + end_num - mapping[1])
      elsif map_range.cover?(start_num)
        humidity_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + mapping[2] - 1)
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif map_range.cover?(end_num)
        next if finished
        humidity_ranges << (mapping[0]..mapping[0] + end_num - mapping[1])
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    humidity_ranges << (start_num..end_num) unless finished
  end
  humidity_ranges
end

def get_location_ranges(ranges)
  location_ranges = []
  ranges.each do |range|
    start_num = range.first
    end_num = range.last
    offset = end_num - start_num + 1
    mappings = @data[@humidity_to_location_start+1..-1].map{|line| line.split(" ").map(&:to_i)}
    finished = false
    mappings.reverse.each do |mapping|
      map_range = (mapping[1]..mapping[1]+mapping[2]-1)
      if map_range.cover?(range)
        finished = true
        location_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + end_num - mapping[1])
      elsif map_range.cover?(start_num)
        location_ranges << (mapping[0] + start_num - mapping[1]..mapping[0] + mapping[2] - 1)
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif map_range.cover?(end_num)
        next if finished
        location_ranges << (mapping[0]..mapping[0] + end_num - mapping[1])
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    location_ranges << (start_num..end_num) unless finished
  end
  location_ranges
end

def part1
  min = 999999999999999999999999
  @seeds.each do |seed|
    soil = get_soil(seed)
    fertilizer = get_fertilizer(soil)
    water = get_water(fertilizer)
    light = get_light(water)
    temperature = get_temperature(light)
    humidity = get_humidity(temperature)
    location = get_location(humidity)
    if location < min
      min = location
    end
  end
  min
end

def part2
  min = 999999999999999999999999
  seed_ranges = @seeds.each_slice(2).to_a
  seed_ranges = seed_ranges.map do |range|
    start_num = range[0]
    offset = range[1]
    end_num = start_num + offset - 1
    (start_num..end_num)
  end
  p seed_ranges
  soil_ranges = get_soil_ranges(seed_ranges)
  p soil_ranges
  fertilizer_ranges = get_fertilizer_ranges(soil_ranges)
  p fertilizer_ranges
  water_ranges = get_water_ranges(fertilizer_ranges)
  p water_ranges
  light_ranges = get_light_ranges(water_ranges)
  p light_ranges
  temperature_ranges = get_temperature_ranges(light_ranges)
  p temperature_ranges
  humidity_ranges = get_humidity_ranges(temperature_ranges)
  p humidity_ranges
  location_ranges = get_location_ranges(humidity_ranges)
  p location_ranges
  location_ranges = location_ranges.map do |range|
    range.first
  end
  p location_ranges.sort!
  location_ranges.min
end

def part2_brute_force
  min = 999999999999999999999999
  seed_ranges = @seeds.each_slice(2).to_a
  seed_ranges.each_with_index do |seed_range,i|
    p "Seed Range: #{i} out of #{seed_ranges.length}"
    start_num = seed_range[0]
    end_num = seed_range[0] + seed_range[1] - 1
    p "Seed Range: #{end_num - start_num} seeds"
    for j in start_num..end_num
      p "percent complete: #{(j-start_num).to_f/(end_num-start_num).to_f*100.0}%" if j % 10000 == 0
      soil = get_soil(j)
      fertilizer = get_fertilizer(soil)
      water = get_water(fertilizer)
      light = get_light(water)
      temperature = get_temperature(light)
      humidity = get_humidity(temperature)
      location = get_location(humidity)
      if location < min
        min = location
      end
    end
  end
  min
end

start = Time.now
p "Part 1: " + part1.to_s
p "Part 2: " + part2.to_s
p "Finished in #{Time.now - start} seconds."
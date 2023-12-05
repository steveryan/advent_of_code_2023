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
    start_num = range[0]
    offset = range[1]
    end_num = start_num + offset - 1
    mappings = @data[@seed_to_soil_start+1..@soil_to_fertilizer_start-1].map{|line| line.split(" ").map(&:to_i)}
    found_whole_range = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && end_num <= mapping[1] + mapping[2]
        found_whole_range = true
        soil_ranges << [mapping[0] + start_num - mapping[1], offset]
      end
    end
    next if found_whole_range
    finished = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && start_num <= mapping[1] + mapping[2] - 1
        soil_ranges << [mapping[0] + start_num - mapping[1],[end_num-start_num+1, ((mapping[0]+mapping[2]) - (mapping[0] + (start_num - mapping[1]))).abs].min]
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif end_num >= mapping[1] && end_num <= mapping[1] + mapping[2] - 1
        next if finished
        soil_ranges << [[mapping[0],start_num].max, end_num - mapping[1]+1]
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    soil_ranges << [start_num, end_num-start_num+1] unless finished
  end
  soil_ranges
end

def get_fertilizer_ranges(ranges)
  fertilizer_ranges = []
  ranges.each do |range|
    start_num = range[0]
    offset = range[1]
    end_num = start_num + offset - 1
    mappings = @data[@soil_to_fertilizer_start+1..@fertilizer_to_water_start-1].map{|line| line.split(" ").map(&:to_i)}
    found_whole_range = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && end_num <= mapping[1] + mapping[2]
        found_whole_range = true
        fertilizer_ranges << [mapping[0] + start_num - mapping[1], offset]
      end
    end
    next if found_whole_range
    finished = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && start_num <= mapping[1] + mapping[2] - 1
        fertilizer_ranges << [mapping[0] + start_num - mapping[1],[end_num-start_num+1, ((mapping[0]+mapping[2]) - (mapping[0] + (start_num - mapping[1]))).abs].min]
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif end_num >= mapping[1] && end_num <= mapping[1] + mapping[2] - 1
        next if finished
        fertilizer_ranges << [[mapping[0],start_num].max, end_num - mapping[1]+1]
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    fertilizer_ranges << [start_num, end_num-start_num+1] unless finished
  end
  fertilizer_ranges
end

def get_water_ranges(ranges)
  water_ranges = []
  ranges.each do |range|
    start_num = range[0]
    offset = range[1]
    end_num = start_num + offset - 1
    mappings = @data[@fertilizer_to_water_start+1..@water_to_light_start-1].map{|line| line.split(" ").map(&:to_i)}
    found_whole_range = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && end_num <= mapping[1] + mapping[2]
        found_whole_range = true
        water_ranges << [mapping[0] + start_num - mapping[1], offset]
      end
    end
    next if found_whole_range
    finished = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && start_num <= mapping[1] + mapping[2] - 1
        water_ranges << [mapping[0] + start_num - mapping[1],[end_num-start_num+1, ((mapping[0]+mapping[2]) - (mapping[0] + (start_num - mapping[1]))).abs].min]
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif end_num >= mapping[1] && end_num <= mapping[1] + mapping[2] - 1
        next if finished
        water_ranges << [[mapping[0],start_num].max, end_num - mapping[1]+1]
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    water_ranges << [start_num, end_num-start_num+1] unless finished
  end
  water_ranges
end

def get_light_ranges(ranges)
  light_ranges = []
  ranges.each do |range|
    start_num = range[0]
    offset = range[1]
    end_num = start_num + offset - 1
    mappings = @data[@water_to_light_start+1..@light_to_temperature_start-1].map{|line| line.split(" ").map(&:to_i)}
    found_whole_range = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && end_num <= mapping[1] + mapping[2]
        found_whole_range = true
        light_ranges << [mapping[0] + start_num - mapping[1], offset]
      end
    end
    next if found_whole_range
    finished = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && start_num <= mapping[1] + mapping[2] - 1
        light_ranges << [mapping[0] + start_num - mapping[1],[end_num-start_num+1, ((mapping[0]+mapping[2]) - (mapping[0] + (start_num - mapping[1]))).abs].min]
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif end_num >= mapping[1] && end_num <= mapping[1] + mapping[2] - 1
        next if finished
        light_ranges << [[mapping[0],start_num].max, end_num - mapping[1]+1]
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    light_ranges << [start_num, end_num-start_num+1] unless finished
  end
  light_ranges
end

def get_temperature_ranges(ranges)
  temperature_ranges = []
  ranges.each do |range|
    start_num = range[0]
    offset = range[1]
    end_num = start_num + offset - 1
    mappings = @data[@light_to_temperature_start+1..@temperature_to_humidity_start-1].map{|line| line.split(" ").map(&:to_i)}
    found_whole_range = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && end_num <= mapping[1] + mapping[2]
        found_whole_range = true
        temperature_ranges << [mapping[0] + start_num - mapping[1], offset]
      end
    end
    next if found_whole_range
    finished = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && start_num <= mapping[1] + mapping[2] - 1
        next if start_num > end_num
        temperature_ranges << [mapping[0] + start_num - mapping[1],[end_num-start_num+1, ((mapping[0]+mapping[2]) - (mapping[0] + (start_num - mapping[1]))).abs].min]
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif end_num >= mapping[1] && end_num <= mapping[1] + mapping[2] - 1
        next if finished
        temperature_ranges << [[mapping[0],start_num].max, end_num - mapping[1]+1]
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    temperature_ranges << [start_num, end_num-start_num+1] unless finished
  end
  temperature_ranges
end

def get_humidity_ranges(ranges)
  humidity_ranges = []
  ranges.each do |range|
    start_num = range[0]
    offset = range[1]
    end_num = start_num + offset - 1
    mappings = @data[@temperature_to_humidity_start+1..@humidity_to_location_start-1].map{|line| line.split(" ").map(&:to_i)}
    found_whole_range = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && end_num <= mapping[1] + mapping[2]
        found_whole_range = true
        humidity_ranges << [mapping[0] + start_num - mapping[1], offset]
      end
    end
    next if found_whole_range
    finished = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && start_num <= mapping[1] + mapping[2] - 1
        humidity_ranges << [mapping[0] + start_num - mapping[1],[end_num-start_num+1, ((mapping[0]+mapping[2]) - (mapping[0] + (start_num - mapping[1]))).abs].min]
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif end_num >= mapping[1] && end_num <= mapping[1] + mapping[2] - 1
        next if finished
        humidity_ranges << [[mapping[0],start_num].max, end_num - mapping[1]+1]
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    humidity_ranges << [start_num, end_num-start_num+1] unless finished
  end
  humidity_ranges
end

def get_location_ranges(ranges)
  location_ranges = []
  ranges.each do |range|
    start_num = range[0]
    offset = range[1]
    end_num = start_num + offset - 1
    mappings = @data[@humidity_to_location_start+1..-1].map{|line| line.split(" ").map(&:to_i)}
    found_whole_range = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && end_num <= mapping[1] + mapping[2]
        found_whole_range = true
        location_ranges << [mapping[0] + start_num - mapping[1], offset]
      end
    end
    next if found_whole_range
    finished = false
    mappings.reverse.each do |mapping|
      if start_num >= mapping[1] && start_num <= mapping[1] + mapping[2] - 1
        location_ranges << [mapping[0] + start_num - mapping[1],[end_num-start_num+1, (((mapping[0]+mapping[2]) - (mapping[0] + (start_num - mapping[1]))).abs).abs].min]
        start_num = mapping[1] + mapping[2]
        finished = true if start_num > end_num
      elsif end_num >= mapping[1] && end_num <= mapping[1] + mapping[2] - 1
        next if finished
        location_ranges << [[mapping[0],start_num].max, end_num - mapping[1]+1]
        end_num = mapping[1] - 1
        finished = true if start_num > end_num
      end
      break if finished
    end
    location_ranges << [start_num, end_num-start_num+1] unless finished
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
  p "Seed ranges: #{seed_ranges.map { |x| [x[0], x[0]+x[1]-1] } } "
  soil_ranges = get_soil_ranges(seed_ranges)
  p "Soil ranges: #{soil_ranges.map { |x| [x[0], x[0]+x[1]-1] } }"
  fertilizer_ranges = get_fertilizer_ranges(soil_ranges)
  p "Fertilizer ranges: #{fertilizer_ranges.map { |x| [x[0], x[0]+x[1]-1] } }"
  water_ranges = get_water_ranges(fertilizer_ranges)
  p "Water ranges: #{water_ranges.map { |x| [x[0], x[0]+x[1]-1] } }"
  light_ranges = get_light_ranges(water_ranges)
  p "Light ranges: #{light_ranges.map { |x| [x[0], x[0]+x[1]-1] } }"
  temperature_ranges = get_temperature_ranges(light_ranges)
  p "Temperature ranges: #{temperature_ranges.map { |x| [x[0], x[0]+x[1]-1] } }"
  humidity_ranges = get_humidity_ranges(temperature_ranges)
  p "Humidity ranges: #{humidity_ranges.map { |x| [x[0], x[0]+x[1]-1] } }"
  location_ranges = get_location_ranges(humidity_ranges)
  p "Location ranges: #{location_ranges}"
  location_ranges = location_ranges.map do |range|
    range[0].to_i
  end
  p location_ranges.sort.first(25)
  location_ranges.min
end

start = Time.now
p "Part 1: " + part1.to_s
p "Part 2: " + part2.to_s
p "Finished in #{Time.now - start} seconds."
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

def part2_elegant_brute_force
  seed_ranges = @seeds.each_slice(2).to_a
  seed_ranges = seed_ranges.map do |range|
    start_num = range[0]
    offset = range[1]
    end_num = start_num + offset - 1
    (start_num..end_num)
  end
  
  min = 9999999999999
  randomizer = Random.new
  
  100000.times do |i|
    location_to_check = randomizer.rand(0..min)
    seed = get_seed_from_location(location_to_check)
    if seed_ranges.any?{|range| range.cover?(seed)}
      min = location_to_check
    end
  end

  found_one = true
  location = min
  while found_one
    location -= 1
    seed = get_seed_from_location(location)
    if seed_ranges.any?{|range| range.cover?(seed)}
      found_one = true
    else
      found_one = false
      location += 1
    end
  end
  location
end

def get_seed_from_location(location_to_check)
  humidity = get_humidity_rev(location_to_check)
  temperature = get_temperature_rev(humidity)
  light = get_light_rev(temperature)
  water = get_water_rev(light)
  fertilizer = get_fertilizer_rev(water)
  soil = get_soil_rev(fertilizer)
  seed = get_seeds_rev(soil)
end

def get_humidity_rev(location)
  ranges = @data[@humidity_to_location_start+1..-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if location >= range[0] && location <= range[0]+range[2]-1
      return range[1] + location - range[0]
    end
  end
  return location
end

def get_temperature_rev(humidity)
  ranges = @data[@temperature_to_humidity_start+1..@humidity_to_location_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if humidity >= range[0] && humidity <= range[0]+range[2]-1
      return range[1] + humidity - range[0]
    end
  end
  return humidity
end

def get_light_rev(temperature)
  ranges = @data[@light_to_temperature_start+1..@temperature_to_humidity_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if temperature >= range[0] && temperature <= range[0]+range[2]-1
      return range[1] + temperature - range[0]
    end
  end
  return temperature
end

def get_water_rev(light)
  ranges = @data[@water_to_light_start+1..@light_to_temperature_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if light >= range[0] && light <= range[0]+range[2]-1
      return range[1] + light - range[0]
    end
  end
  return light
end

def get_fertilizer_rev(water)
  ranges = @data[@fertilizer_to_water_start+1..@water_to_light_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if water >= range[0] && water <= range[0]+range[2]-1
      return range[1] + water - range[0]
    end
  end
  return water
end

def get_soil_rev(fertilizer)
  ranges = @data[@soil_to_fertilizer_start+1..@fertilizer_to_water_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if fertilizer >= range[0] && fertilizer <= range[0]+range[2]-1 
      return range[1] + fertilizer - range[0]
    end
  end
  return fertilizer
end

def get_seeds_rev(soil)
  ranges = @data[@seed_to_soil_start+1..@soil_to_fertilizer_start-1].map{|line| line.split(" ").map(&:to_i)}
  ranges.reverse.each do |range|
    if soil >= range[0] && soil <= range[0]+range[2]-1
      return range[1] + soil - range[0]
    end
  end
  return soil
end



start = Time.now
p "Part 1: " + part1.to_s
p "Part 2: " + part2_elegant_brute_force.to_s
p "Finished in #{Time.now - start} seconds."
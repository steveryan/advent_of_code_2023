data = File.read("data/day_1.txt").lines.map(&:strip)

def build_calibration_lines(data)
  calibration_lines = data.map do |line|
    first_num = nil
    last_num = nil
    index = 0
    while first_num.nil? || last_num.nil?
      unless first_num
        first_num = line[index] if line[index].match?(/[[:digit:]]/)
      end
      reverse_index = line.length - index - 1
      unless last_num
        last_num = line[reverse_index] if line[reverse_index].match?(/[[:digit:]]/)
      end
      index += 1
    end
    combined_string = first_num + last_num
    combined_string.to_i
  end
  calibration_lines
end

def build_calibration_lines2(data)
  calibration_lines = data.map do |line|
    first_num = nil
    last_num = nil
    index = 0
    while first_num.nil? || last_num.nil?
      unless first_num
        if line[index].match?(/[[:digit:]]/)
          first_num = line[index] 
        else
          num = get_string_num(index, line)
          if num
            first_num = num
          end
        end
      end
      reverse_index = line.length - index - 1
      unless last_num
        if line[reverse_index].match?(/[[:digit:]]/)
          last_num = line[reverse_index] 
        else
          num = get_reverse_string_num(reverse_index, line)
          if num
            last_num = num
          end
        end
      end
      index += 1
    end
    combined_string = first_num + last_num
    combined_string.to_i
  end
  calibration_lines
end

def get_string_num(index, line)
  line = line.chars
  num = nil
  if line[index..index+2].join =="one"
    return "1"
  elsif line[index..index+2].join =="two"
    return "2"
  elsif line[index..index+4].join =="three"
    return "3"
  elsif line[index..index+3].join =="four"
    return "4"
  elsif line[index..index+3].join =="five"
    return "5"
  elsif line[index..index+2].join =="six"
    return "6"
  elsif line[index..index+4].join =="seven"
    return "7"
  elsif line[index..index+4].join =="eight"
    return "8"
  elsif line[index..index+3].join =="nine"
    return "9"
  end
  nil
end

def get_reverse_string_num(index, line)
  line = line.chars
  num = nil
  if line[index-2..index].join =="one"
    return "1"
  elsif line[index-2..index].join =="two"
    return "2"
  elsif line[index-4..index].join =="three"
    return "3"
  elsif line[index-3..index].join =="four"
    return "4"
  elsif line[index-3..index].join =="five"
    return "5"
  elsif line[index-2..index].join =="six"
    return "6"
  elsif line[index-4..index].join =="seven"
    return "7"
  elsif line[index-4..index].join =="eight"
    return "8"
  elsif line[index-3..index].join =="nine"
    return "9"
  end
  nil
end

def part1(data)
  calibration_lines = build_calibration_lines(data)
  p "Calibration lines: #{calibration_lines}"
  calibration_lines.sum
end

def part2(data)
  calibration_lines = build_calibration_lines2(data)
  p "Calibration lines: #{calibration_lines}"
  calibration_lines.sum
end

# p "Part 1: #{part1(data)}"
p "Part 2: #{part2(data)}"
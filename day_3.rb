data ||= File.read("data/day_3.txt").lines.map(&:strip)

def make_matrix(data)
  matrix = data.map do |line|
    line.chars
  end
end

def get_numbers_and_gears_hash(matrix)
  numbers = {}
  gears = {}
  matrix.each_with_index do |row, i|
    part_of_number = {}
    row.each_with_index do |cell, j|
      if cell == "*"
        gears[[i,j]] = []
      end
      next if part_of_number[[i,j]]
      if cell.match?(/[[:digit:]]/)
        # this means that we have an engine part, so we need to check how long the number is
        start_index = [i,j]
        end_index = [i,j]
        num_string = matrix[i][j]
        while end_index[1] < matrix[i].length-1 && matrix[i][end_index[1]+1].match?(/[[:digit:]]/)
          end_index[1] += 1
          num_string += matrix[i][end_index[1]]
          part_of_number[[i,end_index[1]]] = true
        end
        numbers[[i,start_index[1],end_index[1]]] = num_string.to_i
      end
    end
  end
  return numbers, gears
end

def get_sum_from_numbers_hash(numbers, matrix)
  sum = 0
  numbers.each do |key, value|
    row = key[0]
    start_col = key[1]
    end_col = key[2]
    number = value
    borders_a_symbol = false
    for i in start_col..end_col
      if i == start_col
        if row > 0 && i > 0 && matrix[row-1][i-1] != "." && !matrix[row-1][i-1].match?(/[[:digit:]]/)
          borders_a_symbol = true
          break
        end
        if i > 0 && matrix[row][i-1] != "." && !matrix[row][i-1].match?(/[[:digit:]]/)
          borders_a_symbol = true
          break
        end
        if row < matrix.length-1 && i > 0 && matrix[row+1][i-1] != "." && !matrix[row+1][i-1].match?(/[[:digit:]]/)
          borders_a_symbol = true
          break
        end
      end
      if i == end_col
        if row > 0 && i < matrix[row].length-1 && matrix[row-1][i+1] != "." && !matrix[row-1][i+1].match?(/[[:digit:]]/)
          borders_a_symbol = true
          break
        end
        if i < matrix[row].length-1 && matrix[row][i+1] != "." && !matrix[row][i+1].match?(/[[:digit:]]/)
          borders_a_symbol = true
          break
        end
        if row < matrix.length-1 && i < matrix[row].length-1 && matrix[row+1][i+1] != "." && !matrix[row+1][i+1].match?(/[[:digit:]]/)
          borders_a_symbol = true
          break
        end
      end
      if row > 0 && matrix[row-1][i] != "." && !matrix[row-1][i].match?(/[[:digit:]]/)
        borders_a_symbol = true
        break
      end
      if row < matrix.length-1 && matrix[row+1][i] != "." && !matrix[row+1][i].match?(/[[:digit:]]/)
        borders_a_symbol = true
        break
      end
    end
    if borders_a_symbol
      sum += number
    end
  end
  sum
end

def get_sum_of_gear_ratios(gears, numbers, matrix)
  sum = 0
  numbers.each do |key, value|
    row = key[0]
    start_col = key[1]
    end_col = key[2]
    number = value
    for i in start_col..end_col
      if i == start_col
        if row > 0 && i > 0 && matrix[row-1][i-1] == "*"
          gears[[row-1,i-1]] << number
          break
        end
        if i > 0 && matrix[row][i-1] == "*"
          gears[[row,i-1]] << number
          break
        end
        if row < matrix.length-1 && i > 0 && matrix[row+1][i-1] == "*"
          gears[[row+1,i-1]] << number
          break
        end
      end
      if i == end_col
        if row > 0 && i < matrix[row].length-1 && matrix[row-1][i+1] == "*"
          gears[[row-1,i+1]] << number
          break
        end
        if i < matrix[row].length-1 && matrix[row][i+1] == "*"
          gears[[row,i+1]] << number
          break
        end
        if row < matrix.length-1 && i < matrix[row].length-1 && matrix[row+1][i+1] == "*"
          gears[[row+1,i+1]] << number
          break
        end
      end
      if row > 0 && matrix[row-1][i] == "*"
        gears[[row-1,i]] << number
        break
      end
      if row < matrix.length-1 && matrix[row+1][i] == "*"
        gears[[row+1,i]] << number
        break
      end
    end
  end
  gears.each do |key, value|
    if value.length == 2
      sum += value[0] * value[1]
    end
  end
  sum
end

def part1(data)
  matrix = make_matrix(data)
  numbers, gears = get_numbers_and_gears_hash(matrix)
  sum = get_sum_from_numbers_hash(numbers, matrix)
  sum
end

def part2(data)
  matrix = make_matrix(data)
  numbers, gears = get_numbers_and_gears_hash(matrix)
  sum_of_gears = get_sum_of_gear_ratios(gears, numbers, matrix)
end

start = Time.now
p "Part 1: " + part1(data).to_s
p "Part 2: " + part2(data).to_s
p "Finished in #{Time.now - start} seconds."
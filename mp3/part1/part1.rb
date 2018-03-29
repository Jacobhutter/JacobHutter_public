require 'matrix'

def print_num( num, image_topography)
    prev_row = 0
    image_topography[num].each_with_index do |feature, row, col|
        if prev_row != row
            prev_row = row
            print "\n"
        end

        if Math.log(feature) < (-5)
            print '█'.blue
        elsif Math.log(feature) < (-2)
            print '█'.magenta
        elsif Math.log(feature) < (-1)
            print '█'.cyan
        else
            print '█'.red
        end
    end
    print "\n\n"
end

class String
def black;          "\e[30m#{self}\e[0m" end
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def cyan;           "\e[36m#{self}\e[0m" end
def gray;           "\e[37m#{self}\e[0m" end

def bg_black;       "\e[40m#{self}\e[0m" end
def bg_red;         "\e[41m#{self}\e[0m" end
def bg_green;       "\e[42m#{self}\e[0m" end
def bg_brown;       "\e[43m#{self}\e[0m" end
def bg_blue;        "\e[44m#{self}\e[0m" end
def bg_magenta;     "\e[45m#{self}\e[0m" end
def bg_cyan;        "\e[46m#{self}\e[0m" end
def bg_gray;        "\e[47m#{self}\e[0m" end

def bold;           "\e[1m#{self}\e[22m" end
def italic;         "\e[3m#{self}\e[23m" end
def underline;      "\e[4m#{self}\e[24m" end
def blink;          "\e[5m#{self}\e[25m" end
def reverse_color;  "\e[7m#{self}\e[27m" end
end

image_topography = [Matrix.zero(32,32),Matrix.zero(32,32),Matrix.zero(32,32),Matrix.zero(32,32),Matrix.zero(32,32),Matrix.zero(32,32),Matrix.zero(32,32),Matrix.zero(32,32),Matrix.zero(32,32),Matrix.zero(32,32)]
File.open("digitdata/optdigits-orig_train.txt", "r") do |f|
  sub_im = Matrix.empty()
  f.each_line do |line|
    if line.size < 30
        line_index = line.gsub(/\s+/, "").to_i
        image_topography[line_index] = sub_im + image_topography[line_index]
        sub_im = Matrix.empty()
    else
        sub_im = Matrix.rows(sub_im.to_a << line.gsub(/\n+/,"").chars.each.map(&:to_i))
    end
  end
end

k = 0.1 # experiment with smoothing factor
image_topography.each_with_index do |mask, index|
    image_topography[index] = mask.map{|e| ((e+k)/(251.0+(2.0*k)))}
end

one_count = 0
map_rule = [Matrix.empty(), Matrix.empty(), Matrix.empty(), Matrix.empty(),
Matrix.empty(), Matrix.empty(), Matrix.empty(),
Matrix.empty(), Matrix.empty(), Matrix.empty()]

sol_array = Matrix.empty()

File.open("digitdata/optdigits-orig_test.txt", "r") do |f|
  sub_im = Matrix.empty()
  f.each_line do |line|
    if line.size < 30
        line_index = line.gsub(/\s+/, "").to_i
        sol_array = Matrix.rows(sol_array.to_a << [line_index])
        test_im = sub_im
        sub_im = Matrix.empty()
        map_rule.each_with_index do |c, index|
            val = 0.0
            test_im.each_with_index do |feature, row, col|
                if(feature == 1)
                    val += Math.log(image_topography[index].element(row, col))
                end
            end
            map_rule[index] = Matrix.rows(c.to_a << [val]) # append row to matrix for this particular class
        end
    else
        sub_im = Matrix.rows(sub_im.to_a << line.gsub(/\n+/,"").chars.each.map(&:to_i))
    end
  end
end

occurrences = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
guesses = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
classification_accuracy = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
confusion_matrix = Array.new(10){Array.new(10, 0)}

map_rule[0].each_with_index do |score, test_im_row|
    guess =  [map_rule[0].element(test_im_row,0), map_rule[1].element(test_im_row,0),map_rule[2].element(test_im_row,0),map_rule[3].element(test_im_row,0),
    map_rule[4].element(test_im_row,0),map_rule[5].element(test_im_row,0),map_rule[6].element(test_im_row,0),map_rule[7].element(test_im_row,0),map_rule[8].element(test_im_row,0),map_rule[9].element(test_im_row,0)].each_with_index.max[1]
    confusion_matrix[guess][sol_array.element(test_im_row, 0)] += 1
    occurrences[sol_array.element(test_im_row, 0)] += 1
    if guess == sol_array.element(test_im_row, 0)
        guesses[guess] += 1
    end
end

confusion_matrix.each_with_index do |count_row, row|
    count_row.each_with_index do |count, col|
        confusion_matrix[row][col] = (confusion_matrix[row][col].to_f/occurrences[col]).round(1)
    end
end

average = 0
min_drop = 100
guesses.each_with_index do |guess, index|
    classification_accuracy[index] = (1 - ((guesses[index].to_f - occurrences[index]).abs/occurrences[index].to_f))
    print "Accuracy for digit ", index, ": ", 100*classification_accuracy[index], " %\n"
    if classification_accuracy[index] < min_drop
        min_drop = classification_accuracy[index]
    end
    average += classification_accuracy[index]
end


print "Accuracy unweighted average: ", 10 * average, " %\n"
print "Confusion Matrix (each column is a golden value, each row is a guess value): \n"
print confusion_matrix[0], "\n"
print confusion_matrix[1], "\n"
print confusion_matrix[2], "\n"
print confusion_matrix[3], "\n"
print confusion_matrix[4], "\n"
print confusion_matrix[5], "\n"
print confusion_matrix[6], "\n"
print confusion_matrix[7], "\n"
print confusion_matrix[8], "\n"
print confusion_matrix[9], "\n"
puts "╔═══════════════╗\n║ Starting Odds ║\n╚═══════════════╝"
puts "╔═════════╗\n║ 8 <=> 2 ║\n╚═════════╝\n"

print_num( 8, image_topography)
print_num( 2, image_topography)

prev_row = 0
image_topography[2].each_with_index do |feature, row, col|
    if prev_row != row
        prev_row = row
        print "\n"
    end

    cur = Math.log(feature) - Math.log(image_topography[8].element(row,col))
    # cur
    if cur < (0)
        print '█'.blue
    elsif cur < (0.2)
        print '█'.magenta
    elsif cur < (1)
        print '█'.cyan
    else
        print '█'.red
    end
end
print "\n\n"
puts "╔═════════╗\n║ 9 <=> 5 ║\n╚═════════╝\n"
print_num( 9, image_topography)
print_num( 5, image_topography)
prev_row = 0
image_topography[5].each_with_index do |feature, row, col|
    if prev_row != row
        prev_row = row
        print "\n"
    end

    cur = Math.log(feature) - Math.log(image_topography[9].element(row,col))
    # cur
    if cur < (0)
        print '█'.blue
    elsif cur < (0.2)
        print '█'.magenta
    elsif cur < (1)
        print '█'.cyan
    else
        print '█'.red
    end
end
puts "\n"
puts "╔═════════╗\n║ 1 <=> 5 ║\n╚═════════╝\n"
print_num( 1, image_topography)
print_num( 5, image_topography)
prev_row = 0
image_topography[5].each_with_index do |feature, row, col|
    if prev_row != row
        prev_row = row
        print "\n"
    end

    cur = Math.log(feature) - Math.log(image_topography[1].element(row,col))
    # cur
    if cur < (0)
        print '█'.blue
    elsif cur < (0.2)
        print '█'.magenta
    elsif cur < (1)
        print '█'.cyan
    else
        print '█'.red
    end
end
puts "\n"
puts "╔═════════╗\n║ 9 <=> 3 ║\n╚═════════╝\n"
print_num( 9, image_topography)
print_num( 3, image_topography)
prev_row = 0
image_topography[3].each_with_index do |feature, row, col|
    if prev_row != row
        prev_row = row
        print "\n"
    end

    cur = Math.log(feature) - Math.log(image_topography[9].element(row,col))
    # cur
    if cur < (0)
        print '█'.blue
    elsif cur < (0.2)
        print '█'.magenta
    elsif cur < (1)
        print '█'.cyan
    else
        print '█'.red
    end
end
puts "\n"

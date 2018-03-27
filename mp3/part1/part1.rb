require 'matrix'

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
        confusion_matrix[row][col] = (confusion_matrix[row][col].to_f/occurrences[col]).round(4)
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

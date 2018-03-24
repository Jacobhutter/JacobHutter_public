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

k = 1 # experiment with smoothing factor
image_topography.each_with_index do |mask, index|
    image_topography[index] = mask.map{|e| (e/240.0) + k/(240.0*k)}
end

one_count = 0
map_rule = [Matrix.zero(1,1), Matrix.zero(1,1), Matrix.zero(1,1), Matrix.zero(1,1),
Matrix.zero(1,1), Matrix.zero(1,1), Matrix.zero(1,1),
Matrix.zero(1,1), Matrix.zero(1,1), Matrix.zero(1,1)]

File.open("digitdata/optdigits-orig_test.txt", "r") do |f|
  sub_im = Matrix.empty()
  f.each_line do |line|
    if line.size < 30
        line_index = line.gsub(/\s+/, "").to_i
        sub_im = Matrix.empty()
        map_rule.each_with_index do |c, index|
            val = 0.0
            image_topography[index].each do |feature|
                # P((fi,j = 1) | class = c) = P(class = c | fi,j = 1)P(class = c = 1/10)
                #                             ------------------------------------------
                #                                           P(fi,j = 1)
                val += (Math.log(feature) + Math.log(0.1)) - Math.log(one_count.to_f/1024)
                #val += Math.log((feature*0.1)/(one_count.to_f/1024))
            end
            map_rule[index] = Matrix.rows(c.to_a << [val]) # append row to matrix for this particular class
        end
        one_count = 0
    else
        one_count += line.count('1')
        sub_im = Matrix.rows(sub_im.to_a << line.gsub(/\n+/,"").chars.each.map(&:to_i))
    end
  end
end
print map_rule[0]

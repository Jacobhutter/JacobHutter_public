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

print image_topography

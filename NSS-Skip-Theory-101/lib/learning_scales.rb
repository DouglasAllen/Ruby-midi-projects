require_relative "scales_major_sharps"
require_relative "scales_minor_sharps"
require_relative "scales_major_flats"
require_relative "scales_minor_flats"


print "Enter a scale: "
scale = gets.chomp

scale_answer = Scales.new(scale).generate_scale

puts scale_answer


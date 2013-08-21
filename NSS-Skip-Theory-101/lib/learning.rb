require_relative "scales_major_sharps"
require_relative "scales_minor_sharps"
require_relative "scales_major_flats"
require_relative "scales_minor_flats"
require_relative "chords_major_sharps"
require_relative "chords_minor_sharps"
require_relative "chords_major_flats"
require_relative "chords_minor_flats"

class Learning
  def process
    print "What would you like to learn about? Chords or Scales?  "
    first_response = clean_gets
    if first_response =~ /^chord/
      learning_chords
    elsif first_response =~ /^scale/
      learning_scales
    elsif first_response =~ /(exit)|(^q)/
      #exit the program
    else
      puts "I didn't quite understand that; try again please."
      process
    end
  end

  def clean_gets
    gets.chomp.downcase.strip
  end

  def rerun_or_exit
    print "Would you like to try some more? Yes or No: "
    rerun_response = clean_gets
    process if rerun_response =~ /^y/
  end

  def learning_chords
    print "Enter a chord: "
    chord = clean_gets
    chord_answer = Chords.new(chord).generate_chord
    puts chord_answer
    rerun_or_exit
  end

  def learning_scales
    print "Enter a scale: "
    scale = clean_gets
    scale_answer = Scales.new(scale).generate_scale
    puts scale_answer
    rerun_or_exit
  end
  Learning.new().process
end

require_relative 'chords'

class ChordsMajorSharps < Chords
  def start_index
    SHARPS.index(chord_start_position)
  end

  def major_chord_sharps
    chord_array = []
    scale_for_chord = ScaleFactory.get_scale_for(chord_name)
    chord_array << scale_for_chord.major_scale_sharps[0]
    chord_array << scale_for_chord.major_scale_sharps[2]
    chord_array << scale_for_chord.major_scale_sharps[4]
  end

  def get_notes
    major_chord_sharps.join(" ")
  end
end

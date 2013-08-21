class ChordFactory
  def self.get_chord_for(chord_name)
    # sharps and natruals use SHARPS constant, flats use FLATS
    case chord_name
    when /(^\w|\w[#])(min$)/
      ChordsMinorSharps.new(chord_name)
    when /(^\w[b])(min$)/
      ChordsMinorFlats.new(chord_name)
    when /(^\w|\w[#])(maj$)/
      ChordsMajorSharps.new(chord_name)
    when /(^\w[b])(maj$)/
      ChordsMajorFlats.new(chord_name)
    end
  end
end
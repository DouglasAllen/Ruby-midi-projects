require_relative 'scales'

class ScalesMinorFlats < Scales
  def start_index
    FLATS.index(scale_start_position)
  end

  def minor_scale_flats
    major_scale = []
    major_scale << scale_start_position
    major_scale << FLATS[start_index+2]
    major_scale << FLATS[start_index+3]
    major_scale << FLATS[start_index+5]
    major_scale << FLATS[start_index+7]
    major_scale << FLATS[start_index+8]
    major_scale << FLATS[start_index+10]
    major_scale
  end

  def get_notes
    minor_scale_flats.join(" ")
  end
end

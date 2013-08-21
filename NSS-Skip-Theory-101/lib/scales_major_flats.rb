require_relative 'scales'

class ScalesMajorFlats < Scales
  def start_index
    FLATS.index(scale_start_position)
  end

  def major_scale_flats
    major_scale = []
    major_scale << scale_start_position
    major_scale << FLATS[start_index+2]
    major_scale << FLATS[start_index+4]
    major_scale << FLATS[start_index+5]
    major_scale << FLATS[start_index+7]
    major_scale << FLATS[start_index+9]
    major_scale << FLATS[start_index+11]
    major_scale
  end

  def get_notes
    major_scale_flats.join(" ")
  end
end

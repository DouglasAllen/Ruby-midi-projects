require_relative 'scales'

class ScalesMajorSharps < Scales
  def start_index
    SHARPS.index(scale_start_position)
  end

  def major_scale_sharps
    major_scale = []
    major_scale << scale_start_position
    major_scale << SHARPS[start_index+2]
    major_scale << SHARPS[start_index+4]
    major_scale << SHARPS[start_index+5]
    major_scale << SHARPS[start_index+7]
    major_scale << SHARPS[start_index+9]
    major_scale << SHARPS[start_index+11]
    major_scale
  end

  def get_notes
    major_scale_sharps.join(" ")
  end
end

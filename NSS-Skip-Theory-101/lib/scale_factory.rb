class ScaleFactory
  def self.get_scale_for(scale_name)
  # sharps and natruals use SHARPS constant, flats use FLATS
    case scale_name
    when /(^\w|\w[#])(min$)/
      ScalesMinorSharps.new(scale_name)
    when /(^\w[b])(min$)/
      ScalesMinorFlats.new(scale_name)
    when /(^\w|\w[#])(maj$)/
      ScalesMajorSharps.new(scale_name)
    when /(^\w[b])(maj$)/
      ScalesMajorFlats.new(scale_name)
    end
  end
end

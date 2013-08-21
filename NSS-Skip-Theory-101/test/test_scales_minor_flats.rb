require 'test/unit'
require 'scales_minor_flats'

class ScalesMinorFlatsTest < Test::Unit::TestCase
  def example_scale1
    ScalesMinorFlats.new("amin")
  end 

  def example_scale2
    ScalesMinorFlats.new("dbmin")
  end

  def example_scale3
    ScalesMinorFlats.new("gbbmin")
  end

  def example_scale4
    ScalesMinorFlats.new("Bbmin")
  end

  def test_01a_minor_scale_flats_from_scale_start_position
    assert_equal "Db" , example_scale2.minor_scale_flats[0]
  end

  def test_01b_minor_scale_flats
    assert_equal ["A", "B", "C", "D", "E", "F", "G"] , example_scale1.minor_scale_flats
  end

  def test_01c_minor_scale_flats2
    assert_equal ["Db", "Eb", "E", "Gb", "Ab", "A", "B"] , example_scale2.minor_scale_flats
  end

  def test_01d_minor_scale_flats3
    assert_equal ["Bb", "C", "Db", "Eb", "F", "Gb", "Ab"] , example_scale4.minor_scale_flats
  end

  def test_02_scale_start_position_index
    assert_equal 9 , example_scale1.start_index
    assert_equal 1 , example_scale2.start_index
  end
end
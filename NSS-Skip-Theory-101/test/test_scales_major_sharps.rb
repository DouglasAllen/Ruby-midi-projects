require 'test/unit'
require 'scales_major_sharps'

class ScalesMajorSharpsTest < Test::Unit::TestCase
  def example_scale1
   	ScalesMajorSharps.new("cmaj")
  end 

  def example_scale2
  	ScalesMajorSharps.new("dmaj")
  end

  def example_scale3
  	ScalesMajorSharps.new("dbmaj")
  end

  def example_scale4
  	ScalesMajorSharps.new("Bmaj")
  end

  def test_01a_major_scale_sharps_from_start_position
    assert_equal "D" , example_scale2.major_scale_sharps[0]
  end

  def test_01b_major_scale_sharps
    assert_equal ["C", "D", "E", "F", "G", "A", "B"] , example_scale1.major_scale_sharps
  end

  def test_01c_major_scale_sharps
    assert_equal ["D", "E", "F#", "G", "A", "B", "C#"] , example_scale2.major_scale_sharps
  end

  def test_01d_major_scale_sharps_bmaj
    assert_equal ["B", "C#", "D#", "E", "F#", "G#", "A#"] , example_scale4.major_scale_sharps
  end

  def test_02_start_position_index
    assert_equal 0 , example_scale1.start_index
    assert_equal 2 , example_scale2.start_index
  end

  def test_03_get_notes
    assert_equal "B C# D# E F# G# A#" , example_scale4.get_notes
  end
end
require 'test/unit'
require 'scales'

class ScalesTest < Test::Unit::TestCase
  def example_scale1
   	Scales.new("cmaj")
  end 

  def example_scale2
  	Scales.new("dmaj")
  end

  def example_scale3
  	Scales.new("dbmaj")
  end

  def example_scale4
    Scales.new("bbmaj")
  end
  
  def example_scale5
    Scales.new("bbmin")
  end

  def example_scale6
    Scales.new("f#min")
  end

  def test_01_scale_name_readable
    assert_equal "cmaj" , example_scale1.scale_name
  end

  def test_02_scale_start_position
    assert_equal "C" , example_scale1.scale_start_position
  end

  def test_03a_scale_start_position_not_C
    assert_equal "D" , example_scale2.scale_start_position
  end

  def test_03b_scale_start_position_FLATS_db
    assert_equal "Db" , example_scale3.scale_start_position
  end

  def test_03c_scale_start_position_DNE
    assert_raise ArgumentError do 
    	Scales.new("hmaj").scale_start_position
    end
  end

  def test_04a_generate_scale
    assert_equal "C D E F G A B" , example_scale1.generate_scale
  end

  def test_04b_generate_scale
    assert_equal "D E F# G A B C#" , example_scale2.generate_scale
  end

  def test_04c_generate_scale
    assert_equal "Db Eb F Gb Ab Bb C" , example_scale3.generate_scale
  end

  def test_04d_generate_scale
    assert_equal "Bb C D Eb F G A" , example_scale4.generate_scale
  end

  def test_04e_generate_scale
    assert_equal "Bb C Db Eb F Gb Ab" , example_scale5.generate_scale
  end

  def test_04f_generate_scale
    assert_equal "F# G# A B C# D E" , example_scale6.generate_scale
  end
end
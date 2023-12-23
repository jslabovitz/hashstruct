require 'minitest/autorun'
require 'minitest/power_assert'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'hashstruct'

class Test < Minitest::Test

  def setup
    @h = HashStruct.new(
      date1: '2017-11-01',
      'Date-Time' => '2023-12-23T13:20:00-05:00',
    )
  end

  def test_date
    d1 = @h.date1
    assert { d1.kind_of?(Date) }
    d2 = @h.date_time
    assert { d2.kind_of?(Date) }
  end

end
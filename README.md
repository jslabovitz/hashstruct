HashStruct provides an object based on Hash, but acts like Struct (or OpenStruct), providing helpful
accessors for each key from the get-go. It also magically parses string values when it can (eg, dates,
URIs, numbers, and does so recursively.

You can use HashStruct as a first-class object like this:

    h = HashStruct.new
    h.foo = 1
    h.bar = 'zot'

Or you can pass it a hash of existing values:

    h = HashStruct.new(
      :foo => 1,
      :bar => 'z')

Or simply an existing hash:

    thing = { :foo => 1, :bar => 'z' }
    h = HashStruct.new(thing)

Or because it's a Hash underneath, you can use the '[]' construction method:

    h = HashStruct[
      [:foo, 1], [:bar, 'z']
    ]

Or a combination:

    h = HashStruct.new(
      :foo => 1,
      :bar => 'z')
    h.zot = :x

HashStruct magically converts any values from strings (and sub-arrays/hashes) to native objects, when it can.  Like so:

    h = HashStruct.new(
      :an_int       => '1',                         # => 1
      :a_float      => '1.5',                       # => 1.5
      :a_url        => 'http://foo.com/bar',        # => #<URI::HTTP:0x000001009c6160 URL:http://foo.com/bar>
      :a_date       => '2008-01-02',                # => #<DateTime: 2008-01-02T00:00:00+00:00 (4908935/2,0/1,2299161)>
      :a_date_time  => '2011-06-17 09:36:49 -0700', # => #<DateTime: 2011-06-17T09:36:49-07:00 (212175088609/86400,-7/24,2299161)>
      :a_bool_true  => 'true',                      # => true
      :a_bool_false => 'false',                     # => false
      :a_percentage => '50%',                       # => 0.5
      :an_int_array => %w{1 2 3},                   # => [1, 2, 3]
    )

You can't turn off the magical conversion. (Secret: you could monkey-patch `#convert_value` to
simply return the passed-in object.)

You can also easily subclass HashStruct. You can add helper methods if needed, or accessor methods,
which will be noticed and used by HashStruct. Note that any additional instance variables are not treated
as part of the structure.

  class Thing < HashStruct

    attr_accessor :mul

    def foo_mul
      self.foo * @mul
    end

  end

  t = Thing.new
  t.foo = 2
  t.mul = 2
  t.foo_mul   # => 4
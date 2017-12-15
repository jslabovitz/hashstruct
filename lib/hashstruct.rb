require 'date'
require 'uri'

class HashStruct < Hash

  VERSION = '1.0.0'

  def initialize(args={})
    super()
    args.each { |key, value| self[key] = value }
  end

  def [](key)
    key = key.to_sym
    if methods.include?(key)
      method(key).call
    elsif has_key?(key)
      fetch(key)
    else
      nil
    end
  end

  def []=(key, value)
    if methods.include?(:"#{key}=")
      method(:"#{key}=").call(convert_object(value))
    else
      store(key.to_s.to_sym, convert_object(value))
    end
  end

  def method_missing(method_id, *args)
    method_name = method_id.to_s
    if method_name =~ /=$/
      raise ArgumentError, "wrong number of arguments for method #{method_name.inspect} (#{args.length} for 1)", caller(1) if args.length != 1
      raise TypeError, "can't modify frozen #{self.class}", caller(1) if self.frozen?
      self[method_name.chop.to_sym] = args.first
    else
      raise ArgumentError, "wrong number of arguments (#{args.length} for 0)", caller(1) if args.length != 0
      self[method_id]
    end
  end

  def convert_object(obj)
    case obj
    when String
      case obj
      # URI
      when %r{^(ftp|http|https|mailto):}
        URI.parse(obj) rescue obj
      # integer
      when %r{^-?[1-9][\d,]*$}
        obj.gsub(/,/, '').to_i
      # hex integer
      when %r{^0x[0-9a-f]+$}i
        obj.hex
      # float
      when %r{^-?[\d,]+\.\d+$}
        obj.gsub(/,/, '').to_f
      # percent
      when %r{^-?[\d,]+(\.\d+)?%$}
        obj.to_f / 100
      # rational
      when %r{^(\d+)/(\d+)$}
        Rational($1.to_i, $2.to_i)
      # date
      when %r{^\d{4}-\d{2}-\d{2}},      # 2010-06-06
           %r{^\d{1,2}/\d{1,2}/\d{4}},  # 06/06/2010
           %r{^\d{4}/\d{1,2}/\d{1,2}},  # 2010/06/06
           %r{^(Sun|Mon|Tue|Wed|Thu|Fri|Sat|Sun),?\s*\d*\s*\b(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\b}  # Sun, 06 Jun 2010 23:02:25 GMT
        DateTime.parse(obj)
      # boolean true
      when 'true'
        true
      # boolean false
      when 'false'
        false
      else
        obj
      end
    when Array
      obj.map { |o| convert_object(o) }
    when Hash
      HashStruct.new(obj)
    when HashStruct
      obj
    else
      obj
    end
  end

end

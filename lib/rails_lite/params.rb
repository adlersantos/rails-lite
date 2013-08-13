require 'uri'

class Params
  def initialize(req, route_params)
    @params = {}

    @params.merge!(route_params)
    if req.query_string
      @params.merge!(parse_www_encoded_form(req.query_string))
    end
    if req.body
      @params.merge!(parse_www_encoded_form(req.body))
    end
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    params = {}
    key_value_pairs = URI::decode_www_form(www_encoded_form)

    key_value_pairs.each do |pair|
      keys = parse_key(pair[0])

      sub = {}
      temp = "sub"
      keys[0..-2].each do |key|
        temp += "['#{key}']"
        eval(temp + "= {}")
      end

      temp += "['#{keys.last}']"
      if pair[1].is_a?(String)
        eval(temp + "= '#{pair[1]}'")
      else
        eval(temp + "= #{pair[1]}")
      end

      params = params.deep_merge(sub)
    end

    params
  end

  def parse_key(key)
    if key[0] == '{' && key[-1] == '}'
      key = key[1..-1]
    end
    key.split(/\]\[|\[|\]/)
  end
end

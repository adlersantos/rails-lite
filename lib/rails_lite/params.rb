require 'uri'

module Params
  def self.parse(req, route_params)
    params = {}
    params.merge!(route_params)
    params.merge!(self.parse_www_encoded_form(req.body))
    if req.query_string
      params.merge!(self.parse_www_encoded_form(req.query_string))
    end

    params
  end

  def self.parse_www_encoded_form(www_encoded_form)
    params = {}

    key_values = URI.decode_www_form(www_encoded_form)
    key_values.each do |full_key, value|
      scope = params

      key_seq = parse_key(full_key)
      key_seq.each_with_index do |key, idx|
        if (idx + 1) == key_seq.count
          scope[key] = value
        else
          scope[key] ||= {}
          scope = scope[key]
        end
      end
    end

    params
  end

  def self.parse_key(key)
    match_data = /(?<head>.*)\[(?<rest>.*)\]/.match(key)
    if match_data
      parse_key(match_data["rest"]).unshift(match_data["head"])
    else
      [key]
    end
  end
end

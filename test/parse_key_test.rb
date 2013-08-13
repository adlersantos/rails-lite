require 'uri'
# test = "cat[name]": "Breakfast", "cat[owner]": "Devon"
simple_test = "cat[name]"

def parse_key(key)
  if key[0] == '{' && key[-1] == '}'
    key = key[1..-1]
  end
  key.split(/\]\[|\[|\]/)
end

p parse_key(simple_test)
p parse_key("cat[name][fname]")

# @params = {}

# params_array = [["cat[name][fname]", "gizmo"], ["dog[name]"]...] # this is what's returned by URI::decode

# # iterate through params_array
#   # parse the key (sub_array[0]])
#   # go to that level in params and set it to the value


# params_array.each do |key_value_pair|
#   where_we_are_in_hash = @params

#   # key_value_pair = ["cat[name][fname]", "gizmo"]
#   # key = "cat[name][fname]"

#   parsed_key = ["cat", "name", "fname"]

#   parsed_key.each do |level|
#     # if we're at the end of the array
#       # assign the value
#     # else
#       if where_we_are_in_hash[level] == nil
#       where_we_are_in_hash[level] = {}
#       # params => {"cat" =>  {"name" => {"fname" => "gizmo"} }}

#       where_we_are_in_hash = where_we_are_in_hash[level]

#     end

#   # go to that level in params:
#   # check if
#     # if



class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    method_match = req.request_method.downcase.to_sym == @http_method
    path_match = req.path == @pattern

    method_match && path_match
  end

  def run(req, res)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    # add these helpers in a loop here
    define_method(http_method) do |*args|
      @routes << Route.new(args[0], http_method, args[1], args[2])
    end
  end

  def match(req)
    @routes.detect { |route| self.matches?()}
  end

  def run(req, res)
  end
end

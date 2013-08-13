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
    ControllerBase.new(req, res).invoke_action(@acion_name)
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
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.detect { |route| route.matches?(req)}
  end

  def run(req, res)
    matching_route = match(req)
    res.status = "404" if matching_route.nil?
    matching_route.run(req, res)
  end
end

require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params)
    @req = req
    @res = res

    @params = Params.parse(req, route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    if @rendered.nil?
      false
    else
      @rendered
    end
  end

  def redirect_to(url)
    raise "double render" if already_rendered?

    @res.status = 302
    @res.header['location'] = url
    session.store_session(res)

    @rendered = true
    nil
  end

  def render_content(content, type)
    raise "double render error" if already_rendered?

    @res.content_type = type
    @res.body = content
    session.store_session(@res)

    @rendered = true
    nil
  end

  def render(template_name)
    template_fname =
      File.join("views", self.class.name.underscore, "#{template_name}.html.erb")
    render_content(
      ERB.new(File.read(template_fname)).result(binding),
      "text/html"
    )
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_rendered?

    nil
  end

  # routing
end

require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params={})
    @request, @response = req, res
    @params = Params.new(req, route_params)
  end

  def session
    @session ||= Session.new(@request)
  end

  def already_rendered?
    !!@already_rendered
  end

  def redirect_to(url)
    unless @response_built
      @response.status = "302"
      @response.header["location"] = url

      session.store_session(@response)
      @response_built = true
    end
  end

  def render_content(content, type)
    unless already_rendered?
      @response.content_type = type
      @response.body = content

      session.store_session(@response)
      @already_rendered = true
    end
  end

  def render(template_name)
    file = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    eval_contents = eval("ERB.new(file).result(binding)")
    render_content(eval_contents, 'text/html')
  end

  def invoke_action(action_name)
    send(action_name)

    unless already_rendered?
      render(action_name)
    end
  end
end

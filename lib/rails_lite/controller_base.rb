require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params)
    @request, @response = req, res
    @params = Params.new(req, route_params)

    @already_rendered = false
  end

  def session
    @session ||= Session.new(@request)
  end

  def already_rendered?
    @already_rendered
  end

  def redirect_to(url)
    unless already_rendered?
      @response.status = 302
      @response.header["location"] = url

      session.store_session(@response)
      @already_rendered = true
    end
  end

  def render_content(content, type)
    unless already_rendered?
      @response.content_type = type
      @response.body = content

      session.store_session(@response)
      @already_rendered = true
    end
    nil
  end

  def render(template_name)
    file = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    contents = ERB.new(file).result(binding)
    render_content(contents, 'text/html')
  end

  def invoke_action(action_name)
    self.send(action_name)
    render(action_name) unless already_rendered?
    nil
  end
end

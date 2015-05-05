module ApplicationHelper
  def path_to(*args)
    fragments = args.map do |arg|
      case arg
      when Symbol, String
        "/#{arg.to_s}"
      when Hash
        "/#{arg['_type'].pluralize}/#{arg['id']}"
      else
        binding.pry
        raise ArgumentError
      end
    end

    fragments.join
  end

  def set_title(title)
    content_for :title, "#{title} - #{OpentieRenderer::Application.config.app_name}"
  end

  def response_json
    @response_json || {}
  end

  def my_projects
    response_json['my_projects'] || []
  end

  def my_divisions
    response_json['my_divisions'] || []
  end

  FIELDS = [
    'division', 'project', 'request', 'request_schema',
    'project_history', 'project_comment', 'my_request_schema'
  ]
  
  (FIELDS + FIELDS.map(&:pluralize)).each do |field|
    line = __LINE__ + 1
    self.class_eval %{
      def tie_#{field}
        response_json['#{field}']
      end
    }, __FILE__, line
  end

  def division?
    params[:controller].match /^divisions(\/|$)/
  end

  def project?
    params[:controller].match /^projects(\/|$)/
  end

  def insert_formalizr(wrapper_id, opts)
    content_tag(:div, '', id: wrapper_id) do
      content_tag(:script, type: 'application/json') do
        opts.merge({ authenticityToken: form_authenticity_token }).to_json
      end
    end
  end
end

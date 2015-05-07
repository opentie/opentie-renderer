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
    'project_history', 'project_comment', 'my_request_schema',
    'account_schema', 'validity', 'project_schema', 'following_member',
    'account'
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

  def insert_formalizr(prefix, opts)
    content_tag(:div, '', id: 'form-wrapper') do
      json = opts.merge({
        prefix: prefix,
        validities: tie_validities
      }).to_json
      content_tag(:script, json, type: 'application/json')
    end
  end
end

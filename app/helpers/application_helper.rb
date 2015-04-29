module ApplicationHelper
  def path_to(arg)
    parent_id = params[:project_id] || params[:division_id]
    parent_path = "/#{parent_id}" if parent_id.present?
    if arg.is_a? Symbol
      "#{parent_path}/#{arg.to_s.pluralize}"
    else
      "#{parent_path}/#{arg['_type'].pluralize}/#{arg['id']}"
    end
  end

  def set_title(title)
    content_for :title, "#{title} - #{OpentieRenderer::Application.config.app_name}"
  end

  def group_switch_label
    labels = []
    labels << '企画' if my_projects.present?
    labels << '局' if my_divisions.present?
    labels.join('/')
  end

  def all_projects
    @json['all_projects'] || []
  end

  def my_projects
    @json['projects'] || []
  end

  def my_divisions
    @json['divisions'] || []
  end

  def all_request_schemata
    @json['all_request_schemata'] || []
  end
end

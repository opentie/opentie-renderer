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
end

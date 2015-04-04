module ApplicationHelper
  def path_to(arg)
    parent_id = params[:project_id] || params[:division_id]
    if arg.is_a? Symbol
      "/#{parent_id}/#{arg.to_s.pluralize}"
    else
      "/#{parent_id}/#{arg[:_type].pluralize}/#{arg[:id]}"
    end
  end

  def set_title(title)
    content_for :title, "#{title} - #{OpentieRenderer::Application.config.app_name}"
  end
end

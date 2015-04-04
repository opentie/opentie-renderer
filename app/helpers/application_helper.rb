module ApplicationHelper
  def path_to(arg)
    if arg.is_a? Symbol
      "/#{arg.to_s.pluralize}"
    else
      "/#{arg[:_type].pluralize}/#{arg[:id]}"
    end
  end
end

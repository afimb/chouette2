module TabsHelper

  def tab_link_to(model_or_name, link, current=nil)
    model_or_name = model_or_name.model_name.human(:count => 2).capitalize if Class === model_or_name
    current ||= request.path.start_with?(link)
    link_to model_or_name, link, :class => ("current" if current)
  end

end

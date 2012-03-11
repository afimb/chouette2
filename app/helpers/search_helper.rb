module SearchHelper

  def link_with_search(name, search, html_options = {})
    is_current = (@q and search.all? { |k,v| @q.send(k) == v })
    if is_current
      html_options[:class] = [html_options[:class], "current"].compact.join(" ")
    end
    link_to name, params.deep_merge("q" => search), html_options
  end

end

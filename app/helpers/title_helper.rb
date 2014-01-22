module TitleHelper

  def title(title = nil)
    if title
      @title = title 
    else
      @title
    end
  end
  
  def title_tag(title, options = nil)
    content_tag :h2, title(title).html_safe, options
  end

end

module ApplicationHelper
    
  def title
    base_title = "Rave App"
    if @title.nil? 
      return base_title
    else
      return @title
    end
  end
  
  def logo
    return image_tag("logo.png", :size => "40x40", :alt => "Sample App", :class => "round")
  end
  
end

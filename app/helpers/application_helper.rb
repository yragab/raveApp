module ApplicationHelper
    
  def title
    base_title = "Rave App"
    if @title.nil? 
      return base_title
    else
      return @title
    end
  end
  
end

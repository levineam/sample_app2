module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  #In plain English the below means "store the value inside the
  #"base_title" variable in the variable "full_title" IF the
  #"page_title" variable has no value, but if "page_title" does have a value
  # then store in the "full_title" variable the value store in the
  #"base_title" variable followed by the pipe symbol followed by
  #the value stored in the "page_title" variable
  
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end

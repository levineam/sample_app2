module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  # This works with the code in application.html.erb
  # Full_title(yield(:title))looks for a :title in the visited page,
  # if it finds one, it inserts it in place of the yield, the code
  # below says that if it can't find anything, display the "base_title"
  # if it finds something, then display the base_title, followed by
  # a pipe, followed by the what it found
  
  
  

  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end

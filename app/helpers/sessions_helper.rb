module SessionsHelper
  # Helpers are modules, modules are for packaging functions together
  #and including them in multiple places, they are automatically included
  #in Rails views
  
  # SessionsHelper is a module automatically generated by Rails when
  #we created the Sessions object (is that right?) which we are going to
  #use to make a module for authentication, as opposed to creating an
  #all new module just for authentication
  
  #WE'RE DEFINING METHODS: that's the whole point of this. E.g. the
  #para that begins "def signed_in?" is the code for creating a boolean
  #sign_in? method
  
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
      #saves the users remember token as a permanent cookie
      #cookies is a utility provided by rails, each cookie consists of a
      #"value" and optional "expires" date
    self.current_user = user
      #creates "current_user" which allows constructions such as:
      #<%= current_user.name %> and: redirect_to current_user
      
      # here "self" is necessary for the same reason it was in
      #self.remember_token, w/o it Ruby would only create a local variable
  end
  
  def signed_in?
    !current_user.nil?
    #“not” operator, written using an exclamation point ! and usually
    #read as “bang”, here a user is signed in if current_user is not nil
    #in plain english this is: "is the value of current_user not nil?"
  end
  
  def current_user=(user)
    @current_user = user
  end
    #note the odd equals sign. This simply defines the method
    #current_user= which is expressly designed to handle assignment to
    #current_user
  
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
    #self.current_user = user is an assignment, this line is special Ruby
    #syntax for defining such an assignment function
    
    #common but initially obscure ||= (“or equals”) assignment operator
    #(Box 8.2). Its effect is to set the @current_user instance variable
    #to the user corresponding to the remember token, but only if
    #@current_user is undefined. If defined, i.e. if current_user has
    #already been called, just returns @current_user w/o hitting the db
    
  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
    #moved from users_controller so can use in mp controller as well
    #"notice: "Please sign in." 
    #is a shortcut for:
    #flash[:notice] "Please sign in."
      #note: the newer ROR3T moves the "notice:" inside the deny_access
      #variable in the sessions_helper
    #redirect_to signin_path, same construction works for :error key,
    #but not :success
    
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  #the "session" facility provided by Rails is like a cookie variable
  #that auto-expires when the browser closes
  
  #request.fullpath retrieves the full path (URI) of the requested page
  
  #So the store_location method puts the requested URI in the "session"
  #variable under the key ":return_to"
  
  #NOTE: to make use of store_location, have to add it to the
  #signed_in_user before filter
end

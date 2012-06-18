class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  #by default all helpers are available in views, but not controllers,
  #this code puts the methods from the Sessions helper available both
  #in the views and the controllers
end

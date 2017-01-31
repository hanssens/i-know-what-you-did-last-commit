class CommitsController < ApplicationController
  
  def index

    # redirect user to login if not authorized
    if (!session[:token].present?)
      redirect_to :controller => 'home', :action => 'index'
    end

    @token = session[:token]
    client = Octokit::Client.new(:access_token => @token)

    user = client.user
    @foo = user.login
    
  end

end

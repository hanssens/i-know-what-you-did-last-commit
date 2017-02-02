class CommitsController < ApplicationController

  def index

    # redirect user to login if not authorized
    token = session[:token]
    if (!token.present?)
      redirect_to :controller => 'auth', :action => 'login'
    end

    
    @client = Octokit::Client.new(:access_token => token)
    @user = @client.user

    # fetch repositories that are accessible to the authenticated user.
    # this includes repositories owned by the authenticated user, 
    # repositories where the authenticated user is a collaborator, 
    # and repositories that the authenticated user has access to through 
    # an organization membership.
    
    # TODO: client.user.repositories

    # TODO: for each repository, get the commits for that user
    
    # docs: https://developer.github.com/v3/repos/#response
    @repos = @client.repositories(@user)


    # docs: https://developer.github.com/v3/repos/commits/#list-commits-on-a-repository
    #@repositories.each do |repo|
    first = @repos[0]
  end

end

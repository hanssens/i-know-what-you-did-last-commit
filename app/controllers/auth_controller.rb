class AuthController < ApplicationController

  # clientid as registered with github
  # https://github.com/settings/developers
  APP_CLIENT_ID = "...";
  APP_CLIENT_SECRET = "...";

  def login

    # redirect the user to github to get a token
    client = Octokit::Client.new
    url = client.authorize_url(APP_CLIENT_ID, :scope => 'read:org, repo')

    redirect_to url
  end

  def callback

    # fetch the user's access code from the params
    code = params[:code]

    # exchange the access code for a token
    # see also: http://developer.github.com/v3/oauth/#web-application-flow
    client = Octokit::Client.new
    token = client.exchange_code_for_token(code, APP_CLIENT_ID, APP_CLIENT_SECRET)

    # store `token.access_token` in session
    session[:token] = token[:access_token]

    # ... and redirect to the actual app
    redirect_to :controller => 'commits', :action => 'index'
  end

end

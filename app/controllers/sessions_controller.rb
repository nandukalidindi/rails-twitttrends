require 'pry'

class SessionsController < ApplicationController
  def setup
    strategy = request.env['omniauth.strategy']
    render :text => "Setup complete.", status: 404
  end

  def create
    credentials = request.env['omniauth.auth']['credentials']
    twitter_app = ConnectedApp.where(name: 'twitter').first_or_create
    twitter_app.token = credentials['token']
    twitter_app.token_secret = credentials['secret']
    twitter_app.save!
    redirect_to '/', status: 302
  end
end

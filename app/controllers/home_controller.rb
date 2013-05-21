class HomeController < ApplicationController
  before_filter :authorize
  def index
    @user=current_user
    @api_call = ApiCall.new

  end
end

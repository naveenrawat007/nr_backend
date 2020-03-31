class HomeController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def privacy_policy
  end

  def support
  end

  def contact_us
    Sidekiq::Client.enqueue_to_in("default",Time.now, FeedbackSendWorker, params[:f_name],params[:l_name],params[:email],params[:phone],params[:query])
  end

end

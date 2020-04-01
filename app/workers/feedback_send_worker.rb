class FeedbackSendWorker
  include Sidekiq::Worker

  def perform(fname, lname, email, phone, query)
    UserMailer.feedback(fname, lname, email, phone, query).deliver_now
  end
end

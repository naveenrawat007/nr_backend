class FeedbackSendWorker
  include Sidekiq::Worker

  def perform(fname, lname, phone, email, query)
    UserMailer.feedback(fname, lname, phone, email, query).deliver_now
  end
end

class WeeklyNewsletterNewSubscribersExtractJob < ApplicationJob
  queue_as :default

  def perform
    @users = User.all.where(db_status: true).select { |u| (u.confirmed? == true) && (u.profile.role.present? == false) && (u.updated_at >= (Date.today - 1.week)) }
    mail = UserMailer.with(users: @users).export_new_weekly_subscribers
    mail.deliver_later
    reschedule_job
  end

  def reschedule_job
    self.class.set(wait: 1.week).perform_later
  end

end

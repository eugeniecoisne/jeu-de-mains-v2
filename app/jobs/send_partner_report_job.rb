class SendPartnerReportJob < ApplicationJob
  queue_as :default

  def perform
    @users = User.all.where(db_status: true).select { |u| (u.confirmed? == true) && u.profile.role.present? && u.profile.ready == true }
    @users.each do |u|
      mail = UserMailer.with(user: u).partner_monthly_report
      mail.deliver_later
    end
    reschedule_job
  end

  def reschedule_job
    self.class.set(wait_until: (DateTime.now.to_date + 1.month).beginning_of_month.noon).perform_later
  end
end

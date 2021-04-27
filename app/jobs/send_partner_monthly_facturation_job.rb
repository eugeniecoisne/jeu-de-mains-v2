class SendPartnerMonthlyFacturationJob < ApplicationJob
  queue_as :default

  def perform

    Profile.all.where(db_status: true).select { |p| p.role.present? && p.ready == true }.each do |p|
      # facture de commission
      # relevé des transactions clients
      UserMailer.with(user: p.user).partner_monthly_facturation.deliver_later
    end
    reschedule_job
  end

  def reschedule_job
    self.class.set(wait_until: (Date.today + 1.month).noon).perform_later
  end
end

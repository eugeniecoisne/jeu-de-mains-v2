class CheckWorkshopStatusJob < ActiveJob::Base

  def perform

    @workshops = Workshop.all.where(status: 'en ligne', db_status: true).each do |w|
      if w.dates.count > 0
        to_come_dates_count = 0
        w.dates.each do |date|
          to_come_dates_count += 1 if date >= Date.today
        end
        w.update(status: 'hors ligne', verified: false) if to_come_dates_count == 0
      end
    end
    reschedule_job
  end

  def reschedule_job
    self.class.set(wait_until: Date.tomorrow.midnight).perform_later
  end
end

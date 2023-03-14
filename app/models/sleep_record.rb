class SleepRecord < ApplicationRecord
  belongs_to :user

  validate :end_time_after_start_time?
  validates :start_time, :end_time, :user_id, presence: true

  scope :within_last_week, -> { where(start_time: 1.week.ago..Time.now) }

  after_create :save_sleep_time

  def end_time_after_start_time?
    return unless end_time < start_time

    errors.add :end_date, 'must be after start time'
  end

  private

  def save_sleep_time
    sleep_time = (end_time - start_time).seconds.in_hours.to_i
    update_attribute(:sleep_time, sleep_time)
  end
end

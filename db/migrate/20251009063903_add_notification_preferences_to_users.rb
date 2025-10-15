class AddNotificationPreferencesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :daily_digest_enabled, :boolean
    add_column :users, :overdue_alerts_enabled, :boolean
    add_column :users, :due_today_alerts_enabled, :boolean
    add_column :users, :weekly_summary_enabled, :boolean
  end
end

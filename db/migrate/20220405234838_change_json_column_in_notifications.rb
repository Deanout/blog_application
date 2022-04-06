class ChangeJsonColumnInNotifications < ActiveRecord::Migration[7.0]
  def change
    change_column :notifications, :params, :jsonb, using: 'params::jsonb'
  end
end

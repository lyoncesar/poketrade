class UpdateAvgSendingOnExchange < ActiveRecord::Migration[6.0]
  def change
    change_column :exchanges, :avg_sending, :string
  end
end

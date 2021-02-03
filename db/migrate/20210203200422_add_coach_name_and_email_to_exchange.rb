class AddCoachNameAndEmailToExchange < ActiveRecord::Migration[6.0]
  def change
    add_column :exchanges, :coach_name, :string, default: ''
    add_column :exchanges, :coach_email, :string, default: ''
  end
end

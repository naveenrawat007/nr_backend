class AddColumnInUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :otp_code, :integer
    add_column :users, :otp_verified, :boolean, default: false
    add_column :users, :image, :string
  end
end

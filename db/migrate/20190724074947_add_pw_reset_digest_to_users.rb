class AddPwResetDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pw_reset_digest, :string
    add_column :users, :pw_reset_at, :datetime
  end
end

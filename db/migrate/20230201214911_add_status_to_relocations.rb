class AddStatusToRelocations < ActiveRecord::Migration[7.0]
  def change
    add_reference :relocations, :status, null: false, foreign_key: true
  end
end

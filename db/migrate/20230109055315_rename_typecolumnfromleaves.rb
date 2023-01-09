class RenameTypecolumnfromleaves < ActiveRecord::Migration[7.0]
  def change
    change_table :leaves do |t|
      t.rename :type, :leave_type
    end
  end
end

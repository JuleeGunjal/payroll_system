class ChangeTypeOfDate < ActiveRecord::Migration[7.0]
  def change
    change_column :salaries, :date, 'date USING CAST(date AS date)'
  end
end

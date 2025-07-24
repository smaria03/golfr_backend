class AddNumberOfHolesToScores < ActiveRecord::Migration[6.1]
  def change
    add_column :scores, :number_of_holes, :integer
  end
end

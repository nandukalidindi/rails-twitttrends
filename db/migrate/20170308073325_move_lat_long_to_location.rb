class MoveLatLongToLocation < ActiveRecord::Migration
  def change
    remove_column :tweets, :latitude
    remove_column :tweets, :longitude
    add_column :tweets, :location, :float, array: true, default: []
  end
end

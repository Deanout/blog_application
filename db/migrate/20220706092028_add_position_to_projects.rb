class AddPositionToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :position, :integer
    Project.order(:updated_at).each.with_index(1) do |project, index|
      project.update_column :position, index
    end
  end
end

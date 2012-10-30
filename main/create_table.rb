class CreateTable < ActiveRecord::Migration
  def change
    create_table :craw_users do |t|
      30.times do |i|
        val_type = ([12,19].include? i) ? :text : :string
        t.column "u_#{i}".to_sym,val_type
      end
      t.column :u_30,:boolean,:default=>false
      t.timestamps
    end
    add_index :craw_users, :u_1
  end
end

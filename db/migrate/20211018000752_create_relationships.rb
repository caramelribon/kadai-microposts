class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.references :user, null: false, foreign_key: true #usersテーブルを参照する
      t.references :follow, null: false, foreign_key: { to_table: :users } #{ to_table: :users }ではなく、trueのままだったら、followsテーブルを参照することになり、そんなテーブルないとエラーが出る

      t.timestamps
      
      t.index [:user_id, :follow_id], unique: true #user_idとfollow_idのペアで重複するものが保存されないようにするデータベースの設定
    end
  end
end

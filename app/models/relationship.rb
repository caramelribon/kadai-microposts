class Relationship < ApplicationRecord
  belongs_to :user #RelationshipモデルはUserモデルに所属しているという意味、Relation多 対　User一
  belongs_to :follow, class_name: 'User' #follow_idはfollowというモデルはなく、Userモデルを参照にするので、class_name: 'User'という設定が必要
end

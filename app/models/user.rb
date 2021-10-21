class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
    has_secure_password
    
    has_many :microposts
    #自分がフォローしているUserへの参照
    has_many :relationships 
    #フォローしているUser達、throughでhas_many: relationships の結果を中間テーブルとして指定
    #その中間テーブルのカラムの中でどれを参照先のidとすべきかを source: :follow で、選択
    has_many :followings, through: :relationships, source: :follow
    #自分をフォローしているUserへの参照、:reverses_of_relationship は筆者が命名したものなので、class_name: 'Relationship' で参照するクラスを指定
    #Railsの命名規則により、UserからRelationshipを取得するとき、user_id が使用されるが、逆方向では、foreign_key: 'follow_id' と指定して、 user_id 側ではないことを明示する
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id' 
    #自分をフォローしているUser達
    has_many :followers, through: :reverses_of_relationship, source: :user
    
    def follow(other_user)
        #自分自身ではないか
        unless self == other_user
        #すでにフォローしているか、findであれば、Relationshipモデル(クラス)のインスタンスを返し、なければ、createする
        self.relationships.find_or_create_by(follow_id: other_user.id)
        end
    end
    
    def unfollow(other_user)
        #other_userのfollow_idを取り出す
        relationship = self.relationships.find_by(follow_id: other_user.id)
        #アンフォローする、フォローがあれば
        relationship.destroy if relationship
    end
    
    def following?(other_user)
        #self.followings によりフォローしているUser達を取得し、include?(other_user) によって other_user が含まれていないかを確認
        self.followings.include?(other_user)
    end
    
    #following_ids はUserモデルの has_many :followings, ... によって自動的に生成されるメソッド
    #フォローユーザ+自分自身のMicropostをすべて取得する
    def feed_microposts
      Micropost.where(user_id: self.following_ids + [self.id])        
    end
    
    #userがfavorite(中間テーブル)に参照できる
    has_many :favorites
    # userがお気に入りしたmicropostをfavoriteを通して、参照できる
    has_many :favorited_micropsts, through: :favorites, source: :micropost
    
    def favorite(micropost)
        #すでにお気に入りしているか、findであれば、Favoriteモデル(クラス)のインスタンスを返し、なければ、createする
        self.favorites.find_or_create_by(micropost_id: micropost.id)
    end
    
    def unfavorite(micropost)
        #userのmicropost_idを取り出す
        favorite = self.favorites.find_by(micropost_id: micropost.id)
        #解除する、お気に入り登録されていれば
        favorite.destroy if favorite
    end
    
    def favorite?(micropost)
        #self.favorited_microposts.include? によりお気に入りしているmicropost達を取得し、include?(micropost)によってmicropostが含まれていないかを確認
        self.favorited_micropsts.include?(micropost)
    end
end

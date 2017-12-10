class User < ActiveRecord::Base
	has_many :pins, through: :pinnings
	has_many :pinnings, dependent: :destroy
	has_many :boards
	has_many :board_pinners, dependent: :destroy
	has_many :followers, dependent: :destroy
	
	has_secure_password

	validates_presence_of :first_name, :last_name, :email, :password
	validates_uniqueness_of :email

	def self.authenticate(email, password)
		 @user = User.find_by_email(email)
		 if !@user.nil?
		 	return @user if @user.authenticate(password)
		 end
		 nil
	end

	def followed
		Follower.where("follower_id=?", self.id).map {|f| f.user}
	end

	def not_followed
		User.all - self.followed - [self]
	end

	def user_followers
		self.followers.map {|f| User.find(f.follower_id)}
	end

	def full_name
		first_name + " " + last_name
	end

	def pinnable_boards
		self.boards + self.board_pinners.map { |bp| bp.board}
	end
end

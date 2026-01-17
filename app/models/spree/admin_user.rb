class Spree::AdminUser < Spree.base_class
  include Spree::UserMethods

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end

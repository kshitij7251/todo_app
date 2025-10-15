class Category < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  
  validates :name, presence: true, length: { minimum: 1, maximum: 50 }
  validates :color, presence: true
  validates :name, uniqueness: { scope: :user_id }
  
  # Predefined color options
  COLORS = [
    { name: 'Blue', value: 'bg-blue-100 text-blue-800 border-blue-200' },
    { name: 'Green', value: 'bg-green-100 text-green-800 border-green-200' },
    { name: 'Yellow', value: 'bg-yellow-100 text-yellow-800 border-yellow-200' },
    { name: 'Red', value: 'bg-red-100 text-red-800 border-red-200' },
    { name: 'Purple', value: 'bg-purple-100 text-purple-800 border-purple-200' },
    { name: 'Pink', value: 'bg-pink-100 text-pink-800 border-pink-200' },
    { name: 'Gray', value: 'bg-gray-100 text-gray-800 border-gray-200' }
  ].freeze
  
  def color_classes
    color.present? ? color : 'bg-gray-100 text-gray-800 border-gray-200'
  end
end

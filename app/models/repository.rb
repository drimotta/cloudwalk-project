class Repository < ApplicationRecord
  belongs_to :owner, class_name: "GithubUser"
  validates :name, uniqueness: { scope: %i[owner_id] }
end

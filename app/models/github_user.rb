class GithubUser < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  has_many :repositories, inverse_of: :owner, foreign_key: "owner_id"

  def fetch_repos
    current_repos = GithubUserReposLister.(name)

    self.class.transaction do
      current_repos.each do |repo|
        record = repositories.find_or_initialize_by(name: repo[:name])
        record.stars = repo[:stars]
        record.save!
      end

      destroy_obsolete_repos(current_repos)
    end
  end

  private

  def destroy_obsolete_repos(current_repos)
    names = current_repos.map { |repo| repo[:name] }
    repositories.where.not(name: names).destroy_all
  end
end

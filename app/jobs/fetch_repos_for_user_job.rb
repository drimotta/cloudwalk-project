class FetchReposForUserJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = GithubUser.find(user_id)

    user.fetch_repos
  end
end

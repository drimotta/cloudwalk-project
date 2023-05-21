class GhUsersController < ApplicationController
  def index
    ordered = GithubUser.order(:name)
    rendered = ordered.map { |user| format_user(user) }

    render json: rendered
  end

  def show
    rendered = format_user(github_user)
    rendered["repositories"] = github_user
      .repositories
      .select(:name, :stars)
      .order(:name)
      .map { |repo| { name: repo.name, stars: repo.stars } }

    render json: rendered
  end

  def fetch_repos
    FetchReposForUserJob.perform_later(github_user.id)
    render json: { message: "Fetching repos for user #{github_user.name}, please wait and check again at #{gh_user_path(github_user.name)} in a few moments" }
  end

  private

  def github_user
    @github_user ||= GithubUser.find_or_create_by(name: params.require(:name))
  end

  def format_user(user)
    {
      name: user.name,
      details_url: gh_user_path(user.name),
      fetch_repos_url: fetch_repos_gh_user_path(user.name),
    }
  end
end

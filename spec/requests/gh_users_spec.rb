require 'rails_helper'

RSpec.describe "gh_users", type: :request do
  let(:dhh_repos) do
    {
      "asset-hosting-with-minimum-ssl" => 79,
      "conductor" => 10,
    }
  end

  let!(:rails) do
    create(:github_user, name: "rails")
  end

  let!(:dhh) do
    create(:github_user, name: "dhh").tap do |user|
      entries = dhh_repos.map do |name, stars|
        { name: name, stars: stars }
      end

      user.repositories.create(entries)
    end
  end

  describe "GET /gh_users" do
    it "returns http success" do
      get "/gh_users"
      expect(JSON.parse(response.body)).to eq([
        { "name" => "dhh", "details_url" => "/gh_users/dhh", "fetch_repos_url" => "/gh_users/dhh/fetch_repos" },
        { "name" => "rails", "details_url" => "/gh_users/rails", "fetch_repos_url" => "/gh_users/rails/fetch_repos" },
      ])
    end
  end

  describe "GET /gh_users/:name" do
    it "returns http success" do
      get "/gh_users/dhh"
      expect(JSON.parse(response.body)).to eq({
        "name" => "dhh",
        "details_url" => "/gh_users/dhh",
        "fetch_repos_url" => "/gh_users/dhh/fetch_repos",
        "repositories" => dhh_repos.map do |name, stars|
          { "name" => name, "stars" => stars }
        end.sort { |a, b| a["name"] <=> b["name"] }
      })
    end
  end

  describe "PUT /gh_users/:name/fetch_repos" do
    it "returns http success" do
      put "/gh_users/dhh/fetch_repos"
      expect(JSON.parse(response.body)).to eq({
        "message" => "Fetching repos for user dhh, please wait and check again at /gh_users/dhh in a few moments"
      })
    end

    it "enqueues fetcher job" do
      expect { put "/gh_users/dhh/fetch_repos" }.to have_enqueued_job(FetchReposForUserJob).with(dhh.id)
    end
  end
end

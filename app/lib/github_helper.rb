require "net/http"

class GithubHelper
  def self.annotate_request(req)
    req["Accept"] = "application/vnd.github+json"
    req["Authorization"] = "Bearer #{ENV["GITHUB_SECRET"]}"
    req["X-GitHub-Api-Version"] = "2022-11-28"
  end
end

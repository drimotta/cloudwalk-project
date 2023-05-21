require "net/http"

class GithubUserReposLister
  def self.call(owner)
    root_url = "https://api.github.com/users/#{owner}/repos?per_page=100"
    page = 1
    repos = []

    loop do
      uri = URI("#{root_url}&page=#{page}")
      req = Net::HTTP::Get.new(uri)
      GithubHelper.annotate_request(req)
      http = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true)
      res = http.request(req)
      parsed = JSON.parse(res.body)

      break if parsed.size == 0

      repos += parsed.map { |repo| { name: repo["name"], stars: repo["stargazers_count"] } }
      page += 1
    end

    repos
  end
end

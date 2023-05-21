require "rails_helper"

RSpec.describe GithubHelper do
  describe ".annotate_request" do
    let(:addr) { "https://api.github.com/users/rails" }
    let(:uri) { URI(addr) }
    let(:req) { Net::HTTP::Get.new(uri) }

    it "transforms the request object with github rest API parameters" do
      described_class.annotate_request(req)
      expect(req["Accept"]).to eq("application/vnd.github+json")
      expect(req["X-GitHub-Api-Version"]). to eq("2022-11-28")
      expect(req["Authorization"]).to eq("Bearer #{ENV["GITHUB_SECRET"]}").and(
        not_eq("Bearer ") # ensure variable is set
      )
    end
  end
end

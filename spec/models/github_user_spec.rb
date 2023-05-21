require 'rails_helper'

RSpec.describe GithubUser, type: :model do
  describe "#fetch_repos" do
    let!(:user) { described_class.create(name: owner) }

    let(:owner) { "dhh" }
    let(:expectation) do
      {
        "asset-hosting-with-minimum-ssl" => 79,
        "conductor" => 65,
        "textmate-rails-bundle" => 36,
      }
    end

    it "creates new repos with found stars count" do
      VCR.use_cassette("dhh_repos_on_gh") do
        expect { user.fetch_repos }.to change(user.repositories, :count).by(3)
      end

      expectation.each do |repo, stars|
        expect(user.repositories.find_by(name: repo).stars).to eq(stars)
      end
    end

    context "some repos already exist" do
      let!(:existing) { user.repositories.create(name: "conductor", stars: 10) }

      it "does not duplicate repo entries" do
        VCR.use_cassette("dhh_repos_on_gh") do
          expect { user.fetch_repos }.to change(user.repositories, :count).by(2)
        end
      end

      it "updates existing repo entry stars count" do
        VCR.use_cassette("dhh_repos_on_gh") do
          user.fetch_repos
        end

        expectation.each do |repo, stars|
          expect(user.repositories.find_by(name: repo).stars).to eq(stars)
        end
      end

      context "preexisting repos not found in response" do
        let!(:obsolete) { user.repositories.create(name: "rails", stars: 10) }

        it "deletes obsolete repos, keeps existing repos" do
          VCR.use_cassette("dhh_repos_on_gh") do
            user.fetch_repos
          end

          expect { obsolete.reload }.to raise_error(ActiveRecord::RecordNotFound)
          expectation.each do |repo, stars|
            expect(user.repositories.find_by(name: repo).stars).to eq(stars)
          end
        end
      end
    end
  end
end

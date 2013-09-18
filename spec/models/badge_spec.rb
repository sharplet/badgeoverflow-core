require 'spec_helper'
require 'badgeoverflow/core/models/badges/badge'
require 'json'
require 'ostruct'

BADGES = {
  :Altruist => '{
    "badge_id": 222,
    "rank": "bronze",
    "name": "Altruist",
    "description": "First bounty you manually awarded on another person\'s question",
    "award_count": 3055,
    "badge_type": "named",
    "link": "http://stackoverflow.com/badges/222/altruist"
  }'
}

def parsed_badge_with_name(badge_name)
  JSON.parse(BADGES[badge_name])
end

describe StackOverflow::Badge do
  let(:badge_hash) { {"name" => "Badge"} }
  let(:user_id) { nil }
  let(:badge) { StackOverflow::Badge.new(badge_hash, user_id) }

  context "when initialised with #{parsed_badge_with_name(:Altruist)}" do
    let(:badge_hash) { parsed_badge_with_name(:Altruist) }

    it "has badge_id 222" do
      expect(badge.badge_id).to eq 222
    end
    it "has rank bronze" do
      expect(badge.rank).to eq "bronze"
    end
    it "has name Altruist" do
      expect(badge.name).to eq "Altruist"
    end
    it "has description \"First bounty you manually awarded on another person's question\"" do
      expect(badge.description).to eq "First bounty you manually awarded on another person's question"
    end
    it "has award_count 3055" do
      expect(badge.award_count).to eq 3055
    end
    it "has badge_type named" do
      expect(badge.badge_type).to eq "named"
    end
    it "has link http://stackoverflow.com/badges/222/altruist" do
      expect(badge.link).to eq "http://stackoverflow.com/badges/222/altruist"
    end

    context "and user id 123" do
      let(:user_id) { 123 }

      it "has user_id 123" do
        expect(badge.user_id).to eq 123
      end
    end
  end

  describe "::new" do
    context "with a name that is a badge subclass (Foobar < Badge)" do
      module StackOverflow; class Foobar < Badge; end; end

      let(:badge_hash) { {"name" => "Foobar"} }

      specify { expect(badge).to be_kind_of StackOverflow::Badge }
      specify { expect(badge).to be_kind_of StackOverflow::Foobar }
    end

    context "with a name that is not a badge subclass (Gorbypuff < OpenStruct)" do
      module StackOverflow; class Gorbypuff < OpenStruct; end; end

      let(:badge_hash) { {"name" => "Gorbypuff"} }

      specify { expect(badge).to be_kind_of StackOverflow::Badge }
      specify { expect(badge).not_to be_kind_of StackOverflow::Gorbypuff }
    end

    context "with a name containing spaces" do
      module StackOverflow; class NameWithSpaces < Badge; end; end

      let(:badge_hash) { {"name" => "Name With Spaces"} }

      specify { expect(badge).to be_kind_of StackOverflow::NameWithSpaces }
    end

    context "with a name containing dashes" do
      module StackOverflow; class NameWithDashes < Badge; end; end

      let(:badge_hash) { {"name" => "Name-With-Dashes"} }

      specify { expect(badge).to be_kind_of StackOverflow::NameWithDashes }
    end

    context "with a name containing '&'" do
      module StackOverflow; class NameWithAmp < Badge; end; end

      let(:badge_hash) { {"name" => "Name & With & Amp"} }

      specify { expect(badge).to be_kind_of StackOverflow::NameWithAmp }
    end

    context "with a tag name" do
      module StackOverflow; class TagBadge < Badge; end; end

      let(:badge_hash) { {"name" => "tag-badge"} }

      specify { expect(badge).to be_kind_of StackOverflow::TagBadge }
    end
  end

  describe "::series" do
    module StackOverflow
      class BadgeInSeries < Badge
        def series
          :the_series
        end
      end
    end

    it "defines the series on all instances" do
      badge = StackOverflow::BadgeInSeries.new('{"name":"Badge In Series"}', nil)
      expect(badge.series).to eq :the_series
    end

    it "defines the series on subclasses" do
      module StackOverflow; class BadgeSubclassInSeries < BadgeInSeries; end; end

      badge = StackOverflow::BadgeSubclassInSeries.new('{"name":"Badge Subclass In Series"}', nil)
      expect(badge.series).to eq :the_series
    end

    context "with a series name that isn't a symbol" do
      let(:bad_series_definition) {
        lambda { class Badness < Badge; series 'oh noes'; end }
      }

      specify { expect(&bad_series_definition).to raise_error }
    end
  end

  describe "<=>" do
    bronze = StackOverflow::Badge.new({"name" => "Badge", "rank" => "bronze"}, nil)
    silver = StackOverflow::Badge.new({"name" => "Badge", "rank" => "silver"}, nil)
    gold   = StackOverflow::Badge.new({"name" => "Badge", "rank" => "gold"}, nil)

    specify { expect(bronze < silver).to be_true }
    specify { expect(silver < gold).to be_true }
    specify { expect(bronze < gold).to be_true }
  end

  describe "#first_badges_in_series" do
    let(:bronze) { StackOverflow::Badge.new({"name" => "Badge", "rank" => "bronze"}, nil) }
    let(:silver) { StackOverflow::Badge.new({"name" => "Badge", "rank" => "silver"}, nil) }
    let(:gold)   { StackOverflow::Badge.new({"name" => "Badge", "rank" => "gold"}, nil) }

    let(:badges) { [bronze, silver, gold] }

    context "with 3 badges from the same series" do
      it "returns the bronze badge" do
        bronze.stub(:series) { :test_series }
        silver.stub(:series) { :test_series }
        gold.stub(:series) { :test_series }

        expect(StackOverflow::Badge.first_badges_in_series(badges)).to eq [bronze]
      end
    end

    context "with 3 badges from the different series" do
      it "returns all the badges" do
        bronze.stub(:series) { :first }
        silver.stub(:series) { :second }
        gold.stub(:series) { :third }

        expect(StackOverflow::Badge.first_badges_in_series(badges)).to eq [bronze, silver, gold]
      end
    end

    context "with a bronze badge from one series and a silver & gold from another" do
      it "returns the bronze and silver badges" do
        bronze.stub(:series) { :bronze }
        silver.stub(:series) { :silver }
        gold.stub(:series) { :silver }

        expect(StackOverflow::Badge.first_badges_in_series(badges)).to eq [bronze, silver]
      end
    end

    context "with three badges having no series" do
      it "returns all the badges" do
        bronze.stub(:series) { nil }
        silver.stub(:series) { nil }
        gold.stub(:series) { nil }

        expect(StackOverflow::Badge.first_badges_in_series(badges)).to eq [bronze, silver, gold]
      end
    end
  end

  describe "#progress_description" do
    it "returns the badge's description" do
      badge.stub(:description) { "The Description" }
      expect(badge.progress_description).to eq "The Description"
    end
  end
end

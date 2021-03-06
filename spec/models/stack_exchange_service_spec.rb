require 'spec_helper'
require 'badgeoverflow/core/models/stack_exchange_service'

describe StackExchangeService, '#fetch' do
  BASE_URL = "http://api.stackexchange.com/2.1"
  PARAMS = { site: "stackoverflow", page: 1, pagesize: 30 }

  def url_with(resource, params = nil)
    params ||= Hash.new
    "#{BASE_URL}/#{resource}/?#{PARAMS.merge(params).map{|k,v|"#{k}=#{v}"}.join('&')}"
  end

  let(:service)  { StackExchangeService.new }

  let(:resource) { :users }
  let(:body)     { '{"has_more": false}' }
  let(:params)   { nil }
  let(:endpoint) { url_with(resource,params) }

  before { stub_request(:get, endpoint).to_return(:body => body) }

  context "with no block given" do
    specify { expect { service.fetch(resource) }.not_to raise_error }

    context "with a valid response" do
      let(:body) { '{"items":[{"foo":"bar"}]}' }

      specify do
        expect(service.fetch(resource)).not_to be_nil
      end

      it "returns the same value that is yielded to the block" do
        yielded_args = nil
        returned_value = service.fetch(resource) do |args|
          yielded_args = args
        end

        expect(returned_value).to eq yielded_args
      end
    end
  end

  describe "requests" do
    context "with :users resource" do
      let(:resource) { :users }

      it "hits /users/ endpoint" do
        service.fetch(:users)
        a_request(:get, url_with("users")).should have_been_made
      end
    end

    context "with :badges resource" do
      let (:resource) { :badges }

      it "hits /badges/ endpoint" do
        service.fetch(:badges)
        a_request(:get, url_with("badges")).should have_been_made
      end
    end
  end

  describe "responses" do
    context "with no 'items' key" do
      before { stub_request(:get, endpoint).to_return(:body => '{"has_more": false}') }

      specify { expect { |b| service.fetch(resource, &b) }.to yield_with_args([]) }
    end

    context "with 2 pages" do
      let(:first_page_body)  { '{"items":[{"foo":"bar"}],"has_more": true}' }
      let(:second_page_body) { '{"items":[{"baz":"quux"}],"has_more": false}' }

      before do
        stub_request(:get, url_with(:badges, :page => 1)).to_return(:body => first_page_body)
        stub_request(:get, url_with(:badges, :page => 2)).to_return(:body => second_page_body)
      end

      it "requests page 2" do
        service.fetch(:badges, fetch_all_pages: true)
        a_request(:get, url_with(:badges, :page => 2)).should have_been_made
      end

      it "yields the concatenated array of items" do
        expected_args = [{"foo"=>"bar"},{"baz"=>"quux"}]
        expect { |b| service.fetch(:badges, fetch_all_pages: true, &b) }.to yield_with_args expected_args
      end

      context "and fetch_all_pages is false" do
        it "doesn't request page 2" do
          service.fetch(:badges, fetch_all_pages: false)
          a_request(:get, url_with(:page => 2)).should_not have_been_made
        end
      end
    end
  end
end

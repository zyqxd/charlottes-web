# frozen_string_literal: true

module Engineering
  class PrsController < ApplicationController
    def index
      @pull_requests = GithubPullRequest.all
    end

    def show
      @pull_request = GithubPullRequest.find(params[:id])
    end
  end
end

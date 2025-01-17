# frozen_string_literal: true

module DiscourseTopicVoting
  module UserExtension
    def self.prepended(base)
      base.class_eval do
        has_many :votes, class_name: "DiscourseTopicVoting::Vote", dependent: :destroy
      end
    end

    def vote_count
      topics_with_vote.length
    end

    def alert_low_votes?
      (vote_limit - vote_count) <= SiteSetting.voting_alert_votes_left
    end

    def topics_with_vote
      self.votes.where(archive: false)
    end

    def topics_with_archived_vote
      self.votes.where(archive: true)
    end

    def reached_voting_limit?
      vote_count >= vote_limit
    end

    def vote_limit
      SiteSetting.public_send("voting_tl#{self.trust_level}_vote_limit")
    end
  end
end

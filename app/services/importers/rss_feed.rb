# frozen_string_literal: true

module Importers
  class RssFeed

    attr_accessor :link

    def call(link)
      @link = link
      body_response = HTTParty.get(@link).body
      podigee_feed = Feedjira.parse(body_response)

      # In order to keep db consistency
      ActiveRecord::Base.transaction do
      podcast = create_podcast(podigee_feed)
      create_episode(podcast, podigee_feed)
      end
    end

    private

    def create_podcast(podigee_feed)
      # Feedjira default lacks some important methods
      Podcast.find_or_create_by!({
                                title: podigee_feed.title,
                                description: podigee_feed.description,
                                publication_date: podigee_feed.last_built,
                                image_url: podigee_feed.image&.url,
                                website_url: podigee_feed.url,
                                feed_url: @link
                              })
    end

    def create_episode(podcast, podigee_feed)
      podigee_feed.entries.each do |item|
        Episode.find_or_create_by!({
                                  title: item.title,
                                  number: item.itunes_episode.to_i,
                                  description: item.summary,
                                  duration: item.itunes_duration.to_i,
                                  # published_date: item.published,
                                  url: item.enclosure_url,
                                  podcast: podcast
                                })
      end
    end
  end
end

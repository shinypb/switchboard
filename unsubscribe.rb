#!/usr/bin/env ruby
require 'fire_hydrant'
require 'fire_hydrant/jacks/oauth_pubsub_jack'

hydrant = FireHydrant.new(YAML.load(File.read("fire_hydrant.yml")), false)
hydrant.jack!(OAuthPubSubJack)

hydrant.on_startup do
  defer :unsubscribed do
    begin
      pubsub.unsubscribe_from("/api/0.1/user/aumptqi5nzs9", @oauth_consumer, @oauth_token)
    rescue Jabber::ServerError => e
      puts e
    end
  end

  # define here or as hydrant.subscriptions_received
  def unsubscribed(successful)
    puts "Unsubscribe was successful." if successful
  end
end

hydrant.run!
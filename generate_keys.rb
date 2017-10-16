#!/usr/bin/ruby

require 'digest'

def random_secret
  Digest::SHA256.hexdigest(Random.rand.to_s)[0,60]
end

secrets = File.read(File.dirname(__FILE__) + "/vars/secrets.yml")

secrets_new = ""

secrets.split("\n").each do |line|
  if line.match /psk:/
    line.gsub! /psk:.*/, 'psk: ' + random_secret
  elsif line.match /secret\:/
    line.gsub! /secret:.*/, 'secret: ' + random_secret
  end
  secrets_new += line + "\n"
end

File.open(File.dirname(__FILE__) + "/vars/secrets.yml","w") do |f|
  f.write(secrets_new)
end

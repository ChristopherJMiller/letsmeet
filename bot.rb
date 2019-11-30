require 'discordrb'
require 'faraday'
require 'uri'
require 'date'

url = "https://www.when2meet.com/SaveNewEvent.php"

bot = Discordrb::Commands::CommandBot.new token: ENV["key"], prefix: '!'

bot.command :schedule do |event, *args|
  eventName = args.join(' ')

  dateList = []
  date = Date.today

  (1..7).each do |n|
    dateList << date.strftime("%Y-%m-%d")
    date = date.next_day
  end

  data = {
    NewEventName: eventName,
    DateTypes: 'SpecificDates',
    PossibleDates: dateList.join('|'),
    NoEarlierThan: 9,
    NoLaterThan: 17,
    TimeZone: 'America/New_York'
  }

  response = Faraday.post(url) do |req|
    req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
    req.body = URI.encode_www_form(data)
  end

  responseBody = response.inspect
  responseBody = responseBody[responseBody.index('window.location=')+17...responseBody.index('window.location=')+32]

  "https://www.when2meet.com#{responseBody}"
end

bot.run

class RoadTrip
  attr_reader :start_city, :end_city, :travel_time, :weather_at_eta

  def initialize(data)
    @start_city = data[:origin]
    @end_city = data[:destination]
    @travel_time = data[:directions][:route][:formattedTime]
    @time = data[:directions][:route][:time]
    @weather_at_eta = get_dest_weather(data[:forecast])
  end

  def get_dest_weather(forecast)
    {
      datetime: arrival_time(@time),
      temperature: temp_at_arrival(forecast),
      condition: condition_at_arrival(forecast)
    }
  end

  def arrival_time(time)
    (Time.now + time).strftime("%Y-%m-%d %H:%M")
  end

  def temp_at_arrival(forecast)
    data = {}
    forecast[:forecast][:forecastday].each do |day|
      if day[:date] == arrival_time(@time)[0..9]
        data = day
      end
    end

    temp = 0.0
    data[:hour].each do |hour|
      if hour[:time][0..12] == arrival_time(@time)[0..12]
        temp = hour[:temp_f]
      end
    end
    temp
  end

  def condition_at_arrival(forecast)
    data = {}
    forecast[:forecast][:forecastday].each do |day|
      if day[:date] == arrival_time(@time)[0..9]
        data = day
      end
    end

    condition = ""
    data[:hour].each do |hour|
      if hour[:time][0..12] == arrival_time(@time)[0..12]
        condition = hour[:condition][:text]
      end
    end
    condition
  end
end
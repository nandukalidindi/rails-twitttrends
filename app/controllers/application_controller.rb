class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def home
    @tweets = Tweet.search(params[:search], {lat: params[:lat], lon: params[:lng]}).records
    @hashtags = Tweet.get_frequent_words("hashtags")
    @keywords = Tweet.get_frequent_words("keywords")
    @tweet_count = @tweets.count
    @query = params[:search]
    gon.search = params[:search]
    @hash = Gmaps4rails.build_markers(@tweets) do |tweet, marker|
              # COURTESY: http://stackoverflow.com/questions/12691330/set-marker-color-when-using-google-maps-for-rails-gem-in-rails
              marker.picture({
                url: get_sentiment_icon(tweet.sentiment_type),
                width: 32,
                height: 32
              })
              marker.lat tweet.location[1]
              marker.lng tweet.location[0]
              marker.infowindow tweet.text
            end
  end

  private
  def get_sentiment_icon(type)
    # All facial expression GIFS
    # http://okik.me/images/forum/bbcode/emo/
    case type
    when 'positive'
      return "http://okik.me/images/forum/bbcode/emo/bigsmile.gif"
      # return "https://raw.githubusercontent.com/mahnunchik/markerclustererplus/master/images/heart30.png"
    when 'neutral'
      return "http://okik.me/images/forum/bbcode/emo/speechless.gif"
      # return "https://raw.githubusercontent.com/mahnunchik/markerclustererplus/master/images/heart40.png"
    when 'negative'
      return "http://okik.me/images/forum/bbcode/emo/devil.gif"
      # return "http://okik.me/images/forum/bbcode/emo/heart.gif"
    else
      return "http://maps.gstatic.com/mapfiles/api-3/images/spotlight-poi.png"
    end
  end
end

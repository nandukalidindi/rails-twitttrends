require 'elasticsearch/model'

class Tweet < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks


  ELASTICSEARCH_MAX_RESULTS = 10000
  mapping do
    indexes :text, type: 'string'
    indexes :location, type: 'geo_point'
  end

  def self.get_frequent_words(column, size = 10)
    search_definition = {
      size: 0,
      aggs: {
        column.to_sym => {
          terms: {
            field: "#{column}.raw",
            size: size
          }
        }
      }
    }
    __elasticsearch__.search(search_definition).response['aggregations'][column]['buckets']
  end

  def self.search(query = nil, options = {})
    options ||= {}

    if query == '*'
      search_definition = {
        query: {
          match_all: {}
        }
      }
      search_definition[:size] = ELASTICSEARCH_MAX_RESULTS
      return __elasticsearch__.search(search_definition)
    end

    # define search definition
    search_definition = {
      query: {
        bool: {
          must: []
        }
      }
    }

    unless options.blank?
      search_definition[:from] = 0
      search_definition[:size] = ELASTICSEARCH_MAX_RESULTS
    end

    # query
    if query.present?
      search_definition[:query][:bool][:must] << {
        multi_match: {
          query: query,
          fields: 'text'
        }
      }
    end

    # geo spatial
    if options[:lat].present? && options[:lon].present?
      options[:distance] ||= 100

      search_definition = {
        query: {
          bool: {
            filter: {
              geo_distance: {
                distance: "1000km",
                location: {
                  lat: options[:lat].to_f,
                  lon: options[:lon].to_f
                }
              }
            }
          }
        }
      }
      search_definition[:size] = ELASTICSEARCH_MAX_RESULTS
    end
    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    as_json(text: self.text, keywords: self.keywords, hashtags: self.hashtags).merge location: { lat: self.location[1], lon: self.location[0] }
  end
end

# Tweet.__elasticsearch__.create_index! force: true

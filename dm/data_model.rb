require 'data_mapper'
require 'dm-migrations'
require 'conf'

module DataModel

class Season
  include DataMapper::Resource

  property :id,      Serial
  has n, :divisions

  property :title,   String
  property :status,  Integer    # Playing / Finished
  property :start,   DateTime
  property :end,     DateTime
end

class Division
  include DataMapper::Resource

  property :id,      Serial
  belongs_to :season
  has n, :divisionplayers
  has n, :players, :through => :divisionplayers
  has n, :matches

  property :level,   Integer
  property :name,    String
  property :scoring, Integer
end

class Divisionplayer
  include DataMapper::Resource

  belongs_to :division, :key => true
  belongs_to :player, :key => true
end

class Player
  include DataMapper::Resource

  property :id,        Serial
  has n, :divisionplayers
  has n, :divisions, :through => :divisionplayers

  property :name,      String
  property :email,     String
  property :frequency, Integer
  property :extra,     Integer
end

class Match
  include DataMapper::Resource

  property :id,       Serial
  belongs_to :division

  property :round,    Integer

  property :pl1,      Integer
  property :pl2,      Integer
  property :pl3,      Integer
  property :pl4,      Integer

  property :score1a,  Integer  # p1+p2
  property :score1b,  Integer  # p3+p4
  property :score2a,  Integer  # p1+p3
  property :score2b,  Integer  # p2+p4
  property :score3a,  Integer  # p1+p4
  property :score3b,  Integer  # p2+p3

  property :played,   Boolean
  property :time,     DateTime
  property :duration, Integer
end

#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, Conf.settings.db_uri)
DataMapper.repository(:default).adapter.resource_naming_convention = DataMapper::NamingConventions::Resource::UnderscoredAndPluralizedWithoutModule
DataMapper.finalize

end

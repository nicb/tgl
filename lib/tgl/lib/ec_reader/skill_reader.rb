#
# $Id: skill_reader.rb 2 2011-01-16 01:15:24Z nicb $
#

require File.dirname(__FILE__) + '/csv_reader'

class SkillReader < CsvReader
  attr_reader :skills

public
  def initialize(df)
    super(df)
    @skills = []
  end

  def load
    data[1..data.size].each do
      |line|
      attrs = {}
      attrs[:name] = line[0]
      skill = Skill.create(attrs)
      1.upto(line.size-1) do
        |i|
        if line[i] == 'X'
          p = Partner.find_by_position(i)
          pskill = PartnerSkill.create(:skill => skill, :partner => p)
        end
      end
      @skills << skill
    end
    return @skills
  end

end

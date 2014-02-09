#
# $Id: work_package.rb 2 2011-01-16 01:15:24Z nicb $
#
# The kind of activities (columns in the A3.1 rows) can be:
#
# RTD => RTD
# DEMO => Demonstration
# COORD => Coordination
# SUPP => Support
# MGMT => Management
# OTHER => Other
#
# not all of these need to be present in projects. It depends from the kind of
# project: STREP has RTD, DEMO, MGMT, CSA has SUPP, MGMT, OTHER, etc.
# 
class WorkPackage < ActiveRecord::Base
  belongs_to :project
  belongs_to :leader, :class_name => 'Partner'
  has_many :efforts
  has_many :partners, :through => :efforts
  has_many :deliverables

  ACTIVITY_TYPES = [ 'RTD', 'DEMO', 'COORD', 'SUPP', 'MGMT', 'OTHER', ] unless defined?(ACTIVITY_TYPES)

  def number
    return 'WP' + position.to_s
  end

  def cap_text_number
    return NumberUtils::to_cap_string(position)
  end

  def deliverables_list
    return deliverables.map { |d| d.d_id }.join(', ')
  end

  def total_effort
    result = 0
    efforts.each do
      |e|
      result += e.person_months
    end
    return result
  end

private

  def pic_timeline_command_short(index, pic_title)
    command = 'time_line('
    return command + index.to_s + ',"\s-2' + pic_title + '\s0"'
  end

  def pic_timeline_command_long(index, pic_title)
    command = 'time_line2(' 
    pic_title_parts = pic_title.split(/\s+/)
    n = pic_title_parts.size
    half = (n.to_f/2.0).ceil
    first_half = pic_title_parts[0..half-1].join(' ')
    second_half = pic_title_parts[half..pic_title_parts.size].join(' ')
    return command + index.to_s + ',"\s-2' + first_half + '\s0","\s-2' + second_half + '\s0"'
  end

public

  def pic_timeline_command(index)
    result = ''
    pic_title = number + ' ' + name
    if pic_title.size > 20 && pic_title.count(' ') > 2
      result = pic_timeline_command_long(index, pic_title)
    else
      result = pic_timeline_command_short(index, pic_title)
    end
    return result
  end

  class <<self

    def project_effort
      result = 0
      wps = WorkPackage.find(:all)
      wps.each do
        |wp|
        result += wp.total_effort
      end
      return result
    end

  end

end

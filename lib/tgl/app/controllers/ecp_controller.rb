#
# $Id: ecp_controller.rb 2 2011-01-16 01:15:24Z nicb $
#
require File.dirname(__FILE__) + '/tex_controller'

class EcpController < TexController::Base

protected

  def individual_workpackage(wp)
    wp_template = 'ecp/individual_workpackage'
    dl_template = 'ecp/individual_workpackage_deliverables'
    wp_output = 'WP' + wp.position.to_s
    dl_output = 'WP' + wp.position.to_s + 'D'
    @wp = wp
    template_rendering(wp_template, wp_output, :tex)
    template_rendering(dl_template, dl_output, :tex)
  end

public

  def individual_workpackages
    workpackages = WorkPackage.find(:all, :order => :position)
    workpackages.each do
      |wp|
      individual_workpackage(wp)
    end
  end

protected

  def a3_1_form(p)
    pre_a3_1_template = 'ecp/preA3.1_template'
    pre_a3_1_form = Environment.admin_dir + '/' + p.partner_tag.sub(/--/,'-') + '-pre-A3.1'
    a3_1_template = 'ecp/A3.1_template'
    a3_1_form = Environment.admin_dir + '/' + p.partner_tag.sub(/--/,'-') + '-A3.1'
    @partner = p
    @project = Project.first
    template_rendering(pre_a3_1_template, pre_a3_1_form, :tex)
    template_rendering(a3_1_template, a3_1_form, :tex)
  end

public

  def a3_1_forms
    @partners = Partner.find(:all, :order => :position)
    @partners.each do
      |p|
      a3_1_form(p)
    end
    render(:tex => 'ecp/A3.1_full')
  end

  def partners
    @partners = Partner.find(:all, :order => 'position')
    render(:tex => 'ecp/participants')
  end

  def milestones
    @milestones = Milestone.find(:all, :order => 'position')
    render(:tex => 'ecp/milestones')
  end

  def workpackages
    @workpackages = WorkPackage.find(:all, :order => 'position')
    render(:tex => 'ecp/workpackages')
  end

  def macros
    @project = Project.first
    @workpackages = WorkPackage.find(:all, :order => 'position')
    @partners = Partner.find(:all, :order => 'position')
    @deliverables = Deliverable.find(:all, :order => 'work_package_id, number')
    @milestones = Milestone.find(:all, :order => 'position')
    render(:tex => 'ecp/macros')
  end

  def skills
    @partners = Partner.find(:all)
    @skills = Skill.find(:all)
    render(:tex => 'ecp/skills_matrix')
  end

  def effort
    @workpackages = WorkPackage.find(:all, :order => 'position')
    @partners = Partner.find(:all, :order => 'position')
    render(:tex => 'ecp/effort')
  end

  def deliverables
    @deliverables = Deliverable.find(:all, :order => 'work_package_id, number')
    render(:tex => 'ecp/deliverables')
  end

  def global_administrative_data
    @partners = Partner.find(:all, :order => 'position')
    render(:tex => 'ecp/administrative_data')
    render(:csv => 'admin', :collection => Partner::global_csv_dump)
  end

  def gantt
    @project = Project.first
    @now = Time.now
    comment_tag = '.\\"'
    render(:pic => 'ecp/gantt')
  end

  def administrative_data
    global_administrative_data
  end

  def build_global_tables
    tables =
    [
      :macros,
      :partners,
      :milestones,
      :workpackages,
      :deliverables,
      :individual_workpackages,
      :skills,
      :effort,
      :administrative_data,
      :a3_1_forms,
      :gantt,
    ]
    tables.each do
      |t|
      send(t)
    end
  end

end
